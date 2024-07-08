import 'package:labs_ios/domain/entities/task.dart';
import 'package:labs_ios/domain/repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Future<List<Task>> call(String categoryId) async {
    return await repository.getTasks(categoryId);
  }
}