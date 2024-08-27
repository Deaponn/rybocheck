import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:Rybocheck/src/views/post.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    const storage = FlutterSecureStorage();
    final iat = storage.read(key: 'accessToken');
    return FutureBuilder<String?>(
        future: iat,
        builder: (BuildContext context, AsyncSnapshot<String?> accessToken) {
          if (accessToken.hasData && accessToken.data != null) {
            return Text("Home page, access token: ${accessToken.data}", textAlign: TextAlign.center);
          } else {
            return const Text("Home page", textAlign: TextAlign.center);
          }
        });
  }
}

StatefulShellBranch homeBranch = StatefulShellBranch(routes: [
  GoRoute(path: '/rybocheck', builder: (BuildContext context, GoRouterState state) => const Home(), routes: [
    GoRoute(path: 'rybocheck/post/:postId', builder: (BuildContext context, GoRouterState state) => const Post())
  ]),
]);
