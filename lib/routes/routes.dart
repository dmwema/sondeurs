import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sondeurs/routes/routes_name.dart';
import 'package:sondeurs/view/auth/splash_view.dart';
import 'package:sondeurs/view/auth/welcome_view.dart';
import 'package:sondeurs/view/authors/all_authors_view.dart';
import 'package:sondeurs/view/authors/author_detail_view.dart';
import 'package:sondeurs/view/authors/new_author_view.dart';
import 'package:sondeurs/view/category/detail_view.dart';
import 'package:sondeurs/view/category/new_category_view.dart';
import 'package:sondeurs/view/lessons/all.dart';
import 'package:sondeurs/view/account/account_view.dart';
import 'package:sondeurs/view/home_view.dart';
import 'package:sondeurs/view/lessons/detail_view.dart';
import 'package:sondeurs/view/auth/login_view.dart';
import 'package:sondeurs/view/category/all_categories_view.dart';
import 'package:sondeurs/view/lessons/new.dart';
import 'package:sondeurs/view/auth/register_view.dart';

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

      case RoutesName.allAuthors:
        return PageTransition(
            child: const AllAuthorsView(),
            type: PageTransitionType.fade,
            settings: settings
        );

      case RoutesName.authorDetail:
        return PageTransition(
            child: AuthorDetailView(id: settings.arguments as int),
            type: PageTransitionType.fade,
            settings: settings
        );


      case RoutesName.newAuthors:
        return PageTransition(
            child: NewAuthorsView(),
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
      case RoutesName.splash:
        return PageTransition(
            child: SplashView(),
            type: PageTransitionType.fade,
            settings: settings
        );
      // case RoutesName.editLesson:
      //   return PageTransition(
      //       child: EditView(data: settings.arguments as Map),
      //       type: PageTransitionType.bottomToTop,
      //       settings: settings
      //   );
      case RoutesName.categoryDetail:
        return PageTransition(
            child: CategoryDetailView(id: settings.arguments as int),
            type: PageTransitionType.fade,
            settings: settings
        );
      case RoutesName.newLesson:
        return PageTransition(
            child: const NewView(),
            type: PageTransitionType.fade,
            settings: settings
        );
      case RoutesName.newCategory :
        return PageTransition(
            child: const NewCategoryView(),
            type: PageTransitionType.fade,
            settings: settings
        );

      case RoutesName.account:
        return PageTransition(
            child: const AccountView(),
            type: PageTransitionType.fade,
            settings: settings
        );
        case RoutesName.allCategories:
          return PageTransition(
              child: const AllCategoriesView(),
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