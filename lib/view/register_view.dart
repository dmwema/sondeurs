import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sondeurs/resource/components/buttons/rounded_button.dart';
import 'package:sondeurs/resource/components/form/form_field.dart';
import 'package:sondeurs/resource/config/colors.dart';
import 'package:sondeurs/routes/routes_name.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBg,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "S'inscrire",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFormField(
                        label: "Prenom",
                        hint: "Entrez votre prenom",
                        password: false,
                      ),
                      const SizedBox(height: 15),
                      CustomFormField(
                        label: "Nom",
                        hint: "Entrez votre nom",
                        password: false,
                      ),
                      const SizedBox(height: 10),
                      Divider(color: Colors.white.withOpacity(.1),),
                      const SizedBox(height: 10),
                      CustomFormField(
                        label: "E-mail",
                        hint: "Entrez votre adresse E-mail",
                        password: false,
                      ),
                      const SizedBox(height: 15),
                      CustomFormField(
                        label: "Mot de passe",
                        hint: "Creez un mot de passe de au mois 6 carracteres",
                        password: false,
                      ),
                      const SizedBox(height: 15),
                      CustomFormField(
                        label: "Confirmer Mot de passe",
                        hint: "Entrez a nouveau le mot de passe",
                        password: false,
                      ),
                      const SizedBox(height: 20),
                      RoundedButton(
                        title: "S'inscrire",
                        loading: false,
                        onPress: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, RoutesName.home, (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.login);
                  },
                  child: Column(
                    children: [
                      Text(
                        "Vous avez deja un compte ?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(.5),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Connectez-vous",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}