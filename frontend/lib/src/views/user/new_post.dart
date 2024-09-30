import 'package:Rybocheck/src/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("NewPost page", textAlign: TextAlign.center),
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                autocorrect: false,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.newPostTitlePlaceholder),
                validator: (value) {
                  // TODO: add validation
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.newPostTitleValidation;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                autocorrect: false,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.newPostDescriptionPlaceholder),
                // TODO: add validation or leave it without?
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return AppLocalizations.of(context)!.loginUsernameValidation;
                //   }
                //   return null;
                // },
              ),
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  showToast(context, Text("${_titleController.text} ${_descriptionController.text}"));
                },
                child: Text(AppLocalizations.of(context)!.newPostCreatePost),
              ),
            ],
          ),
        )
      ],
    );
  }
}

StatefulShellBranch newPostBranch = StatefulShellBranch(routes: [
  GoRoute(path: '/rybocheck/new-post', builder: (BuildContext context, GoRouterState state) => const NewPost()),
]);
