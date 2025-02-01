import 'package:get_it/get_it.dart';

import '../data/data.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<ITaskService>(() => TaskService());
}
