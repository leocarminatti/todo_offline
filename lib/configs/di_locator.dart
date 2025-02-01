import 'package:get_it/get_it.dart';

import '../data/data.dart';
import '../domain/domain.dart';
import '../ui/ui.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  // Services
  getIt.registerLazySingleton<ITaskService>(() => TaskService());

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

  // Cubits
  getIt.registerFactory(
    () => TaskCubit(
      createTask: getIt<CreateTaskUseCase>(),
      getTasks: getIt<GetTasksUseCase>(),
      searchTask: getIt<SearchTaskUseCase>(),
      deleteTask: getIt<DeleteTaskUseCase>(),
    ),
  );
}
