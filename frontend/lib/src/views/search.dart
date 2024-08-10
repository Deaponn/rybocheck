import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Search extends StatelessWidget{
  const Search({super.key});

  @override
  Widget build(BuildContext context){
    return const Text("Search page", textAlign: TextAlign.center);
  }
}

StatefulShellBranch searchBranch = StatefulShellBranch(routes: [
  GoRoute(
    path: '/rybocheck/search',
    builder: (BuildContext context, GoRouterState state) => const Search(),
  ),
]);
