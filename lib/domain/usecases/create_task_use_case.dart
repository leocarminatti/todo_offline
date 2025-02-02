import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:todo_offline/domain/domain.dart';

class CreateTaskUseCase {
  final ITaskRepository repository;

  CreateTaskUseCase(this.repository);

  Future<fpdart.Either<String, bool>> call(Task task) {
    if (task.title.isEmpty) {
      return Future.value(
          fpdart.left('O título da tarefa não pode estar vazio'));
    }
    return repository.addTask(task);
  }
}
