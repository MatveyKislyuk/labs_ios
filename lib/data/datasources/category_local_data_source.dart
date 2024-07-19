import 'package:labs_ios/data/database/database.dart';
import 'package:drift/drift.dart';

class CategoryLocalDataSource {
  final AppDatabase database;

  CategoryLocalDataSource(this.database);

  Future<List<Category>> getAllCategories() => database.getAllCategories();
  Future<void> insertCategory(CategoriesCompanion category) => database.insertCategory(category);
  Future<void> updateCategory(CategoriesCompanion category) => database.updateCategory(category);
  Future<void> deleteCategory(String id) => database.deleteCategory(id);
}