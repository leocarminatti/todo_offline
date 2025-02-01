import 'package:todo_offline/data/data.dart';

class FakeTaskService implements TaskService {
  final Map<String, TaskModel> _fakeDB = {};

  @override
  Future<void> addTask(TaskModel task) async {
    _fakeDB[task.id] = task;
  }

  @override
  Future<void> deleteTask(String taskId) async {
    _fakeDB.remove(taskId);
  }

  @override
  Future<List<TaskModel>> getTasks({bool onlyCompleted = false}) async {
    return _fakeDB.values
        .where((task) => onlyCompleted ? task.isChecked : true)
        .toList();
  }
}
