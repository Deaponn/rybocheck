import 'package:Rybocheck/src/views/moderator/moderator_navigation.dart';
import 'package:Rybocheck/src/views/unauthenticated/unauthenticated_navigation.dart';
import 'package:Rybocheck/src/views/user/user_navigation.dart';
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
import 'package:Rybocheck/src/views/admin/admin_navigation.dart';

typedef FullRouteData = ({
  List<RouteBase> routes,
  PreferredSizeWidget Function(BuildContext) appBar,
  List<Widget> destinations
});

enum PermissionLevel { admin, moderator, user, unauthenticated }

List<RouteBase> baseRoutes = [
  GoRoute(
    path: 'rybocheck/home',
    builder: (_, __) => const Home(),
  ),
  GoRoute(
    path: 'rybocheck/search',
    builder: (_, __) => const Search(),
  ),
  GoRoute(
    path: 'rybocheck/map',
    builder: (_, __) => const Map(),
  ),
  GoRoute(
    path: 'rybocheck/settings',
    builder: (_, __) => const Settings(),
  )
];

List<RouteBase> adminRoutes = [
  GoRoute(
    path: 'rybocheck/admin-page',
    builder: (_, __) => const AdminPage(),
  ),
  GoRoute(
    path: 'rybocheck/profile',
    builder: (_, __) => const Profile(),
  ),
];

List<RouteBase> moderatorRoutes = [
  GoRoute(
    path: 'rybocheck/moderator-page',
    builder: (_, __) => const ModeratorPage(),
  ),
  GoRoute(
    path: 'rybocheck/profile',
    builder: (_, __) => const Profile(),
  ),
];

List<RouteBase> unauthenticatedRoutes = [
  GoRoute(
    path: 'rybocheck/login',
    builder: (_, __) => const Authenticate(),
  ),
];

List<RouteBase> userRoutes = [
  GoRoute(
    path: 'rybocheck/profile',
    builder: (_, __) => const Profile(),
  ),
  GoRoute(
    path: 'rybocheck/new-post',
    builder: (_, __) => const NewPost(),
  ),
];

PermissionLevel Function(String) getPermissionLevel = (String jwt) {
  return PermissionLevel.admin;
};

FullRouteData Function(PermissionLevel) getFullRouteData =
    (PermissionLevel permission) {
  switch (permission) {
    case PermissionLevel.admin:
      return (
        routes: [...baseRoutes, ...adminRoutes],
        appBar: adminAppBar,
        destinations: adminDestinations
      );
    case PermissionLevel.moderator:
      return (
        routes: [...baseRoutes, ...moderatorRoutes],
        appBar: moderatorAppBar,
        destinations: moderatorDestinations
      );
    case PermissionLevel.user:
      return (
        routes: [...baseRoutes, ...userRoutes],
        appBar: userAppBar,
        destinations: userDestinations
      );
    case PermissionLevel.unauthenticated:
      return (
        routes: [...baseRoutes, ...unauthenticatedRoutes],
        appBar: unauthenticatedAppBar,
        destinations: unauthenticatedDestinations
      );
  }
};
