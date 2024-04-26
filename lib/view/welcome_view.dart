import 'package:flutter/material.dart';
import 'package:sondeurs/resource/components/buttons/rounded_button.dart';
import 'package:sondeurs/resource/config/colors.dart';
import 'package:sondeurs/routes/routes_name.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<StatefulWidget> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBg,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.asset("assets/logo.png", width: 250,)),
                  const Text("Bienvenue a vous !", style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  ), textAlign: TextAlign.left,),
                  const SizedBox(height: 20,),
                  Text("Proin id ligula dictum, convallis enim ut, facilisis massa. Mauris a nisi ut sapien blandit imperdie id ligula dictum, convallis enim ut, facilisis massa. Mauris a nisi ut sapien blandit imperdie", style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(.6)
                  ), textAlign: TextAlign.left,),
                  const SizedBox(height: 40,),
                  RoundedButton(
                      title: "Connectez-vous",
                      loading: false,
                      onPress: () {
                        Navigator.pushNamedAndRemoveUntil(context, RoutesName.login, (route) => false);
                      }
                  ),
                  const SizedBox(height: 15,),
                  RoundedButton(
                      title: "Inscrivez-vous",
                      loading: false,
                      onPress: () {
                        Navigator.pushNamedAndRemoveUntil(context, RoutesName.register, (route) => false);
                      }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}