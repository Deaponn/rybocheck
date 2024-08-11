import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:Rybocheck/src/views/home.dart';
import 'package:Rybocheck/src/views/map.dart';
import 'package:Rybocheck/src/views/search.dart';
import 'package:Rybocheck/src/views/settings.dart';
import 'package:Rybocheck/src/views/admin/admin_page.dart';
import 'package:Rybocheck/src/views/moderator/moderator_page.dart';
import 'package:Rybocheck/src/views/unauthenticated/authenticate.dart';
import 'package:Rybocheck/src/views/user/new_post.dart';
import 'package:Rybocheck/src/views/user/profile.dart';

typedef FullRouteData = ({
  List<StatefulShellBranch> branches,
  PreferredSizeWidget Function(BuildContext) appBar,
  List<NavigationDestination> destinations
});

enum PermissionLevel { admin, moderator, user, unauthenticated }

List<StatefulShellBranch> unauthenticatedBranches = [
  homeBranch,
  searchBranch,
  mapBranch,
  authenticateBranch,
  settingsBranch
];

PreferredSizeWidget Function(BuildContext) unauthenticatedAppBar = (BuildContext context) {
  return AppBar(title: const Text("Rybocheck"), actions: <Widget>[
    IconButton(
      icon: const Icon(Icons.settings),
      tooltip: 'Settings',
      onPressed: () {
        GoRouter.of(context).pushNamed('settings');
      },
    ),
  ]);
};

List<NavigationDestination> unauthenticatedDestinations = <NavigationDestination>[
  const NavigationDestination(icon: Icon(Icons.home), label: "Home"),
  const NavigationDestination(icon: Icon(Icons.search), label: "Search"),
  const NavigationDestination(icon: Icon(Icons.map), label: "Map"),
  const NavigationDestination(icon: Icon(Icons.login), label: "Login")
];

List<StatefulShellBranch> userBranches = [
  homeBranch,
  searchBranch,
  newPostBranch,
  mapBranch,
  profileBranch,
  settingsBranch,
];

PreferredSizeWidget Function(BuildContext) userAppBar = (BuildContext context) {
  return AppBar(title: const Text("Rybocheck"), actions: <Widget>[
    IconButton(
      icon: const Icon(Icons.settings),
      tooltip: 'Settings',
      onPressed: () {
        GoRouter.of(context).pushNamed('settings');
      },
    ),
  ]);
};

List<NavigationDestination> userDestinations = <NavigationDestination>[
  const NavigationDestination(icon: Icon(Icons.home), label: "Home"),
  const NavigationDestination(icon: Icon(Icons.search), label: "Search"),
  const NavigationDestination(icon: Icon(Icons.add_box), label: "Add new"),
  const NavigationDestination(icon: Icon(Icons.map), label: "Map"),
  const NavigationDestination(icon: Icon(Icons.person), label: "Profile")
];

List<StatefulShellBranch> moderatorBranches = [...userBranches, moderatorPageBranch];

PreferredSizeWidget Function(BuildContext) moderatorAppBar = (BuildContext context) {
  return AppBar(title: const Text("Rybocheck"), actions: <Widget>[
    IconButton(
      icon: const Icon(Icons.list_alt),
      tooltip: 'Moderator page',
      onPressed: () {
        GoRouter.of(context).pushNamed('moderator-page');
      },
    ),
    IconButton(
      icon: const Icon(Icons.settings),
      tooltip: 'Settings',
      onPressed: () {
        GoRouter.of(context).pushNamed('settings');
      },
    ),
  ]);
};

List<NavigationDestination> moderatorDestinations = <NavigationDestination>[
  const NavigationDestination(icon: Icon(Icons.home), label: "Home"),
  const NavigationDestination(icon: Icon(Icons.search), label: "Search"),
  const NavigationDestination(icon: Icon(Icons.add_box), label: "Add new"),
  const NavigationDestination(icon: Icon(Icons.map), label: "Map"),
  const NavigationDestination(icon: Icon(Icons.person), label: "Profile")
];

List<StatefulShellBranch> adminBranches = [...moderatorBranches, adminPageBranch];

PreferredSizeWidget Function(BuildContext) adminAppBar = (BuildContext context) {
  return AppBar(title: const Text("Rybocheck"), actions: <Widget>[
    IconButton(
      icon: const Icon(Icons.list_alt),
      tooltip: 'Admin page',
      onPressed: () {
        GoRouter.of(context).pushNamed('admin-page');
      },
    ),
    IconButton(
      icon: const Icon(Icons.settings),
      tooltip: 'Settings',
      onPressed: () {
        GoRouter.of(context).pushNamed('settings');
      },
    ),
  ]);
};

List<NavigationDestination> adminDestinations = <NavigationDestination>[
  const NavigationDestination(icon: Icon(Icons.home), label: "Home"),
  const NavigationDestination(icon: Icon(Icons.search), label: "Search"),
  const NavigationDestination(icon: Icon(Icons.add_box), label: "Add new"),
  const NavigationDestination(icon: Icon(Icons.map), label: "Map"),
  const NavigationDestination(icon: Icon(Icons.person), label: "Profile")
];

PermissionLevel Function(String) getPermissionLevel = (String jwt) {
  return PermissionLevel.admin;
};

FullRouteData Function(PermissionLevel) getFullRouteData = (PermissionLevel permission) {
  switch (permission) {
    case PermissionLevel.admin:
      return (branches: adminBranches, appBar: adminAppBar, destinations: adminDestinations);
    case PermissionLevel.moderator:
      return (branches: moderatorBranches, appBar: moderatorAppBar, destinations: moderatorDestinations);
    case PermissionLevel.user:
      return (branches: userBranches, appBar: userAppBar, destinations: userDestinations);
    case PermissionLevel.unauthenticated:
      return (
        branches: unauthenticatedBranches,
        appBar: unauthenticatedAppBar,
        destinations: unauthenticatedDestinations
      );
  }
};
