import 'package:flutter/material.dart';

class AppBarBuilder extends StatelessWidget {
  const AppBarBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: Image.asset("assets/menu_w.png")
      );},
    );
  }
}