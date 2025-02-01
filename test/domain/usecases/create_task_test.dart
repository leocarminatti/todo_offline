import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:mocktail/mocktail.dart';
import 'package:todo_offline/domain/domain.dart';

import '../../models/mock_task_repository.dart';

void main() {
  late CreateTaskUseCase createTaskUseCase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    createTaskUseCase = CreateTaskUseCase(mockTaskRepository);
  });

  test('Cria uma nova tarefa com sucesso', () async {
    final task = Task(id: '1', title: 'Teste', description: 'Descrição');

    when(() => mockTaskRepository.addTask(task))
        .thenAnswer((_) async => fpdart.right(true));

    final result = await createTaskUseCase.call(task);

    expect(result.isRight(), true);
    expect(result.getRight().toNullable(), true);
  });

  test('Erro ao tentar criar uma tarefa sem título', () async {
    final task = Task(id: '2', title: '', description: 'Sem título');

    final result = await createTaskUseCase.call(task);

    expect(result.isLeft(), true);
    expect(result.getLeft().toNullable(),
        contains('O título da tarefa não pode estar vazio'));
  });

  test('Erro ao tentar criar uma tarefa', () async {
    final task = Task(id: '2', title: 'teste', description: 'Sem título');

    when(() => mockTaskRepository.addTask(task))
        .thenAnswer((_) async => fpdart.left('Erro ao adicionar a tarefa'));

    final result = await createTaskUseCase.call(task);

    expect(result.isLeft(), true);
    expect(
        result.getLeft().toNullable(), contains('Erro ao adicionar a tarefa'));
  });
}
