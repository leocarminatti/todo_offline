import 'package:fpdart/fpdart.dart';
import 'package:todo_offline/domain/domain.dart';

class DeleteTaskUseCase {
  final ITaskRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<Either<String, void>> call(String taskId) {
    return repository.deleteTask(taskId);
  }
}
