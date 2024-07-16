import 'package:labs_ios/domain/entities/task.dart';
import 'package:labs_ios/domain/repositories/task_repository.dart';
import 'package:labs_ios/data/datasources/task_local_data_source.dart';
import 'package:labs_ios/data/mappers/task_mapper.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<List<Task>> getTasks(String categoryId) async {
    final tasks = await localDataSource.getTasksByCategoryId(categoryId);
    return tasks.map((task) => TaskMapper.fromDb(task)).toList();
  }

  @override
  Future<void> addTask(Task task) async {
    final taskCompanion = TaskMapper.toDb(task);
    await localDataSource.insertTask(taskCompanion);
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDataSource.deleteTask(id);
  }

  @override
  Future<void> updateTask(Task task) async {
    final taskCompanion = TaskMapper.toDb(task);
    await localDataSource.updateTask(taskCompanion);
  }
}
