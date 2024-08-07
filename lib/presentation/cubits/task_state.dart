import 'package:equatable/equatable.dart';
import 'package:labs_ios/domain/entities/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final TaskFilter currentFilter;

  const TaskLoaded(this.tasks, {required this.currentFilter});

  @override
  List<Object> get props => [tasks, currentFilter];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}


enum TaskFilter {
  All,
  Completed,
  Uncompleted,
  Favorites,
}
