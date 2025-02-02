import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/ui.dart';
import 'path_routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: PathRoutes.splash,
  routes: [
    GoRoute(
      path: PathRoutes.splash,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: PathRoutes.todo,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const BottomNavigationScreen(),
    ),
  ],
);
