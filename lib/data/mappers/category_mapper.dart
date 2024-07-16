import 'package:labs_ios/data/database/database.dart' as db;
import 'package:labs_ios/domain/entities/category.dart';
import 'package:drift/drift.dart';

class CategoryMapper {
  static Category fromDb(db.Category category) {
    return Category(
      id: category.id,
      name: category.name,
      createdAt: category.createdAt,
    );
  }

  static db.CategoriesCompanion toDb(Category category) {
    return db.CategoriesCompanion(
      id: Value(category.id),
      name: Value(category.name),
      createdAt: Value(category.createdAt),
    );
  }
}
