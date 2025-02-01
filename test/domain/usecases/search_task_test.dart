import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:mocktail/mocktail.dart';
import 'package:todo_offline/domain/domain.dart';

import '../../models/mock_task_repository.dart';

void main() {
  late SearchTaskUseCase searchTaskUseCase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    searchTaskUseCase = SearchTaskUseCase(mockTaskRepository);
  });

  test('Retorna tarefas que correspondem à pesquisa', () async {
    final tasks = [
      Task(id: '1', title: 'Comprar pão', description: 'Ir à padaria'),
      Task(id: '2', title: 'Comprar leite', description: 'Supermercado'),
    ];

    when(() => mockTaskRepository.searchTasks('Comprar'))
        .thenAnswer((_) async => fpdart.right(tasks));

    final result = await searchTaskUseCase.call('Comprar');

    expect(result.isRight(), true);
    expect(result.getRight().toNullable()!.length, 2);
  });

  test('Erro ao pesquisar tarefas', () async {
    when(() => mockTaskRepository.searchTasks('Erro'))
        .thenAnswer((_) async => fpdart.left('Erro ao pesquisar tarefas'));

    final result = await searchTaskUseCase.call('Erro');

    expect(result.isLeft(), true);
    expect(
        result.getLeft().toNullable(), contains('Erro ao pesquisar tarefas'));
  });
}
