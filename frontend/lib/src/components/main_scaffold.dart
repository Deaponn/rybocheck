import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    required this.navigationShell,
    required this.appBar,
    required this.items,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;
  final PreferredSizeWidget Function(BuildContext) appBar;
  final List<BottomNavigationBarItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: const IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
        items: items,
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => _onTap(context, index),
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
