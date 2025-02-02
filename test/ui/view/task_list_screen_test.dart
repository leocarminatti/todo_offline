import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_offline/configs/configs.dart';
import 'package:todo_offline/domain/domain.dart';
import 'package:todo_offline/ui/ui.dart';

class MockTaskCubit extends MockCubit<TaskState> implements TaskCubit {}

void main() {
  late MockTaskCubit mockTaskCubit;

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
        create: (context) => mockTaskCubit,
        child: const TaskListScreen(),
      ),
    );
  }

  testWidgets('Exibe carregamento quando estado for TaskLoading',
      (tester) async {
    when(() => mockTaskCubit.state).thenReturn(TaskLoading());

    await tester.pumpWidget(buildTestableWidget());
    expect(find.byType(Loading), findsOneWidget);
  });

  testWidgets('Exibe mensagem de erro quando estado for TaskError',
      (tester) async {
    when(() => mockTaskCubit.state)
        .thenReturn(TaskError('Erro ao carregar tasks'));

    await tester.pumpWidget(buildTestableWidget());
    expect(find.text('Erro: Erro ao carregar tasks'), findsOneWidget);
  });

  testWidgets('Exibe EmptyStateWidget quando não há tasks', (tester) async {
    when(() => mockTaskCubit.state).thenReturn(TaskSuccess([], false));

    await tester.pumpWidget(buildTestableWidget());
    expect(find.byType(EmptyStateWidget), findsNWidgets(1));
    expect(find.text('Nenhuma task encontrada'), findsOneWidget);
  });

  testWidgets('Exibe a lista de tasks corretamente', (tester) async {
    final tasks = List.generate(
      5,
      (index) => Task(
          id: '$index',
          title: 'Task $index',
          description: '',
          isChecked: false),
    );

    when(() => mockTaskCubit.state).thenReturn(TaskSuccess(tasks, true));

    await tester.pumpWidget(buildTestableWidget());
    expect(find.byType(TaskCard), findsNWidgets(5));
  });

  testWidgets('Clica no botão "Criar tarefa" e navega para a aba correta',
      (tester) async {
    when(() => mockTaskCubit.state).thenReturn(TaskSuccess([], false));

    if (!getIt.isRegistered<NavigationCubit>()) {
      getIt.registerSingleton<NavigationCubit>(NavigationCubit());
    }

    final navigationCubit = getIt<NavigationCubit>();

    await tester.pumpWidget(buildTestableWidget());

    final button = find.byType(CustomButton);
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(
      navigationCubit.state.index,
      equals(NavigationStateType.create.value),
    );
  });
}
