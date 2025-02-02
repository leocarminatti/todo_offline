import 'package:bloc/bloc.dart';

import '../../../domain/domain.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final CreateTaskUseCase createTask;
  final GetTasksUseCase getTasks;
  final SearchTaskUseCase searchTask;
  final DeleteTaskUseCase deleteTask;
  final ToggleTaskStatusUseCase toggleTaskStatus;

  final List<Task> _allTasks = [];
  final List<Task> _filteredTasks = [];

  int _currentPage = 0;
  bool _hasMore = true;
  bool _isLoading = false;

  int _currentSearchPage = 0;
  bool _hasMoreSearchResults = true;
  bool _isSearching = false;
  String _lastQuery = "";

  TaskCubit({
    required this.createTask,
    required this.getTasks,
    required this.searchTask,
    required this.deleteTask,
    required this.toggleTaskStatus,
  }) : super(TaskInitial());

  Future<void> fetchTasks(
      {bool onlyCompleted = false, bool reset = false}) async {
    if (_isLoading) return;
    _isLoading = true;

    if (reset) {
      _currentPage = 0;
      _hasMore = true;
      _allTasks.clear();
      emit(TaskLoading());
    }

    if (!_hasMore) {
      _isLoading = false;
      return;
    }

    final result = await getTasks(onlyCompleted: onlyCompleted);
    result.match(
      (failure) => emit(TaskError(failure)),
      (tasks) {
        List<Task> newTasks = tasks.skip(_currentPage * 10).take(10).toList();

        if (newTasks.length < 10) {
          _hasMore = false;
        }

        _allTasks.addAll(newTasks);
        _currentPage++;

        emit(TaskSuccess(List.from(_allTasks), _hasMore));
      },
    );

    _isLoading = false;
  }

  Future<void> addNewTask(Task task) async {
    emit(TaskCreationLoading());
    final result = await createTask(task);
    result.match(
      (failure) => emit(TaskCreationError(failure)),
      (_) {
        emit(TaskCreationSuccess());
        fetchTasks(reset: true);
      },
    );
  }

  void searchTasks(String query, {bool reset = false}) {
    if (_isSearching) return;
    _isSearching = true;

    if (reset || query != _lastQuery) {
      _currentSearchPage = 0;
      _hasMoreSearchResults = true;
      _filteredTasks.clear();
      _lastQuery = query;
    }

    if (!_hasMoreSearchResults) {
      _isSearching = false;
      return;
    }

    final results = _allTasks
        .where((task) => task.title.toLowerCase().contains(query.toLowerCase()))
        .skip(_currentSearchPage * 10)
        .take(10)
        .toList();

    if (results.length < 10) {
      _hasMoreSearchResults = false;
    }

    _filteredTasks.addAll(results);
    _currentSearchPage++;

    emit(TaskSuccess(List.from(_filteredTasks), _hasMoreSearchResults));
    _isSearching = false;
  }

  Future<void> removeTask(String taskId) async {
    emit(TaskLoading());
    final result = await deleteTask(taskId);
    result.match(
      (failure) => emit(TaskError(failure)),
      (_) async => await fetchTasks(reset: true),
    );
  }

  Future<void> toggleTask(Task task) async {
    final result = await toggleTaskStatus(task);
    result.match(
      (failure) => emit(TaskError(failure)),
      (_) {
        if (_lastQuery.isNotEmpty) {
          searchTasks(_lastQuery, reset: true);
        } else {
          fetchTasks(reset: true);
        }
      },
    );
  }

  Future<void> deleteAllCompletedTasks() async {
    if (state is TaskSuccess) {
      final tasks =
          (state as TaskSuccess).tasks.where((task) => task.isChecked).toList();
      for (var task in tasks) {
        await deleteTask(task.id);
      }
      fetchTasks(reset: true);
    }
  }
}
