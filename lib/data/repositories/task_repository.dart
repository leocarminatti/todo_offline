import 'package:fpdart/fpdart.dart' as fpdart;

import '../../domain/domain.dart';
import '../data.dart';

class TaskRepository implements ITaskRepository {
  final ITaskService _taskService;

  TaskRepository(this._taskService);

  @override
  Future<fpdart.Either<String, bool>> addTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await _taskService.addTask(taskModel);
      return fpdart.right(true);
    } catch (e) {
      return fpdart.left('Erro ao adicionar a tarefa: $e');
    }
  }

  @override
  Future<fpdart.Either<String, void>> deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      return fpdart.right(null);
    } catch (e) {
      return fpdart.left('Erro ao deletar a tarefa: $e');
    }
  }

  @override
  Future<fpdart.Either<String, List<Task>>> getTasks(
      {bool onlyCompleted = false}) async {
    try {
      final taskModels =
          await _taskService.getTasks(onlyCompleted: onlyCompleted);
      return fpdart
          .right(taskModels.map((taskModel) => taskModel.toEntity()).toList());
    } catch (e) {
      return fpdart.left('Erro ao buscar as tarefas: $e');
    }
  }

  @override
  Future<fpdart.Either<String, List<Task>>> searchTasks(String query) async {
    try {
      final taskModels = await _taskService.getTasks();
      final filteredTasks = taskModels
          .where(
              (task) => task.title.toLowerCase().contains(query.toLowerCase()))
          .map((taskModel) => taskModel.toEntity())
          .toList();
      return fpdart.right(filteredTasks);
    } catch (e) {
      return fpdart.left('Erro ao pesquisar tarefas: $e');
    }
  }

  @override
  Future<fpdart.Either<String, bool>> toggleTaskStatus(Task task) async {
    try {
      return await addTask(task);
    } catch (e) {
      return fpdart.left("Erro ao atualizar status da tarefa: $e");
    }
  }
}
