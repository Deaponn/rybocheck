import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Settings page", textAlign: TextAlign.center);
  }
}

StatefulShellBranch settingsBranch = StatefulShellBranch(routes: [
  GoRoute(
      path: '/rybocheck/settings',
      name: 'settings',
      builder: (BuildContext context, GoRouterState state) => const Settings()),
]);
