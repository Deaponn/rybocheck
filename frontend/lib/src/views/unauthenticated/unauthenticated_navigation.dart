import 'package:flutter/material.dart';
import 'package:Rybocheck/src/views/home.dart';
import 'package:Rybocheck/src/views/search.dart';
import 'package:Rybocheck/src/views/map.dart';
import 'package:Rybocheck/src/views/unauthenticated/authenticate.dart';

PreferredSizeWidget unauthenticatedAppBar = AppBar(title: const Text("Rybocheck"));

List<Widget> unauthenticatedDestinations = <Widget>[
  const NavigationDestination(icon: Icon(Icons.home), label: "Home"),
  const NavigationDestination(icon: Icon(Icons.search), label: "Search"),
  const NavigationDestination(icon: Icon(Icons.map), label: "Map"),
  const NavigationDestination(icon: Icon(Icons.login), label: "Login")
];

List<Widget> unauthenticatedViews = <Widget>[
  const Home(),
  const Search(),
  const Map(),
  const Authenticate(),
];
