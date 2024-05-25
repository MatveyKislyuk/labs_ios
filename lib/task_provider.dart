import 'package:flutter/foundation.dart' as foundation;
import 'models.dart' as models;

enum TaskFilter {
  all,
  completed,
  incomplete,
  favourite,
}

class TaskProvider with foundation.ChangeNotifier {
  List<models.Category> _categories = [];
  List<models.Task> _tasks = [];

  List<models.Category> get categories => _categories;
  List<models.Task> get tasks => _tasks;

  void addCategory(String name) {
    _categories.add(models.Category(name: name));
    notifyListeners();
  }

  void deleteCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
    _tasks.removeWhere((task) => task.categoryId == id);
    notifyListeners();
  }

  void updateCategory(String id, String newName) {
    var category = _categories.firstWhere((category) => category.id == id);
    category.name = newName;
    notifyListeners();
  }

  void addTask(String title, String description, String categoryId) {
    _tasks.add(models.Task(title: title, description: description, categoryId: categoryId));
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void updateTask(models.Task updatedTask) {
    var index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void attachFileToTask(String taskId, String filePath) {
    var task = _tasks.firstWhere((task) => task.id == taskId);
    task.attachedFiles.add(filePath);
    notifyListeners();
  }

  List<models.Task> getTasksByCategory(String categoryId) {
    return _tasks.where((task) => task.categoryId == categoryId).toList();
  }

  List<models.Task> filterTasks(String categoryId, TaskFilter filter) {
    var tasks = getTasksByCategory(categoryId);
    switch (filter) {
      case TaskFilter.completed:
        return tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.incomplete:
        return tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.favourite:
        return tasks.where((task) => task.isFavourite).toList();
      case TaskFilter.all:
      default:
        return tasks;
    }
  }
}
