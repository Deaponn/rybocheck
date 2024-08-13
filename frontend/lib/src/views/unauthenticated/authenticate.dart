import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:Rybocheck/src/components/text_switch.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<StatefulWidget> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  int _loginRegisterChoice = 0;
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextSwitch(
          leftText: AppLocalizations.of(context)!.loginSwitchLogin,
          rightText: AppLocalizations.of(context)!.loginSwitchRegister,
          switchValue: _loginRegisterChoice,
          onSwitch: () {
            setState(() => _loginRegisterChoice = 1 - _loginRegisterChoice);
          },
        ),
        FractionallySizedBox(
          widthFactor: 0.7,
          child: _loginRegisterChoice == 0
              ? Form(
                  key: _loginFormKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        autocorrect: false,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context)!.loginUsernamePlaceholder),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.loginUsernameValidation;
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        autocorrect: false,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context)!.loginPasswordPlaceholder),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.loginPasswordValidation;
                          }
                          return null;
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_loginFormKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(AppLocalizations.of(context)!.loginLoginPendingToast)),
                            );
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.loginLoginButton),
                      ),
                    ],
                  ),
                )
              : Form(
                  key: _registerFormKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        autocorrect: false,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context)!.loginUsernamePlaceholder),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.loginUsernameValidation;
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        autocorrect: false,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context)!.loginPasswordPlaceholder),
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.loginPasswordValidation;
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        autocorrect: false,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context)!.loginPasswordPlaceholder),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.loginConfirmPasswordValidation;
                          }
                          if (value != _passwordController.value.text) {
                            return AppLocalizations.of(context)!.loginPasswordsDontMatch;
                          }
                          return null;
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_registerFormKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(AppLocalizations.of(context)!.loginRegisterPendingToast)),
                            );
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.loginRegisterButton),
                      ),
                    ],
                  ),
                ),
        )
      ],
    );
  }
}

StatefulShellBranch authenticateBranch = StatefulShellBranch(routes: [
  GoRoute(path: '/rybocheck/login', builder: (BuildContext context, GoRouterState state) => const Authenticate()),
]);
