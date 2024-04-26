import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sondeurs/routes/routes_name.dart';
import 'package:sondeurs/view/lessons/all.dart';
import 'package:sondeurs/view/distributions_view.dart';
import 'package:sondeurs/view/home_view.dart';
import 'package:sondeurs/view/lessons/detail_view.dart';
import 'package:sondeurs/view/auth/login_view.dart';
import 'package:sondeurs/view/categories_view.dart';
import 'package:sondeurs/view/lessons/new.dart';
import 'package:sondeurs/view/register_view.dart';
import 'package:sondeurs/view/sales_view.dart';
import 'package:sondeurs/view/welcome_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {

      case RoutesName.welcome:
        return PageTransition(
            child: const WelcomeView(),
            type: PageTransitionType.fade,
            settings: settings
        );
      case RoutesName.login:
        return PageTransition(
            child: const LoginView(),
            type: PageTransitionType.fade,
            settings: settings
        );
      case RoutesName.register:
        return PageTransition(
            child: const RegisterView(),
            type: PageTransitionType.fade,
            settings: settings
        );

      case RoutesName.home:
        return PageTransition(
            child: const HomeView(),
            type: PageTransitionType.fade,
            settings: settings
        );

      case RoutesName.allLessons:
        return PageTransition(
            child: const AllView(),
            type: PageTransitionType.fade,
            settings: settings
        );
      case RoutesName.lessonDetail:
        return PageTransition(
            child: DetailView(id: settings.arguments as int),
            type: PageTransitionType.fade,
            settings: settings
        );
      case RoutesName.newLesson:
        return PageTransition(
            child: const NewView(),
            type: PageTransitionType.fade,
            settings: settings
        );

      case RoutesName.distributions:
        return PageTransition(
            child: const DistributionsView(),
            type: PageTransitionType.fade,
            settings: settings
        );
      case RoutesName.sales:
        return PageTransition(
            child: const SalesView(),
            type: PageTransitionType.fade,
            settings: settings
          );
        case RoutesName.categories:
          return PageTransition(
              child: const CategoriesView(),
              type: PageTransitionType.fade,
              settings: settings
          );
    default:
      return MaterialPageRoute(builder: (_) {
        return const Scaffold(
          body: Center(
            child: Text("No route defined"),
          ),
        );
      });
    }
  }
}