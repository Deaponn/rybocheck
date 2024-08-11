import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ModeratorPage extends StatelessWidget {
  const ModeratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("ModeratorPage page", textAlign: TextAlign.center);
  }
}

StatefulShellBranch moderatorPageBranch = StatefulShellBranch(routes: [
  GoRoute(
      path: '/rybocheck/moderator-page',
      name: 'moderator-page',
      builder: (BuildContext context, GoRouterState state) => const ModeratorPage()),
]);
