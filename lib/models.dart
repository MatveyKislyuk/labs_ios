import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Category {
  final String id;
  String name;
  final DateTime createdAt;

  Category({required this.name})
      : id = uuid.v4(),
        createdAt = DateTime.now();
}

class Task {
  final String id;
  final String title;
  final String description;
  bool isCompleted;
  bool isFavourite;
  final DateTime createdAt;
  final String categoryId;

  Task({
    required this.title,
    required this.description,
    required this.categoryId,
    this.isCompleted = false,
    this.isFavourite = false,
  })  : id = uuid.v4(),
        createdAt = DateTime.now();
}
