import 'package:labs_ios/domain/entities/task.dart' as task_entity;
import 'package:labs_ios/domain/repositories/task_repository.dart';
import 'package:labs_ios/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:labs_ios/core/error/failures.dart';

class UpdateTask extends UseCase<void, task_entity.Task> {
  final TaskRepository repository;

  UpdateTask(this.repository);

  @override
  Future<Either<Failure, void>> call(task_entity.Task task) async {
    try {
      await repository.updateTask(task);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}