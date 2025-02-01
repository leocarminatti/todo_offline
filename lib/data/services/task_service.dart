import 'package:hive/hive.dart';

import '../data.dart';

class TaskService implements ITaskService {
  static const String _boxName = 'tasks';
  final Box<TaskModel> _box;

  TaskService({Box<TaskModel>? box})
      : _box = box ?? Hive.box<TaskModel>(_boxName);

  @override
  Future<void> addTask(TaskModel task) async {
    await _box.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _box.delete(taskId);
  }

  @override
  Future<List<TaskModel>> getTasks({bool onlyCompleted = false}) async {
    return _box.values
        .where((task) => onlyCompleted ? task.isChecked : true)
        .toList();
  }
}
