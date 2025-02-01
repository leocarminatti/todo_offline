import 'package:fpdart/fpdart.dart' as fpdart;

import '../domain.dart';

abstract class ITaskRepository {
  Future<fpdart.Either<String, bool>> addTask(Task task);
  Future<fpdart.Either<String, void>> deleteTask(String taskId);
  Future<fpdart.Either<String, List<Task>>> getTasks(
      {bool onlyCompleted = false});
  Future<fpdart.Either<String, List<Task>>> searchTasks(String query);
}
