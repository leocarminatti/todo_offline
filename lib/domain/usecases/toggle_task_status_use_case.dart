import 'package:fpdart/fpdart.dart' as fpdart;

import '../domain.dart';

class ToggleTaskStatusUseCase {
  final ITaskRepository repository;

  ToggleTaskStatusUseCase(this.repository);

  Future<fpdart.Either<String, bool>> call(Task task) {
    return repository.toggleTaskStatus(task);
  }
}
