import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_offline/configs/configs.dart';
import 'package:todo_offline/domain/domain.dart';
import 'package:todo_offline/ui/ui.dart';
import 'package:uuid/uuid.dart';

class MockTaskCubit extends MockCubit<TaskState> implements TaskCubit {}

void main() {
  late MockTaskCubit mockTaskCubit;

  setUpAll(() {
    registerFallbackValue(Task(id: '', title: '', description: ''));
  });

  setUp(() {
    mockTaskCubit = MockTaskCubit();
    getIt.registerSingleton<NavigationCubit>(NavigationCubit());
  });

  tearDown(() {
    getIt.reset();
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<TaskCubit>(
        create: (_) => mockTaskCubit,
        child: const TaskCreateScreen(),
      ),
    );
  }

  testWidgets('Renderiza a tela com o formulário corretamente', (tester) async {
    when(() => mockTaskCubit.state).thenReturn(TaskInitial());

    await tester.pumpWidget(buildTestableWidget());

    expect(find.byType(TaskForm), findsOneWidget);
  });

  testWidgets('Exibe carregamento quando estado for TaskCreationLoading',
      (tester) async {
    when(() => mockTaskCubit.state).thenReturn(TaskCreationLoading());

    await tester.pumpWidget(buildTestableWidget());

    expect(find.byType(Loading), findsOneWidget);
  });

  testWidgets('Criar uma nova tarefa com sucesso', (tester) async {
    final task = Task(
      id: const Uuid().v4(),
      title: 'Nova Tarefa',
      description: 'Descrição da tarefa',
      isChecked: false,
    );

    when(() => mockTaskCubit.addNewTask(any())).thenAnswer((_) async {});
    whenListen(
      mockTaskCubit,
      Stream.fromIterable([TaskCreationSuccess()]),
      initialState: TaskInitial(),
    );

    await tester.pumpWidget(buildTestableWidget());

    await tester.enterText(find.byType(TextField).first, task.title);
    await tester.enterText(find.byType(TextField).last, task.description);
    await tester.tap(find.byType(TextButton));
    await tester.pump();

    verify(() => mockTaskCubit.addNewTask(any())).called(1);

    expect(find.text('Tarefa adicionada com sucesso!'), findsOneWidget);
    expect(
      getIt<NavigationCubit>().state.index,
      equals(NavigationStateType.todo.value),
    );
  });

  testWidgets('Exibe erro ao criar uma nova tarefa', (tester) async {
    when(() => mockTaskCubit.addNewTask(any())).thenAnswer((_) async {});
    whenListen(
      mockTaskCubit,
      Stream.fromIterable([TaskCreationError('Erro ao criar tarefa')]),
      initialState: TaskInitial(),
    );

    await tester.pumpWidget(buildTestableWidget());

    await tester.enterText(find.byType(TextField).first, 'Erro Task');
    await tester.enterText(find.byType(TextField).last, 'Descrição do erro');
    await tester.tap(find.byType(TextButton));
    await tester.pump();

    expect(find.text('Erro: Erro ao criar tarefa'), findsOneWidget);
  });
}
