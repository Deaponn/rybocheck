import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  List<NavigationDestination> Function(BuildContext) destinations
});

// TODO: remove trustedUser if there is no difference between them and regular user
enum Roles {
  admin,
  moderator,
  trustedUser,
  user,
  unauthenticated;

  static Roles fromString(String? string) {
    if (string == null) return Roles.unauthenticated;
    return switch (string.toLowerCase()) {
      "admin" => Roles.admin,
      "moderator" => Roles.moderator,
      "trusteduser" => Roles.trustedUser,
      "user" => Roles.user,
      _ => Roles.unauthenticated
    };
  }
}

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

List<NavigationDestination> Function(BuildContext) unauthenticatedDestinations = (context) => <NavigationDestination>[
      NavigationDestination(icon: const Icon(Icons.home), label: AppLocalizations.of(context)!.navBarHome),
      NavigationDestination(icon: const Icon(Icons.search), label: AppLocalizations.of(context)!.navBarSearch),
      NavigationDestination(icon: const Icon(Icons.map), label: AppLocalizations.of(context)!.navBarMap),
      NavigationDestination(icon: const Icon(Icons.login), label: AppLocalizations.of(context)!.navBarLogin)
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

List<NavigationDestination> Function(BuildContext) userDestinations = (context) => <NavigationDestination>[
      NavigationDestination(icon: const Icon(Icons.home), label: AppLocalizations.of(context)!.navBarHome),
      NavigationDestination(icon: const Icon(Icons.search), label: AppLocalizations.of(context)!.navBarSearch),
      // TODO: or add_box_outlined?
      NavigationDestination(
          icon: const Icon(Icons.add_circle_outline), label: AppLocalizations.of(context)!.navBarNewPost),
      NavigationDestination(icon: const Icon(Icons.map), label: AppLocalizations.of(context)!.navBarMap),
      NavigationDestination(
          icon: const Icon(Icons.account_circle_outlined), label: AppLocalizations.of(context)!.navBarProfile),
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

List<NavigationDestination> Function(BuildContext) moderatorDestinations = userDestinations;

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

List<NavigationDestination> Function(BuildContext) adminDestinations = moderatorDestinations;

Roles Function(String) getRoles = (String jwt) {
  return Roles.admin;
};

FullRouteData Function(Roles) getFullRouteData = (Roles permission) {
  switch (permission) {
    case Roles.admin:
      return (branches: adminBranches, appBar: adminAppBar, destinations: adminDestinations);
    case Roles.moderator:
      return (branches: moderatorBranches, appBar: moderatorAppBar, destinations: moderatorDestinations);
    case Roles.trustedUser:
      return (branches: userBranches, appBar: userAppBar, destinations: userDestinations);
    case Roles.user:
      return (branches: userBranches, appBar: userAppBar, destinations: userDestinations);
    case Roles.unauthenticated:
      return (
        branches: unauthenticatedBranches,
        appBar: unauthenticatedAppBar,
        destinations: unauthenticatedDestinations
      );
  }
};
