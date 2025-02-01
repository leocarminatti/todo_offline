import '../../domain/domain.dart';
import '../data.dart';

class TaskRepository implements ITaskRepository {
  final ITaskService _taskService;

  TaskRepository(this._taskService);

  @override
  Future<void> addTask(TaskModel task) => _taskService.addTask(task);

  @override
  Future<void> deleteTask(String taskId) => _taskService.deleteTask(taskId);

  @override
  Future<List<TaskModel>> getTasks({bool onlyCompleted = false}) =>
      _taskService.getTasks(onlyCompleted: onlyCompleted);
}
