import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sondeurs/routes/routes.dart';
import 'package:sondeurs/routes/routes_name.dart';
import 'package:sondeurs/view_model/category/category_view_model.dart';
import 'package:sondeurs/view_model/lessons/lessons_view_model.dart';
import 'package:sondeurs/view_model/user/user_view_model.dart';

bool? initScreen;
bool goHome = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => LessonViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
      ],
      child: MaterialApp(
          theme: ThemeData(
              fontFamily: 'Poppins'
          ),
          debugShowCheckedModeBanner: false,
          title: "Sondeurs",
          initialRoute: RoutesName.splash,
          onGenerateRoute: Routes.generateRoute,
          home: const MyApp()
      ),
    );
  }
}