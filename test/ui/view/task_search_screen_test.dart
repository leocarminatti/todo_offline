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

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<TaskCubit>(
        create: (_) => mockTaskCubit,
        child: const TaskSearchScreen(),
      ),
    );
  }

  testWidgets('Exibe campo de pesquisa corretamente', (tester) async {
    when(() => mockTaskCubit.state).thenReturn(TaskSuccess([], false));

    await tester.pumpWidget(buildTestableWidget());

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('Exibe carregamento quando estado for TaskLoading',
      (tester) async {
    when(() => mockTaskCubit.state).thenReturn(TaskLoading());

    await tester.pumpWidget(buildTestableWidget());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Exibe mensagem de erro quando estado for TaskError',
      (tester) async {
    when(() => mockTaskCubit.state)
        .thenReturn(TaskError('Erro ao buscar tasks'));

    await tester.pumpWidget(buildTestableWidget());
    expect(find.text('Erro: Erro ao buscar tasks'), findsOneWidget);
  });

  testWidgets('Exibe mensagem quando não há resultados na pesquisa',
      (tester) async {
    when(() => mockTaskCubit.state).thenReturn(TaskSuccess([], false));

    await tester.pumpWidget(buildTestableWidget());
    expect(find.text('Nenhuma task encontrada'), findsOneWidget);
  });

  testWidgets('Exibe resultados ao pesquisar tarefas', (tester) async {
    final tasks = List.generate(
      3,
      (index) => Task(
          id: '$index',
          title: 'Task $index',
          description: '',
          isChecked: false),
    );

    when(() => mockTaskCubit.state).thenReturn(TaskSuccess(tasks, true));

    await tester.pumpWidget(buildTestableWidget());
    expect(find.byType(TaskCard), findsNWidgets(3));
  });
}
