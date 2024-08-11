import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

List<String> _hideAppBarAndNavigation = ["/rybocheck/settings", "/rybocheck/moderator-page", "/rybocheck/admin-page"];

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    required this.routerState,
    required this.navigationShell,
    required this.appBar,
    required this.destinations,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final GoRouterState routerState;
  final StatefulNavigationShell navigationShell;
  final PreferredSizeWidget appBar;
  final List<NavigationDestination> destinations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _hideAppBarAndNavigation.contains(routerState.fullPath) ? null : appBar,
      body: navigationShell,
      bottomNavigationBar: _hideAppBarAndNavigation.contains(routerState.fullPath) ? null : NavigationBar(
        onDestinationSelected: (int newPageIndex) => _onTap(context, newPageIndex),
        selectedIndex: navigationShell.currentIndex,
        destinations: destinations,
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
