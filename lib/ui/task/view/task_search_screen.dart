import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain.dart';
import '../../ui.dart';

class TaskSearchScreen extends StatefulWidget {
  const TaskSearchScreen({super.key});

  @override
  _TaskSearchScreenState createState() => _TaskSearchScreenState();
}

class _TaskSearchScreenState extends State<TaskSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      context
          .read<TaskCubit>()
          .searchTasks(_searchController.text, reset: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search for a task...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Loading();
                } else if (state is TaskError) {
                  return Center(child: Text('Erro: ${state.message}'));
                } else if (state is TaskSuccess) {
                  final tasks = state.tasks;

                  if (tasks.isEmpty) {
                    return const EmptyStateWidget(
                      message: 'Nenhuma task encontrada',
                    );
                  }

                  return InfiniteListView<Task>(
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
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
