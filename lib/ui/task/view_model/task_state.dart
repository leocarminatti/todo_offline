part of 'task_cubit.dart';

sealed class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskSuccess extends TaskState {
  final List<Task> tasks;
  final bool hasMore;

  TaskSuccess(this.tasks, this.hasMore);
}

class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}

class TaskCreationState extends TaskState {}

class TaskCreationLoading extends TaskCreationState {}

class TaskCreationSuccess extends TaskCreationState {}

class TaskCreationError extends TaskCreationState {
  final String message;
  TaskCreationError(this.message);
}
