import 'package:flutter/foundation.dart' as foundation;
import 'models.dart' as models;

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

  List<models.Task> getTasksByCategory(String categoryId) {
    return _tasks.where((task) => task.categoryId == categoryId).toList();
  }

  List<models.Task> filterTasks(String categoryId, String filter) {
    var tasks = getTasksByCategory(categoryId);
    if (filter == 'Completed') {
      return tasks.where((task) => task.isCompleted).toList();
    } else if (filter == 'Incomplete') {
      return tasks.where((task) => !task.isCompleted).toList();
    } else if (filter == 'Favourite') {
      return tasks.where((task) => task.isFavourite).toList();
    }
    return tasks;
  }
}
