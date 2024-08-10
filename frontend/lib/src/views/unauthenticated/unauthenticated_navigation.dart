import 'package:flutter/material.dart';
import 'package:Rybocheck/src/views/home.dart';
import 'package:Rybocheck/src/views/search.dart';
import 'package:Rybocheck/src/views/map.dart';
import 'package:Rybocheck/src/views/unauthenticated/authenticate.dart';
import 'package:go_router/go_router.dart';

PreferredSizeWidget Function(BuildContext) unauthenticatedAppBar = (BuildContext context) {
  return AppBar(title: const Text("Rybocheck"), actions: <Widget>[
    IconButton(
      icon: const Icon(Icons.settings),
      tooltip: 'Settings',
      onPressed: () {
        GoRouter.of(context).go('/rybocheck/settings');
      },
    ),
  ]);
};

List<BottomNavigationBarItem> unauthenticatedItems = <BottomNavigationBarItem>[
  const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
  const BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
  const BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
  const BottomNavigationBarItem(icon: Icon(Icons.login), label: "Login")
];

List<Widget> unauthenticatedViews = <Widget>[
  const Home(),
  const Search(),
  const Map(),
  const Authenticate(),
];
