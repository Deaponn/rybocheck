import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:Rybocheck/src/views/map_post.dart';

class Map extends StatelessWidget {
  const Map({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Map page", textAlign: TextAlign.center);
  }
}

StatefulShellBranch mapBranch = StatefulShellBranch(routes: [
  GoRoute(path: '/rybocheck/map', builder: (BuildContext context, GoRouterState state) => const Map(), routes: [
    GoRoute(
        path: 'rybocheck/map/post/:postId', builder: (BuildContext context, GoRouterState state) => const MapPost()),
  ]),
]);
