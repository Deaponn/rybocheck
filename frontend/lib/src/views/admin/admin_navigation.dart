import 'package:flutter/material.dart';
import 'package:Rybocheck/src/views/home.dart';
import 'package:Rybocheck/src/views/search.dart';
import 'package:Rybocheck/src/views/map.dart';
import 'package:Rybocheck/src/views/user/new_post.dart';
import 'package:Rybocheck/src/views/user/profile.dart';
import 'package:go_router/go_router.dart';

PreferredSizeWidget Function(BuildContext) adminAppBar = (BuildContext context) {
  return AppBar(title: const Text("Rybocheck"), actions: <Widget>[
    IconButton(
      icon: const Icon(Icons.list_alt),
      tooltip: 'Admin page',
      onPressed: () {
        GoRouter.of(context).go('/rybocheck/admin-page');
      },
    ),
    IconButton(
      icon: const Icon(Icons.settings),
      tooltip: 'Settings',
      onPressed: () {
        GoRouter.of(context).go('/rybocheck/settings');
      },
    ),
  ]);
};

List<BottomNavigationBarItem> adminItems = <BottomNavigationBarItem>[
  const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
  const BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
  const BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Add new"),
  const BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
  const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
];

List<Widget> adminViews = <Widget>[
  const Home(),
  const Search(),
  const NewPost(),
  const Map(),
  const Profile(),
];
