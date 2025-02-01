import 'package:go_router/go_router.dart';

import 'routes.dart';

final GoRouter router = GoRouter(
  initialLocation: PathRoutes.splash,
  routes: [
    GoRoute(
      path: PathRoutes.splash,
    ),
    GoRoute(
      path: PathRoutes.home,
    ),
  ],
);
