import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:todo_offline/domain/domain.dart';

class GetTasksUseCase {
  final ITaskRepository repository;

  GetTasksUseCase(this.repository);

  Future<fpdart.Either<String, List<Task>>> call({bool onlyCompleted = false}) {
    return repository.getTasks(onlyCompleted: onlyCompleted);
  }
}
