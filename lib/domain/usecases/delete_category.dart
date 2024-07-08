import 'package:labs_ios/domain/repositories/category_repository.dart';

class DeleteCategory {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  Future<void> call(String id) async {
    await repository.deleteCategory(id);
  }
}