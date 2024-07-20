import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:labs_ios/domain/entities/task.dart' as task_entity;
import 'package:labs_ios/domain/usecases/add_task.dart';
import 'package:labs_ios/domain/usecases/delete_task.dart';
import 'package:labs_ios/domain/usecases/get_tasks.dart';
import 'package:labs_ios/domain/usecases/update_task.dart';
import 'package:labs_ios/core/error/failures.dart';
import 'package:labs_ios/data/datasources/flickr_service.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  TaskFilter currentFilter = TaskFilter.All;

  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskCubit({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TaskInitial()) {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  Future<void> close() {
    _titleController.dispose();
    _descriptionController.dispose();
    return super.close();
  }

  void initState(task_entity.Task task) {
    _titleController.text = task.title;
    _descriptionController.text = task.description ?? '';
    fetchImages('nature');
  }

  void disposeControllers() {
    _titleController.dispose();
    _descriptionController.dispose();
  }

  TextEditingController get titleController => _titleController;
  TextEditingController get descriptionController => _descriptionController;

  void loadTasks(String categoryId) async {
    emit(TaskLoading());
    final Either<Failure, List<task_entity.Task>> result = await getTasks(categoryId);
    result.fold(
          (failure) => emit(TaskError(failure.toString())),
          (tasks) => emit(TaskLoaded(tasks, currentFilter: TaskFilter.All)),
    );
  }

  void addNewTask(task_entity.Task task) async {
    emit(TaskLoading());
    final Either<Failure, void> result = await addTask(task);
    result.fold(
          (failure) => emit(TaskError(failure.toString())),
          (_) async {
        final Either<Failure, List<task_entity.Task>> result = await getTasks(task.categoryId);
        result.fold(
              (failure) => emit(TaskError(failure.toString())),
              (tasks) => emit(TaskLoaded(tasks, currentFilter: TaskFilter.All)),
        );
      },
    );
  }

  void modifyTask(task_entity.Task task) async {
    final Either<Failure, void> result = await updateTask(task);
    result.fold(
          (failure) => emit(TaskError(failure.toString())),
          (_) async {
        final Either<Failure, List<task_entity.Task>> updatedTasks = await getTasks(task.categoryId);
        updatedTasks.fold(
              (failure) => emit(TaskError(failure.toString())),
              (tasks) => emit(TaskLoaded(tasks, currentFilter: TaskFilter.All)),
        );
      },
    );
  }

  void deleteTaskById(String id) async {
    final Either<Failure, void> result = await deleteTask(id);
    result.fold(
          (failure) => emit(TaskError(failure.toString())),
          (_) async {
        final categoryId = state is TaskLoaded
            ? (state as TaskLoaded).tasks.firstWhere((task) => task.id == id).categoryId
            : '';
        final Either<Failure, List<task_entity.Task>> result = await getTasks(categoryId);
        result.fold(
              (failure) => emit(TaskError(failure.toString())),
              (tasks) => emit(TaskLoaded(tasks, currentFilter: TaskFilter.All)),
        );
      },
    );
  }

  void filterTasks(List<task_entity.Task> tasks, TaskFilter filter) {
    final currentFilter = filter;
    List<task_entity.Task> filteredTasks;
    switch (filter) {
      case TaskFilter.Completed:
        filteredTasks = tasks.where((task) => task.isCompleted).toList();
        break;
      case TaskFilter.Uncompleted:
        filteredTasks = tasks.where((task) => !task.isCompleted).toList();
        break;
      case TaskFilter.Favorites:
        filteredTasks = tasks.where((task) => task.isFavourite).toList();
        break;
      case TaskFilter.All:
      default:
        filteredTasks = tasks;
        break;
    }
    emit(TaskLoaded(filteredTasks, currentFilter: currentFilter));
  }

  void fetchImages(String query) async {
    try {
      final flickrService = FlickrService();
      final images = await flickrService.fetchImages(query, 1);
      emit(TaskImagesLoaded(images, 1));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void fetchMoreImages(String query) async {
    if (state is TaskImagesLoaded) {
      final currentState = state as TaskImagesLoaded;
      final newPage = currentState.page + 1;

      try {
        final flickrService = FlickrService();
        final images = await flickrService.fetchImages(query, newPage);
        final allImages = [...currentState.images, ...images];
        emit(TaskImagesLoaded(allImages, newPage));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    }
  }

  void selectImage(String? imageUrl) {
    if (imageUrl != null && state is TaskDetailLoaded) {
      emit(TaskDetailLoaded(
        (state as TaskDetailLoaded).task.copyWith(imageUrl: imageUrl),
        (state as TaskDetailLoaded).images,
      ));
    }
  }

  TextEditingController getTitleController() => _titleController;
  TextEditingController getDescriptionController() => _descriptionController;
}
