import '../data.dart';

abstract class ITaskService {
  Future<void> addTask(TaskModel task);
  Future<void> deleteTask(String taskId);
  Future<List<TaskModel>> getTasks({bool onlyCompleted = false});
}
