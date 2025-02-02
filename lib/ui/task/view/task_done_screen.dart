import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ui.dart';

class TaskDoneScreen extends StatelessWidget {
  const TaskDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Loading();
          } else if (state is TaskError) {
            return Center(child: Text('Erro: ${state.message}'));
          } else if (state is TaskSuccess) {
            final tasks = state.tasks.where((task) => task.isChecked).toList();

            if (tasks.isEmpty) {
              return const EmptyStateWidget(
                message: 'Nenhuma tarefa concluída ainda.',
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tarefas concluídas',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () =>
                            context.read<TaskCubit>().deleteAllCompletedTasks(),
                        child: const Text(
                          'Deletar todas',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: CustomCheckbox(
                            value: true,
                            onChanged: null,
                          ),
                          title: Text(
                            task.title,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                context.read<TaskCubit>().removeTask(task.id),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
