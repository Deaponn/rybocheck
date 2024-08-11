import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    required this.navigationShell,
    required this.appBar,
    required this.destinations,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;
  final PreferredSizeWidget Function(BuildContext) appBar;
  final List<NavigationDestination> destinations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
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
