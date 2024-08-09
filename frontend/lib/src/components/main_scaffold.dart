import 'package:Rybocheck/src/utils/allow_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatefulWidget {
  final Widget body;

  const MainScaffold({super.key, required this.body});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    FullRouteData routeData = getFullRouteData(getPermissionLevel("my_jwt"));

    return Scaffold(
        appBar: routeData.appBar(context),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int newPageIndex) {
            setState(() {
              _currentPageIndex = newPageIndex;
              GoRouter.of(context).go('/rybocheck/admin-page');
            });
          },
          selectedIndex: _currentPageIndex,
          destinations: routeData.destinations,
        ),
        body: widget.body);
  }
}
