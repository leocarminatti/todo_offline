import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:todo_offline/data/data.dart';

import '../../fakes/fakes.dart';

class MockHiveBox extends Mock implements Box<TaskModel> {}

void main() {
  late TaskService taskService;
  late MockHiveBox mockHiveBox;
  bool isAdapterRegistered = false;

  setUp(() async {
    mockHiveBox = MockHiveBox();
    taskService = TaskService(mockHiveBox);

    PathProviderPlatform.instance = FakePathProviderPlatform();

    final tempDir = Directory.systemTemp.path;
    Hive.init(tempDir);

    if (!isAdapterRegistered) {
      Hive.registerAdapter(TaskModelAdapter());
      isAdapterRegistered = true;
    }
  });

  test('Adiciona uma tarefa no Hive com sucesso', () async {
    final task = TaskModel(id: '1', title: 'Teste', description: 'Descrição');

    when(() => mockHiveBox.put(task.id, task)).thenAnswer((_) async {});

    await taskService.addTask(task);

    verify(() => mockHiveBox.put(task.id, task)).called(1);
  });

  test('Deleta uma tarefa do Hive com sucesso', () async {
    when(() => mockHiveBox.delete('1')).thenAnswer((_) async {});

    await taskService.deleteTask('1');

    verify(() => mockHiveBox.delete('1')).called(1);
  });

  test('Retorna todas as tarefas do Hive', () async {
    final task1 = TaskModel(id: '1', title: 'Task 1', description: 'Desc 1');
    final task2 = TaskModel(id: '2', title: 'Task 2', description: 'Desc 2');
    final List<TaskModel> tasks = [task1, task2];

    when(() => mockHiveBox.values).thenReturn(tasks);

    final result = await taskService.getTasks();

    expect(result.length, 2);
    expect(result.first.title, 'Task 1');
    expect(result.last.title, 'Task 2');
  });

  test('Retorna apenas tarefas finalizadas do Hive', () async {
    final task1 = TaskModel(
        id: '1', title: 'Task 1', description: 'Desc 1', isChecked: true);
    final task2 = TaskModel(
        id: '2', title: 'Task 2', description: 'Desc 2', isChecked: false);
    final List<TaskModel> tasks = [task1, task2];

    when(() => mockHiveBox.values).thenReturn(tasks);

    final result = await taskService.getTasks(onlyCompleted: true);

    expect(result.length, 1);
    expect(result.first.title, 'Task 1');
  });
}
