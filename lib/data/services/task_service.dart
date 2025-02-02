import 'package:hive/hive.dart';

import '../data.dart';

class TaskService implements ITaskService {
  final Box<TaskModel> _box;

  TaskService(this._box);

  @override
  Future<void> addTask(TaskModel task) async {
    try {
      await _box.put(task.id, task);
    } catch (e) {
      throw Exception('Erro ao adicionar a tarefa: $e');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await _box.delete(taskId);
    } catch (e) {
      throw Exception('Erro ao deletar a tarefa: $e');
    }
  }

  @override
  Future<List<TaskModel>> getTasks({bool onlyCompleted = false}) async {
    try {
      return _box.values
          .where((task) => onlyCompleted ? task.isChecked : true)
          .toList();
    } catch (e) {
      throw Exception('Erro ao recuperar as tarefas: $e');
    }
  }
}
