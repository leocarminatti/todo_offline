import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../configs/configs.dart';
import '../../../domain/domain.dart';
import '../../ui.dart';

class TaskCreateScreen extends StatelessWidget {
  const TaskCreateScreen({super.key});

  void _saveTask(
      BuildContext context, String title, String description, bool isChecked) {
    final newTask = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      isChecked: isChecked,
    );

    context.read<TaskCubit>().addNewTask(newTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<TaskCubit, TaskState>(
          listener: (context, state) {
            if (state is TaskCreationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tarefa adicionada com sucesso!')),
              );
              getIt<NavigationCubit>().changeTab(
                NavigationStateType.todo.value,
              );
            } else if (state is TaskCreationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro: ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: TaskForm(
                    onSave: (title, description, isChecked) =>
                        _saveTask(context, title, description, isChecked),
                  ),
                ),
                if (state is TaskCreationLoading)
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Loading(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
