import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_offline/domain/domain.dart';
import 'package:todo_offline/ui/ui.dart';

class MockTaskCubit extends MockCubit<TaskState> implements TaskCubit {}

void main() {
  late MockTaskCubit mockTaskCubit;

  setUp(() {
    mockTaskCubit = MockTaskCubit();
  });

  final tasks = List.generate(
    3,
    (index) => Task(
        id: '$index', title: 'Task $index', description: '', isChecked: true),
  );

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<TaskCubit>(
        create: (_) => mockTaskCubit,
        child: const TaskDoneScreen(),
      ),
    );
  }

  testWidgets('Exibe título "Tarefas concluídas"', (tester) async {
    when(() => mockTaskCubit.state).thenReturn(TaskSuccess(tasks, false));

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Tarefas concluídas'), findsOneWidget);
  });

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

  testWidgets('Exibe mensagem quando não há tarefas concluídas',
      (tester) async {
    when(() => mockTaskCubit.state).thenReturn(TaskSuccess([], false));

    await tester.pumpWidget(buildTestableWidget());
    expect(find.text('Nenhuma tarefa concluída ainda.'), findsOneWidget);
  });

  testWidgets('Exibe lista de tarefas concluídas corretamente', (tester) async {
    when(() => mockTaskCubit.state).thenReturn(TaskSuccess(tasks, false));

    await tester.pumpWidget(buildTestableWidget());

    expect(find.byType(Card), findsNWidgets(3));
    expect(find.byType(CustomCheckbox), findsNWidgets(3));
  });

  testWidgets('Clica no botão "Deletar todas" e chama o método correto',
      (tester) async {
    when(() => mockTaskCubit.state).thenReturn(TaskSuccess(tasks, false));
    when(() => mockTaskCubit.deleteAllCompletedTasks())
        .thenAnswer((_) async {});

    await tester.pumpWidget(buildTestableWidget());

    final deleteAllButton = find.text('Deletar todas');
    expect(deleteAllButton, findsOneWidget);

    await tester.tap(deleteAllButton);
    await tester.pump();

    verify(() => mockTaskCubit.deleteAllCompletedTasks()).called(1);
  });

  testWidgets(
      'Clica no botão de deletar uma tarefa e chama removeTask corretamente',
      (tester) async {
    final tasks = [
      Task(id: '1', title: 'Task 1', description: '', isChecked: true),
      Task(id: '2', title: 'Task 2', description: '', isChecked: true),
    ];

    when(() => mockTaskCubit.state).thenReturn(TaskSuccess(tasks, false));
    when(() => mockTaskCubit.removeTask(any())).thenAnswer((_) async {});

    await tester.pumpWidget(buildTestableWidget());

    final deleteButton = find.byIcon(Icons.delete).first;
    expect(deleteButton, findsOneWidget);

    await tester.tap(deleteButton);
    await tester.pump();

    verify(() => mockTaskCubit.removeTask('1')).called(1);
  });
}
