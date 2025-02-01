import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:todo_offline/domain/domain.dart';

class SearchTaskUseCase {
  final ITaskRepository repository;

  SearchTaskUseCase(this.repository);

  Future<fpdart.Either<String, List<Task>>> call(String query) {
    if (query.isEmpty) {
      return repository.getTasks();
    }
    return repository.searchTasks(query);
  }
}
