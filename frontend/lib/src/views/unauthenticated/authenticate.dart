import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Authenticate extends StatelessWidget {
  const Authenticate({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Authenticate page", textAlign: TextAlign.center);
  }
}

StatefulShellBranch authenticateBranch = StatefulShellBranch(routes: [
  GoRoute(
      path: '/rybocheck/login', builder: (BuildContext context, GoRouterState state) => const Authenticate()),
]);
