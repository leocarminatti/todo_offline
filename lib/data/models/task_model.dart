import 'package:hive/hive.dart';
import 'package:todo_offline/domain/domain.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  bool isChecked;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.isChecked = false,
  });

  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      isChecked: isChecked,
    );
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      isChecked: task.isChecked,
    );
  }
}
