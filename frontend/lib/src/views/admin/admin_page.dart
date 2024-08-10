import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminPage extends StatelessWidget{
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context){
    return const Text("AdminPage page", textAlign: TextAlign.center);
  }
}

StatefulShellBranch adminPageBranch = StatefulShellBranch(routes: [
  GoRoute(
      path: '/rybocheck/admin-page', builder: (BuildContext context, GoRouterState state) => const AdminPage()),
]);
