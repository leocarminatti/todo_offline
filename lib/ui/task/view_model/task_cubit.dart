import 'package:bloc/bloc.dart';

import '../../../domain/domain.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final CreateTaskUseCase createTask;
  final GetTasksUseCase getTasks;
  final SearchTaskUseCase searchTask;
  final DeleteTaskUseCase deleteTask;

  TaskCubit({
    required this.createTask,
    required this.getTasks,
    required this.searchTask,
    required this.deleteTask,
  }) : super(TaskInitial());

  Future<void> fetchTasks({bool onlyCompleted = false}) async {
    emit(TaskLoading());
    final result = await getTasks(onlyCompleted: onlyCompleted);
    result.match(
      (failure) => emit(TaskError(failure)),
      (tasks) => emit(TaskSuccess(tasks)),
    );
  }

  Future<void> addNewTask(Task task) async {
    emit(TaskLoading());
    final result = await createTask(task);
    result.match(
      (failure) => emit(TaskError(failure)),
      (_) async => await fetchTasks(),
    );
  }

  Future<void> searchTasks(String query) async {
    emit(TaskLoading());
    final result = await searchTask(query);
    result.match(
      (failure) => emit(TaskError(failure)),
      (tasks) => emit(TaskSuccess(tasks)),
    );
  }

  Future<void> removeTask(String taskId) async {
    emit(TaskLoading());
    final result = await deleteTask(taskId);
    result.match(
      (failure) => emit(TaskError(failure)),
      (_) async => await fetchTasks(),
    );
  }
}
