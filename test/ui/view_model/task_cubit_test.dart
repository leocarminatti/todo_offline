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

void main() {
  late TaskCubit taskCubit;
  late MockCreateTaskUseCase mockCreateTaskUseCase;
  late MockGetTasksUseCase mockGetTasksUseCase;
  late MockSearchTaskUseCase mockSearchTaskUseCase;
  late MockDeleteTaskUseCase mockDeleteTaskUseCase;

  setUpAll(() {
    registerFallbackValue(Task(id: '', title: '', description: ''));
  });

  setUp(() {
    mockCreateTaskUseCase = MockCreateTaskUseCase();
    mockGetTasksUseCase = MockGetTasksUseCase();
    mockSearchTaskUseCase = MockSearchTaskUseCase();
    mockDeleteTaskUseCase = MockDeleteTaskUseCase();

    taskCubit = TaskCubit(
      createTask: mockCreateTaskUseCase,
      getTasks: mockGetTasksUseCase,
      searchTask: mockSearchTaskUseCase,
      deleteTask: mockDeleteTaskUseCase,
    );
  });

  tearDown(() {
    taskCubit.close();
  });

  blocTest<TaskCubit, TaskState>(
    'Emite [TaskLoading, TaskSuccess] ao buscar tarefas com sucesso',
    build: () {
      when(() => mockGetTasksUseCase()).thenAnswer((_) async => fpdart.right([
            Task(id: '1', title: 'Teste', description: 'Descrição'),
          ]));
      return taskCubit;
    },
    act: (cubit) => cubit.fetchTasks(),
    expect: () => [
      isA<TaskLoading>(),
      isA<TaskSuccess>(),
    ],
  );

  blocTest<TaskCubit, TaskState>(
    'Emite [TaskLoading, TaskError] ao falhar na busca de tarefas',
    build: () {
      when(() => mockGetTasksUseCase())
          .thenAnswer((_) async => fpdart.left('Erro ao buscar tarefas'));
      return taskCubit;
    },
    act: (cubit) => cubit.fetchTasks(),
    expect: () => [
      isA<TaskLoading>(),
      isA<TaskError>(),
    ],
  );

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
      isA<TaskLoading>(),
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
      isA<TaskLoading>(),
      isA<TaskError>(),
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

  blocTest<TaskCubit, TaskState>(
    'Emite [TaskLoading, TaskSuccess] ao buscar tarefas com sucesso',
    build: () {
      when(() => mockSearchTaskUseCase(any()))
          .thenAnswer((_) async => fpdart.right([
                Task(id: '1', title: 'Teste', description: 'Descrição'),
              ]));
      return taskCubit;
    },
    act: (cubit) => cubit.searchTasks('Teste'),
    expect: () => [
      isA<TaskLoading>(),
      isA<TaskSuccess>(),
    ],
  );

  blocTest<TaskCubit, TaskState>(
    'Emite [TaskLoading, TaskError] ao falhar na busca de tarefas',
    build: () {
      when(() => mockSearchTaskUseCase(any()))
          .thenAnswer((_) async => fpdart.left('Erro ao buscar tarefas'));
      return taskCubit;
    },
    act: (cubit) => cubit.searchTasks('Teste'),
    expect: () => [
      isA<TaskLoading>(),
      isA<TaskError>(),
    ],
  );
}
