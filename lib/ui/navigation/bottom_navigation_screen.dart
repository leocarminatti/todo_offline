import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../configs/configs.dart';
import '../ui.dart';

enum NavigationStateType {
  todo(0),
  create(1),
  search(2),
  done(3);

  final int value;

  const NavigationStateType(this.value);
}

class BottomNavigationScreen extends StatelessWidget {
  const BottomNavigationScreen({super.key});

  static final List<Widget> _screens = [
    BlocProvider(
      create: (_) => getIt<TaskCubit>()..fetchTasks(),
      child: TaskListScreen(),
    ),
    BlocProvider(
      create: (_) => getIt<TaskCubit>(),
      child: const TaskCreateScreen(),
    ),
    BlocProvider(
      create: (_) => getIt<TaskCubit>(),
      child: const TaskSearchScreen(),
    ),
    BlocProvider(
      create: (_) => getIt<TaskCubit>(),
      child: const TaskDoneScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        int currentIndex = NavigationState.values.indexOf(state);

        if (currentIndex < 0 || currentIndex >= _screens.length) {
          currentIndex = 0;
        }

        return Scaffold(
          body: _screens[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => context.read<NavigationCubit>().changeTab(index),
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Todo'),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Create'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
            ],
          ),
        );
      },
    );
  }
}
