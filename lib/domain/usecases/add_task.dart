import 'package:labs_ios/domain/entities/task.dart';
import 'package:labs_ios/domain/repositories/task_repository.dart';

class AddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  Future<void> call(Task task) async {
    await repository.addTask(task);
  }
}