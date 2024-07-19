import 'package:labs_ios/data/database/database.dart';
import 'package:drift/drift.dart';

class TaskLocalDataSource {
  final AppDatabase database;

  TaskLocalDataSource(this.database);

  Future<List<Task>> getTasksByCategoryId(String categoryId) => database.getTasksByCategoryId(categoryId);
  Future<void> insertTask(TasksCompanion task) => database.insertTask(task);
  Future<void> updateTask(TasksCompanion task) => database.updateTask(task);
  Future<void> deleteTask(String id) => database.deleteTask(id);
}