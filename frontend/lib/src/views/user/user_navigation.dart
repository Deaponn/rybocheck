import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:Rybocheck/src/views/home.dart';
import 'package:Rybocheck/src/views/search.dart';
import 'package:Rybocheck/src/views/map.dart';
import 'package:Rybocheck/src/views/user/new_post.dart';
import 'package:Rybocheck/src/views/user/profile.dart';

PreferredSizeWidget Function(BuildContext) userAppBar = (BuildContext context) {
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

List<Widget> userDestinations = <Widget>[
  const NavigationDestination(icon: Icon(Icons.home), label: "Home"),
  const NavigationDestination(icon: Icon(Icons.search), label: "Search"),
  const NavigationDestination(icon: Icon(Icons.add_box), label: "Add new"),
  const NavigationDestination(icon: Icon(Icons.map), label: "Map"),
  const NavigationDestination(icon: Icon(Icons.person), label: "Profile")
];

List<Widget> userViews = <Widget>[
  const Home(),
  const Search(),
  const NewPost(),
  const Map(),
  const Profile(),
];
