import 'package:Rybocheck/src/utils/jwt.dart';
import 'package:Rybocheck/src/utils/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:Rybocheck/src/components/text_switch.dart';
import 'package:provider/provider.dart';

enum SubmitAction { login, register }

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
    String username = "";
    String password = "";

    final usernameField = TextFormField(
      onSaved: (value) => username = value!,
      autocorrect: false,
      decoration: InputDecoration(labelText: AppLocalizations.of(context)!.loginUsernamePlaceholder),
      validator: (value) {
        // TODO: add validation
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.loginUsernameValidation;
        }
        return null;
      },
    );

    final passwordField = TextFormField(
      onSaved: (value) => password = value!,
      autocorrect: false,
      decoration: InputDecoration(labelText: AppLocalizations.of(context)!.loginPasswordPlaceholder),
      controller: _passwordController,
      obscureText: true,
      validator: (value) {
        // TODO: add validation
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.loginPasswordValidation;
        }
        return null;
      },
    );

    void Function() submitAction(JwtPairModel jwtPairModel, SubmitAction action) {
      return () async {
        if ((action == SubmitAction.login && _loginFormKey.currentState!.validate()) ||
            (action == SubmitAction.register && _registerFormKey.currentState!.validate())) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                content: Text(action == SubmitAction.login
                    ? AppLocalizations.of(context)!.loginLoginPendingToast
                    : AppLocalizations.of(context)!.loginRegisterPendingToast)),
          );
          action == SubmitAction.login ? _loginFormKey.currentState!.save() : _registerFormKey.currentState!.save();
          ServerResponse<JwtPair> response;
          if (action == SubmitAction.login) {
            response = await login(username, password);
          } else {
            response = await register(username, password);
          }
          if (response.status == "success") {
            jwtPairModel.setTokens(response.responseBody);
          } else if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              content: Text(localizeErrorResponse(response.error!, context)),
            ));
          }
        }
      };
    }

    return Consumer<JwtPairModel>(builder: (context, jwtPairModel, child) {
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
                        usernameField,
                        passwordField,
                        ElevatedButton(
                          onPressed: submitAction(jwtPairModel, SubmitAction.login),
                          child: Text(AppLocalizations.of(context)!.loginLoginButton),
                        ),
                      ],
                    ),
                  )
                  // TODO: add email, phone, password warning etc
                : Form(
                    key: _registerFormKey,
                    child: Column(
                      children: <Widget>[
                        usernameField,
                        passwordField,
                        TextFormField(
                          autocorrect: false,
                          decoration:
                              InputDecoration(labelText: AppLocalizations.of(context)!.loginPasswordPlaceholder),
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
                          onPressed: submitAction(jwtPairModel, SubmitAction.register),
                          child: Text(AppLocalizations.of(context)!.loginRegisterButton),
                        ),
                      ],
                    ),
                  ),
          )
        ],
      );
    });
  }
}

StatefulShellBranch authenticateBranch = StatefulShellBranch(routes: [
  GoRoute(path: '/rybocheck/login', builder: (BuildContext context, GoRouterState state) => const Authenticate()),
]);
