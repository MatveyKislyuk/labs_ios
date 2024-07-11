import 'package:labs_ios/domain/entities/task.dart' as task_entity;
import 'package:labs_ios/domain/repositories/task_repository.dart';
import 'package:labs_ios/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:labs_ios/core/error/failures.dart';


class GetTasks extends UseCase<List<task_entity.Task>, String> {
  final TaskRepository repository;

  GetTasks(this.repository);

  @override
  Future<Either<Failure, List<task_entity.Task>>> call(String categoryId) async {
    try {
      final tasks = await repository.getTasks(categoryId);
      return Right(tasks);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}