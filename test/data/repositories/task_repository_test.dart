import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_offline/data/data.dart';
import 'package:todo_offline/domain/domain.dart';

class MockTaskService extends Mock implements ITaskService {}

void main() {
  late ITaskRepository taskRepository;
  late MockTaskService mockTaskService;

  setUpAll(() {
    registerFallbackValue(
        TaskModel(id: '', title: '', description: '', isChecked: false));
  });

  setUp(() {
    mockTaskService = MockTaskService();
    taskRepository = TaskRepository(mockTaskService);

    when(() => mockTaskService.addTask(any())).thenAnswer((_) async {});
    when(() => mockTaskService.deleteTask(any())).thenAnswer((_) async {});
  });

  test('Adiciona uma nova tarefa com sucesso', () async {
    final task = Task(id: '1', title: 'Teste', description: 'Descrição');

    final result = await taskRepository.addTask(task);

    expect(result.isRight(), true);
    expect(result.getRight().toNullable(), true);
    verify(() => mockTaskService.addTask(any())).called(1);
  });

  test('Erro ao adicionar uma nova tarefa', () async {
    when(() => mockTaskService.addTask(any()))
        .thenThrow(Exception('Falha ao salvar'));

    final task = Task(id: '1', title: 'Erro', description: 'Falha esperada');
    final result = await taskRepository.addTask(task);

    expect(result.isLeft(), true);
    expect(
        result.getLeft().toNullable(), contains('Erro ao adicionar a tarefa'));
  });

  test('Deleta uma tarefa com sucesso', () async {
    final result = await taskRepository.deleteTask('1');

    expect(result.isRight(), true);
    verify(() => mockTaskService.deleteTask('1')).called(1);
  });

  test('Erro ao deletar uma tarefa', () async {
    when(() => mockTaskService.deleteTask(any()))
        .thenThrow(Exception('Falha ao deletar'));

    final result = await taskRepository.deleteTask('999');

    expect(result.isLeft(), true);
    expect(result.getLeft().toNullable(), contains('Erro ao deletar a tarefa'));
  });

  test('Recupera todas as tarefas com sucesso', () async {
    final taskModels = [
      TaskModel(id: '1', title: 'Teste 1', description: 'Descrição 1'),
      TaskModel(id: '2', title: 'Teste 2', description: 'Descrição 2')
    ];

    when(() => mockTaskService.getTasks()).thenAnswer((_) async => taskModels);

    final result = await taskRepository.getTasks();

    expect(result.isRight(), true);
    expect(result.getRight().toNullable()!.length, 2);
  });

  test('Erro ao buscar todas as tarefas', () async {
    when(() => mockTaskService.getTasks())
        .thenThrow(Exception('Erro ao carregar tarefas'));

    final result = await taskRepository.getTasks();

    expect(result.isLeft(), true);
    expect(
        result.getLeft().toNullable(), contains('Erro ao buscar as tarefas'));
  });

  test('Pesquisa tarefas pelo título com sucesso', () async {
    final taskModels = [
      TaskModel(id: '1', title: 'Comprar pão', description: 'Ir à padaria'),
      TaskModel(id: '2', title: 'Comprar leite', description: 'Supermercado'),
    ];

    when(() => mockTaskService.getTasks()).thenAnswer((_) async => taskModels);

    final result = await taskRepository.searchTasks('Comprar');

    expect(result.isRight(), true);
    expect(result.getRight().toNullable()!.length, 2);
    expect(result.getRight().toNullable()!.first.title, contains('Comprar'));
  });

  test('Erro ao pesquisar tarefas', () async {
    when(() => mockTaskService.getTasks())
        .thenThrow(Exception('Erro de pesquisa'));

    final result = await taskRepository.searchTasks('Erro');

    expect(result.isLeft(), true);
    expect(
        result.getLeft().toNullable(), contains('Erro ao pesquisar tarefas'));
  });
}
