import 'package:labs_ios/domain/entities/category.dart';
import 'package:labs_ios/domain/repositories/category_repository.dart';
import 'package:labs_ios/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:labs_ios/core/error/failures.dart';


class UpdateCategory extends UseCase<void, Category> {
  final CategoryRepository repository;

  UpdateCategory(this.repository);

  @override
  Future<Either<Failure, void>> call(Category category) async {
    try {
      await repository.updateCategory(category);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}