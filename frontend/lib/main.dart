import 'package:Rybocheck/src/components/main_scaffold.dart';
import 'package:Rybocheck/src/utils/allow_routes.dart';
import 'package:Rybocheck/src/views/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

void main() => runApp(const Application());

// /// An example demonstrating how to use nested navigators
// class NestedTabNavigationExampleApp extends StatelessWidget {
//   /// Creates a NestedTabNavigationExampleApp
//   NestedTabNavigationExampleApp({super.key});

//   final GoRouter _router = GoRouter(
//     navigatorKey: _rootNavigatorKey,
//     initialLocation: '/a',
//     routes: <RouteBase>[
//       // #docregion configuration-builder
//       StatefulShellRoute.indexedStack(
//         builder: (BuildContext context, GoRouterState state,
//             StatefulNavigationShell navigationShell) {
//           // Return the widget that implements the custom shell (in this case
//           // using a BottomNavigationBar). The StatefulNavigationShell is passed
//           // to be able access the state of the shell and to navigate to other
//           // branches in a stateful way.
//           return ScaffoldWithNavBar(navigationShell: navigationShell);
//         },
//         // #enddocregion configuration-builder
//         // #docregion configuration-branches
//         branches: <StatefulShellBranch>[
//           // The route branch for the first tab of the bottom navigation bar.
//           StatefulShellBranch(
//             routes: <RouteBase>[
//               GoRoute(
//                 // The screen to display as the root in the first tab of the
//                 // bottom navigation bar.
//                 path: '/a',
//                 builder: (BuildContext context, GoRouterState state) =>
//                     const RootScreen(label: 'A', detailsPath: '/a/details'),
//                 routes: <RouteBase>[
//                   // The details screen to display stacked on navigator of the
//                   // first tab. This will cover screen A but not the application
//                   // shell (bottom navigation bar).
//                   GoRoute(
//                     path: 'details',
//                     builder: (BuildContext context, GoRouterState state) =>
//                         const DetailsScreen(label: 'A'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           // #enddocregion configuration-branches

//           // The route branch for the second tab of the bottom navigation bar.
//           StatefulShellBranch(
//             // It's not necessary to provide a navigatorKey if it isn't also
//             // needed elsewhere. If not provided, a default key will be used.
//             routes: <RouteBase>[
//               GoRoute(
//                 // The screen to display as the root in the second tab of the
//                 // bottom navigation bar.
//                 path: '/b',
//                 builder: (BuildContext context, GoRouterState state) =>
//                     const RootScreen(
//                   label: 'B',
//                   detailsPath: '/b/details/1',
//                   secondDetailsPath: '/b/details/2',
//                 ),
//                 routes: <RouteBase>[
//                   GoRoute(
//                     path: 'details/:param',
//                     builder: (BuildContext context, GoRouterState state) =>
//                         DetailsScreen(
//                       label: 'B',
//                       param: state.pathParameters['param'],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),

//           // The route branch for the third tab of the bottom navigation bar.
//           StatefulShellBranch(
//             routes: <RouteBase>[
//               GoRoute(
//                 // The screen to display as the root in the third tab of the
//                 // bottom navigation bar.
//                 path: '/c',
//                 builder: (BuildContext context, GoRouterState state) =>
//                     const RootScreen(
//                   label: 'C',
//                   detailsPath: '/c/details',
//                 ),
//                 routes: <RouteBase>[
//                   GoRoute(
//                     path: 'details',
//                     builder: (BuildContext context, GoRouterState state) =>
//                         DetailsScreen(
//                       label: 'C',
//                       extra: state.extra,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     ],
//   );

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       routerConfig: _router,
//     );
//   }
// }

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<StatefulWidget> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  PermissionLevel permission = PermissionLevel.unauthenticated;
  FullRouteData routeData = getFullRouteData(PermissionLevel.unauthenticated);

  late final ValueNotifier<RoutingConfig> myRoutingConfig = ValueNotifier<RoutingConfig>(
    RoutingConfig(
      routes: <RouteBase>[
        StatefulShellRoute.indexedStack(
            builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
              // Return the widget that implements the custom shell (in this case
              // using a BottomNavigationBar). The StatefulNavigationShell is passed
              // to be able access the state of the shell and to navigate to other
              // branches in a stateful way.
              return MainScaffold(
                  navigationShell: navigationShell, appBar: routeData.appBar, destinations: routeData.destinations);
            },
            branches: routeData.branches)
      ],
    ),
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
        routerConfig: router);
  }
}
