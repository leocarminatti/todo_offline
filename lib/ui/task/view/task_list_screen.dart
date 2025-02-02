import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_offline/configs/configs.dart';

import '../../../domain/domain.dart';
import '../../ui.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Loading();
          } else if (state is TaskError) {
            return Center(child: Text('Erro: ${state.message}'));
          } else if (state is TaskSuccess) {
            final tasks = state.tasks;

            if (tasks.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const EmptyStateWidget(
                    message: 'Nenhuma task encontrada',
                  ),
                  const SizedBox(height: 25),
                  CustomButton(
                    text: 'Criar tarefa',
                    icon: Icons.add,
                    onPressed: () {
                      getIt<NavigationCubit>().changeTab(
                        NavigationStateType.create.value,
                      );
                    },
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfo(tasks.length),
                Expanded(
                  child: InfiniteListView<Task>(
                    items: state.tasks,
                    hasMore: state.hasMore,
                    onLoadMore: () => context.read<TaskCubit>().fetchTasks(),
                    itemBuilder: (task) => TaskCard(
                      task: task,
                      onCheck: (value) {
                        context.read<TaskCubit>().toggleTask(
                              task.copyWith(isChecked: value ?? false),
                            );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return const EmptyStateWidget(
            message: 'Nenhuma task encontrada',
          );
        },
      ),
    );
  }

  _buildInfo(int length) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: 'Bem vindo, ',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: 'Leonardo',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Você tem $length tarefas para fazer',
              style: TextStyle(
                color: Colors.grey,
              ),
            )
          ],
        ),
      );
}
