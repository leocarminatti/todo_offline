import 'package:get_it/get_it.dart';

import '../data/data.dart';
import '../domain/domain.dart';
import '../ui/ui.dart';
import 'configs.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  // Services
  getIt.registerLazySingleton<ITaskService>(
      () => TaskService(HiveService.getBox<TaskModel>('tasks')));

  // Repositories
  getIt.registerLazySingleton<ITaskRepository>(
      () => TaskRepository(getIt<ITaskService>()));

  // UseCases
  getIt
      .registerLazySingleton(() => CreateTaskUseCase(getIt<ITaskRepository>()));
  getIt.registerLazySingleton(() => GetTasksUseCase(getIt<ITaskRepository>()));
  getIt
      .registerLazySingleton(() => SearchTaskUseCase(getIt<ITaskRepository>()));
  getIt
      .registerLazySingleton(() => DeleteTaskUseCase(getIt<ITaskRepository>()));
  getIt.registerLazySingleton(
      () => ToggleTaskStatusUseCase(getIt<ITaskRepository>()));

  // Cubits
  getIt.registerLazySingleton<NavigationCubit>(() => NavigationCubit());

  getIt.registerFactory(
    () => TaskCubit(
      createTask: getIt<CreateTaskUseCase>(),
      getTasks: getIt<GetTasksUseCase>(),
      searchTask: getIt<SearchTaskUseCase>(),
      deleteTask: getIt<DeleteTaskUseCase>(),
      toggleTaskStatus: getIt<ToggleTaskStatusUseCase>(),
    ),
  );
}
