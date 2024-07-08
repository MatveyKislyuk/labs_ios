import 'package:bloc/bloc.dart';
import 'package:labs_ios/domain/usecases/add_task.dart';
import 'package:labs_ios/domain/usecases/delete_task.dart';
import 'package:labs_ios/domain/usecases/get_tasks.dart';
import 'package:labs_ios/domain/usecases/update_task.dart';
import 'package:labs_ios/presentation/blocs/task_event.dart';
import 'package:labs_ios/presentation/blocs/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TaskInitial()) {
    on<LoadTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasks = await getTasks(event.categoryId);
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<AddNewTask>((event, emit) async {
      emit(TaskLoading());
      try {
        await addTask(event.task);
        final tasks = await getTasks(event.task.categoryId);
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<UpdateTaskEvent>((event, emit) async {
      try {
        await updateTask(event.task);
        final tasks = await getTasks(event.task.categoryId);
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<DeleteTaskEvent>((event, emit) async {
      try {
        await deleteTask(event.id);
        final categoryId = state is TaskLoaded
            ? (state as TaskLoaded).tasks.firstWhere((task) => task.id == event.id).categoryId
            : '';
        final tasks = await getTasks(categoryId);
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });
  }
}