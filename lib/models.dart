import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Category {
  String id;
  String name;
  DateTime createdAt;

  Category({required this.name})
      : id = uuid.v4(),
        createdAt = DateTime.now();
}

class Task {
  String id;
  String title;
  String description;
  bool isCompleted;
  bool isFavourite;
  DateTime createdAt;
  String categoryId;

  Task({
    required this.title,
    required this.description,
    required this.categoryId,
    this.isCompleted = false,
    this.isFavourite = false,
  })  : id = uuid.v4(),
        createdAt = DateTime.now();
}
