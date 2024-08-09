import 'package:Rybocheck/src/utils/allow_routes.dart';
import 'package:Rybocheck/src/views/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// void main() {
//   runApp(const Application());
// }

void main() => runApp(const Application());

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    PermissionLevel permission = PermissionLevel.admin;
    FullRouteData routeData = getFullRouteData(permission);

    return MaterialApp.router(
        title: 'Rybocheck',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: router(routeData.routes));
  }
}

/// This handles '/' and '/details'.
GoRouter Function(List<RouteBase>) router = (List<RouteBase> routes) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/rybocheck',
        builder: (_, __) => const Home(),
        routes: routes,
      ),
    ],
  );
};
