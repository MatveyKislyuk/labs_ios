import 'package:labs_ios/domain/entities/category.dart';
import 'package:labs_ios/domain/repositories/category_repository.dart';
import 'package:labs_ios/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:labs_ios/core/error/failures.dart';


class GetCategories extends UseCase<List<Category>, NoParams> {
  final CategoryRepository repository;

  GetCategories(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) async {
    try {
      final categories = await repository.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}

class NoParams {}