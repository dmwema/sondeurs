import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sondeurs/model/user/user_model.dart';
import 'package:sondeurs/routes/routes_name.dart';
import 'package:sondeurs/service/user_service.dart';

class SplashService {
  Future<UserModel> getAccountData() => UserService().getUser();

  void checkAuthentication(BuildContext context) async {
    getAccountData().then((value) {
      if (value.token.toString() == 'null' || value.token == '' || value.token == null ) {
        Navigator.pushNamedAndRemoveUntil(
          context,RoutesName.welcome, (route) => false,
        );
      } else {
          Navigator.pushNamedAndRemoveUntil(
            context,RoutesName.home, (route) => false,
          );
      }
    }).onError((error, stackTrace) {
      if(kDebugMode) {
        print(error.toString());
      }
    });
  }
}