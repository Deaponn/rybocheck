import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:Rybocheck/src/views/post.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Home page", textAlign: TextAlign.center);
  }
}

StatefulShellBranch homeBranch = StatefulShellBranch(routes: [
  GoRoute(path: '/rybocheck', builder: (BuildContext context, GoRouterState state) => const Home(), routes: [
    GoRoute(path: 'rybocheck/post/:postId', builder: (BuildContext context, GoRouterState state) => const Post())
  ]),
]);
