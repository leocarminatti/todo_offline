import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'configs/configs.dart';
import 'routes/routes.dart';
import 'ui/ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();
  await HiveService.openBoxes();

  setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<NavigationCubit>()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
