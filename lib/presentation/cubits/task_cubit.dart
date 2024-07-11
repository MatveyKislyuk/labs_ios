import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:labs_ios/domain/entities/task.dart' as task_entity;
import 'package:labs_ios/domain/usecases/add_task.dart';
import 'package:labs_ios/domain/usecases/delete_task.dart';
import 'package:labs_ios/domain/usecases/get_tasks.dart';
import 'package:labs_ios/domain/usecases/update_task.dart';
import 'package:labs_ios/core/error/failures.dart';
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
    initState();
  }

  void initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
  }

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
        final Either<Failure, List<task_entity.Task>> result = await getTasks(task.categoryId);
        result.fold(
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

  TextEditingController get titleController => _titleController;
  TextEditingController get descriptionController => _descriptionController;
}
