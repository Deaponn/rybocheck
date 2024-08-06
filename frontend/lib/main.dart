import 'package:flutter/material.dart';
import 'package:Rybocheck/src/views/user/user_navigation.dart';

void main() {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Rybocheck',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AppNavigation());
  }
}

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: userAppBar,
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int newPageIndex) {
            setState(() {
              _currentPageIndex = newPageIndex;
            });
          },
          selectedIndex: _currentPageIndex,
          destinations: userDestinations,
        ),
        body: userViews[_currentPageIndex]);
  }
}
