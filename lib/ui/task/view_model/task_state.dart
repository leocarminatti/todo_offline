part of 'task_cubit.dart';

sealed class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskSuccess extends TaskState {
  final List<Task> tasks;
  TaskSuccess(this.tasks);
}

class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}
