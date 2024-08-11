import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:Rybocheck/src/components/main_scaffold.dart';
import 'package:Rybocheck/src/utils/allow_routes.dart';

void main() => runApp(const Application());

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<StatefulWidget> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  PermissionLevel permission = PermissionLevel.unauthenticated;
  FullRouteData routeData = getFullRouteData(PermissionLevel.unauthenticated);

  late final ValueNotifier<RoutingConfig> myRoutingConfig = ValueNotifier<RoutingConfig>(
    RoutingConfig(routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
          builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
            // Return the widget that implements the custom shell (in this case
            // using a BottomNavigationBar). The StatefulNavigationShell is passed
            // to be able access the state of the shell and to navigate to other
            // branches in a stateful way.
            return MainScaffold(
                routerState: state,
                navigationShell: navigationShell,
                appBar: routeData.appBar(context),
                destinations: routeData.destinations(context));
          },
          branches: routeData.branches),
    ]),
  );

  late final GoRouter router = GoRouter.routingConfig(
    initialLocation: '/rybocheck',
    routingConfig: myRoutingConfig,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'Rybocheck',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('pl'), // Polish
        ],
        routerConfig: router);
  }
}
