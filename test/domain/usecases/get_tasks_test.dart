import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:mocktail/mocktail.dart';
import 'package:todo_offline/domain/domain.dart';

import '../../models/mock_task_repository.dart';

void main() {
  late GetTasksUseCase getTasksUseCase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    getTasksUseCase = GetTasksUseCase(mockTaskRepository);
  });

  test('Retorna uma lista de tarefas', () async {
    final tasks = [
      Task(id: '1', title: 'Task 1', description: 'Descrição 1'),
      Task(id: '2', title: 'Task 2', description: 'Descrição 2')
    ];

    when(() => mockTaskRepository.getTasks())
        .thenAnswer((_) async => fpdart.right(tasks));

    final result = await getTasksUseCase.call();

    expect(result.isRight(), true);
    expect(result.getRight().toNullable()!.length, 2);
  });

  test('Erro ao buscar todas as tarefas', () async {
    when(() => mockTaskRepository.getTasks())
        .thenAnswer((_) async => fpdart.left('Erro ao buscar tarefas'));

    final result = await getTasksUseCase.call();

    expect(result.isLeft(), true);
    expect(result.getLeft().toNullable(), contains('Erro ao buscar tarefas'));
  });
}
