import 'package:flutter/material.dart';

import 'package:Rybocheck/src/components/main_scaffold.dart';

class Home extends StatelessWidget{
  const Home({super.key});

  @override
  Widget build(BuildContext context){
    return const MainScaffold(body: Text("Home page", textAlign: TextAlign.center));
  }
}
