import 'package:flutter/material.dart';
import 'package:sondeurs/resource/config/colors.dart';
import 'package:sondeurs/service/splash_service.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashViewState();
  }
}

class _SplashViewState extends State<SplashView> {
  SplashService splashService = SplashService();

  @override
  void initState() {
    super.initState();
    splashService.checkAuthentication(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: AppColors.primaryColor,
          child: const Center(
              child: Text(
                "Chargement...",
                style: TextStyle(
                    color: Colors.white
                ),
              )
          ),
        )
    );
  }
}