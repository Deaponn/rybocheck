import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewPost extends StatelessWidget {
  const NewPost({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("NewPost page", textAlign: TextAlign.center);
  }
}

StatefulShellBranch newPostBranch = StatefulShellBranch(routes: [
  GoRoute(path: '/rybocheck/new-post', builder: (BuildContext context, GoRouterState state) => const NewPost()),
]);
