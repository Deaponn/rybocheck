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
  List<StatefulShellBranch> branches,
  PreferredSizeWidget Function(BuildContext) appBar,
  List<NavigationDestination> destinations
});

enum PermissionLevel { admin, moderator, user, unauthenticated }

List<StatefulShellBranch> baseBranches = [homeBranch, searchBranch, mapBranch, settingsBranch];

List<StatefulShellBranch> unauthenticatedBranches = [...baseBranches, authenticateBranch];

List<StatefulShellBranch> userBranches = [...baseBranches, profileBranch, newPostBranch];

List<StatefulShellBranch> moderatorBranches = [...userBranches, moderatorPageBranch];

List<StatefulShellBranch> adminBranches = [...moderatorBranches, adminPageBranch];

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
