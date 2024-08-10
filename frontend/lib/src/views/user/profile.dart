import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Profile page", textAlign: TextAlign.center);
  }
}

StatefulShellBranch profileBranch = StatefulShellBranch(routes: [
  GoRoute(path: '/rybocheck/profile', builder: (BuildContext context, GoRouterState state) => const Profile(), routes: [
    GoRoute(path: 'rybocheck/profile/:userId', builder: (BuildContext context, GoRouterState state) => const Profile())
  ]),
]);
