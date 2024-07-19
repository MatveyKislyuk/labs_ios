import 'package:labs_ios/domain/entities/category.dart';
import 'package:labs_ios/domain/repositories/category_repository.dart';
import 'package:labs_ios/data/datasources/category_local_data_source.dart';
import 'package:labs_ios/data/mappers/category_mapper.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl(this.localDataSource);

  @override
  Future<List<Category>> getCategories() async {
    final categories = await localDataSource.getAllCategories();
    return categories.map((category) => CategoryMapper.fromDb(category)).toList();
  }

  @override
  Future<void> addCategory(Category category) async {
    final categoryCompanion = CategoryMapper.toDb(category);
    await localDataSource.insertCategory(categoryCompanion);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await localDataSource.deleteCategory(id);
  }

  @override
  Future<void> updateCategory(Category category) async {
    final categoryCompanion = CategoryMapper.toDb(category);
    await localDataSource.updateCategory(categoryCompanion);
  }
}
