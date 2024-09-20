import 'package:Rybocheck/src/components/main_scaffold.dart';
import 'package:Rybocheck/src/utils/allow_routes.dart';
import 'package:Rybocheck/src/utils/jwt.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter createRouter(BuildContext context) {
  Roles permissionLevel = context.select<JwtPairModel, Roles>(
      (jwtPairModel) => Roles.fromString(jwtPairModel.tokens?.accessToken.body.permissionLevel));
  FullRouteData routeData = getFullRouteData(permissionLevel);

  final ValueNotifier<RoutingConfig> myRoutingConfig = ValueNotifier<RoutingConfig>(
    RoutingConfig(routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
          builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
            return MainScaffold(
                routerState: state,
                navigationShell: navigationShell,
                appBar: routeData.appBar(context),
                destinations: routeData.destinations(context));
          },
          branches: routeData.branches),
    ]),
  );

  final GoRouter router = GoRouter.routingConfig(
    initialLocation: '/rybocheck',
    routingConfig: myRoutingConfig,
  );

  return router;
}
