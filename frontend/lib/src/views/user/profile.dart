import 'package:Rybocheck/src/utils/jwt.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<JwtPairModel>(builder: (context, jwtPairModel, child) {
      return Column(
        children: [
          const Text("Profile page", textAlign: TextAlign.center),
          ElevatedButton(
            onPressed: () {
              jwtPairModel.eraseTokens();
            },
            child: Text(AppLocalizations.of(context)!.profileLogout),
          ),
        ],
      );
    });
  }
}

StatefulShellBranch profileBranch = StatefulShellBranch(routes: [
  GoRoute(path: '/rybocheck/profile', builder: (BuildContext context, GoRouterState state) => const Profile(), routes: [
    GoRoute(path: 'rybocheck/profile/:userId', builder: (BuildContext context, GoRouterState state) => const Profile())
  ]),
]);
