import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_offline/domain/domain.dart';

import '../../models/mock_task_repository.dart';

void main() {
  late DeleteTaskUseCase deleteTaskUseCase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    deleteTaskUseCase = DeleteTaskUseCase(mockTaskRepository);
  });

  test('Deleta uma tarefa com sucesso', () async {
    when(() => mockTaskRepository.deleteTask('1'))
        .thenAnswer((_) async => right(null));

    final result = await deleteTaskUseCase.call('1');

    expect(result.isRight(), true);
  });

  test('Erro ao tentar deletar uma tarefa inexistente', () async {
    when(() => mockTaskRepository.deleteTask('999'))
        .thenAnswer((_) async => left('Tarefa não encontrada'));

    final result = await deleteTaskUseCase.call('999');

    expect(result.isLeft(), true);
    expect(result.getLeft().toNullable(), contains('Tarefa não encontrada'));
  });
}
