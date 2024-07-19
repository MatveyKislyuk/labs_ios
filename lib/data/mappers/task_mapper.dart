import 'package:labs_ios/data/database/database.dart' as db;
import 'package:labs_ios/domain/entities/task.dart';
import 'package:drift/drift.dart';

class TaskMapper {
  static Task fromDb(db.Task task) {
    return Task(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      isFavourite: task.isFavourite,
      categoryId: task.categoryId,
      createdAt: task.createdAt,
      imageUrl: task.imageUrl,
    );
  }

  static db.TasksCompanion toDb(Task task) {
    return db.TasksCompanion(
      id: Value(task.id),
      title: Value(task.title),
      description: Value(task.description),
      isCompleted: Value(task.isCompleted),
      isFavourite: Value(task.isFavourite),
      categoryId: Value(task.categoryId),
      createdAt: Value(task.createdAt),
      imageUrl: Value(task.imageUrl),
    );
  }
}
