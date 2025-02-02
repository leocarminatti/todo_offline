import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:mocktail/mocktail.dart';
import 'package:todo_offline/domain/domain.dart';
import 'package:todo_offline/ui/ui.dart';

class MockCreateTaskUseCase extends Mock implements CreateTaskUseCase {}

class MockGetTasksUseCase extends Mock implements GetTasksUseCase {}

class MockSearchTaskUseCase extends Mock implements SearchTaskUseCase {}

class MockDeleteTaskUseCase extends Mock implements DeleteTaskUseCase {}

class MockToggleTaskStatusUseCase extends Mock
    implements ToggleTaskStatusUseCase {}

void main() {
  late TaskCubit taskCubit;
  late MockCreateTaskUseCase mockCreateTaskUseCase;
  late MockGetTasksUseCase mockGetTasksUseCase;
  late MockSearchTaskUseCase mockSearchTaskUseCase;
  late MockDeleteTaskUseCase mockDeleteTaskUseCase;
  late MockToggleTaskStatusUseCase mockToggleTaskStatusUseCase;

  setUpAll(() {
    registerFallbackValue(Task(id: '', title: '', description: ''));
  });

  setUp(() {
    mockCreateTaskUseCase = MockCreateTaskUseCase();
    mockGetTasksUseCase = MockGetTasksUseCase();
    mockSearchTaskUseCase = MockSearchTaskUseCase();
    mockDeleteTaskUseCase = MockDeleteTaskUseCase();
    mockToggleTaskStatusUseCase = MockToggleTaskStatusUseCase();

    taskCubit = TaskCubit(
      createTask: mockCreateTaskUseCase,
      getTasks: mockGetTasksUseCase,
      searchTask: mockSearchTaskUseCase,
      deleteTask: mockDeleteTaskUseCase,
      toggleTaskStatus: mockToggleTaskStatusUseCase,
    );
  });

  tearDown(() {
    taskCubit.close();
  });

  final tasks = List.generate(
    15,
    (index) => Task(
        id: '$index', title: 'Task $index', description: '', isChecked: false),
  );

  test('fetchTasks deve carregar a primeira página corretamente', () async {
    when(() => mockGetTasksUseCase(onlyCompleted: false))
        .thenAnswer((_) async => fpdart.right(tasks));

    await taskCubit.fetchTasks(reset: true);

    final state = taskCubit.state;
    expect(state, isA<TaskSuccess>());
    final successState = state as TaskSuccess;
    expect(successState.tasks.length, 10);
    expect(successState.hasMore, isTrue);
  });

  test('fetchTasks deve carregar mais páginas corretamente', () async {
    when(() => mockGetTasksUseCase(onlyCompleted: false))
        .thenAnswer((_) async => fpdart.right(tasks));

    await taskCubit.fetchTasks(reset: true);
    await taskCubit.fetchTasks();

    final state = taskCubit.state;
    expect(state, isA<TaskSuccess>());
    final successState = state as TaskSuccess;
    expect(successState.tasks.length, 15);
    expect(successState.hasMore, isFalse);
  });

  test('fetchTasks deve parar de carregar quando não há mais tasks', () async {
    when(() => mockGetTasksUseCase(onlyCompleted: false))
        .thenAnswer((_) async => fpdart.right(tasks.take(8).toList()));

    await taskCubit.fetchTasks(reset: true);

    final state = taskCubit.state;
    expect(state, isA<TaskSuccess>());
    final successState = state as TaskSuccess;
    expect(successState.tasks.length, 8);
    expect(successState.hasMore, isFalse);
  });

  blocTest<TaskCubit, TaskState>(
    'Emite [TaskLoading, TaskSuccess] ao adicionar uma nova tarefa com sucesso',
    build: () {
      when(() => mockCreateTaskUseCase(any()))
          .thenAnswer((_) async => fpdart.right(true));
      when(() => mockGetTasksUseCase()).thenAnswer((_) async => fpdart.right([
            Task(id: '1', title: 'Teste', description: 'Descrição'),
          ]));
      return taskCubit;
    },
    act: (cubit) => cubit
        .addNewTask(Task(id: '1', title: 'Teste', description: 'Descrição')),
    expect: () => [
      isA<TaskCreationLoading>(),
      isA<TaskCreationSuccess>(),
      isA<TaskLoading>(),
      isA<TaskSuccess>(),
    ],
  );

  blocTest<TaskCubit, TaskState>(
    'Emite [TaskLoading, TaskError] ao falhar ao adicionar uma nova tarefa',
    build: () {
      when(() => mockCreateTaskUseCase(any()))
          .thenAnswer((_) async => fpdart.left('Erro ao adicionar tarefa'));
      return taskCubit;
    },
    act: (cubit) => cubit
        .addNewTask(Task(id: '1', title: 'Erro', description: 'Descrição')),
    expect: () => [
      isA<TaskCreationLoading>(),
      isA<TaskCreationError>(),
    ],
  );

  blocTest<TaskCubit, TaskState>(
    'Emite [TaskLoading, TaskSuccess] ao deletar uma tarefa com sucesso',
    build: () {
      when(() => mockDeleteTaskUseCase(any()))
          .thenAnswer((_) async => fpdart.right(null));
      when(() => mockGetTasksUseCase()).thenAnswer((_) async => fpdart.right([
            Task(id: '2', title: 'Tarefa Restante', description: 'Descrição'),
          ]));
      return taskCubit;
    },
    act: (cubit) => cubit.removeTask('1'),
    expect: () => [
      isA<TaskLoading>(),
      isA<TaskLoading>(),
      isA<TaskSuccess>(),
    ],
  );

  blocTest<TaskCubit, TaskState>(
    'Emite [TaskLoading, TaskError] ao falhar na exclusão de uma tarefa',
    build: () {
      when(() => mockDeleteTaskUseCase(any()))
          .thenAnswer((_) async => fpdart.left('Erro ao deletar tarefa'));
      return taskCubit;
    },
    act: (cubit) => cubit.removeTask('1'),
    expect: () => [
      isA<TaskLoading>(),
      isA<TaskError>(),
    ],
  );

  test('searchTasks deve retornar apenas as tasks filtradas', () async {
    when(() => mockGetTasksUseCase(onlyCompleted: false))
        .thenAnswer((_) async => fpdart.right(tasks));

    await taskCubit.fetchTasks(reset: true);
    taskCubit.searchTasks("Task 1", reset: true);

    final state = taskCubit.state;
    expect(state, isA<TaskSuccess>());
    final successState = state as TaskSuccess;
    expect(successState.tasks.length, greaterThanOrEqualTo(1));
    expect(successState.hasMore, isFalse);
  });

  test('searchTasks deve carregar mais resultados paginados', () async {
    when(() => mockGetTasksUseCase(onlyCompleted: false))
        .thenAnswer((_) async => fpdart.right(tasks));

    await taskCubit.fetchTasks(reset: true);
    taskCubit.searchTasks("Task", reset: true);
    taskCubit.searchTasks("Task");

    final state = taskCubit.state;
    expect(state, isA<TaskSuccess>());
    final successState = state as TaskSuccess;
    expect(successState.tasks.length, 10);
    expect(successState.hasMore, isFalse);
  });

  blocTest<TaskCubit, TaskState>(
    'Emite [TaskLoading, TaskSuccess] ao atualizar o status de uma tarefa',
    build: () {
      when(() => mockToggleTaskStatusUseCase(any()))
          .thenAnswer((_) async => fpdart.right(true));
      when(() => mockGetTasksUseCase()).thenAnswer((_) async => fpdart.right([
            Task(id: '1', title: 'Teste', description: 'Descrição'),
          ]));
      return taskCubit;
    },
    act: (cubit) => cubit.toggleTask(Task(
        id: '1', title: 'Teste', description: 'Descrição', isChecked: true)),
    expect: () => [
      isA<TaskLoading>(),
      isA<TaskSuccess>(),
    ],
  );

  blocTest<TaskCubit, TaskState>(
    'Emite [TaskLoading, TaskError] ao falhar ao atualizar o status de uma tarefa',
    build: () {
      when(() => mockToggleTaskStatusUseCase(any()))
          .thenAnswer((_) async => fpdart.left('Erro ao atualizar tarefa'));
      return taskCubit;
    },
    act: (cubit) => cubit.toggleTask(Task(
        id: '1', title: 'Teste', description: 'Descrição', isChecked: true)),
    expect: () => [
      isA<TaskError>(),
    ],
  );
}
