import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sondeurs/resource/components/buttons/rounded_button.dart';
import 'package:sondeurs/resource/components/form/form_field.dart';
import 'package:sondeurs/resource/config/colors.dart';
import 'package:sondeurs/routes/routes_name.dart';
import 'package:sondeurs/utils/utils.dart';
import 'package:sondeurs/view_model/auth/auth_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  AuthViewModel authViewModel = AuthViewModel();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loading = false;

  ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);

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
                "Se connecter",
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
                        label: "E-mail",
                        controller: _emailController,
                        hint: "Entrez votre adresse E-mail",
                        password: true,
                      ),
                      const SizedBox(height: 15),
                      ValueListenableBuilder(
                        valueListenable: obscurePassword,
                        builder: (context, value, child) {
                          return CustomFormField(
                            label: "Mot de passe",
                            controller: _passwordController,
                            hint: "Entrez votre mot de passe",
                            password: false,
                            obscurePassword: obscurePassword.value,
                            type: TextInputType.visiblePassword,
                            maxLines: 1,
                            suffixIcon: InkWell(
                              onTap: ( ) {
                                obscurePassword.value = !obscurePassword.value;
                              },
                              child: Icon(
                                  obscurePassword.value ? Icons.visibility_off_outlined: Icons.visibility
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      RoundedButton(
                        title: "Se connecter",
                        loading: loading,
                        onPress: () async {
                          if (!loading) {
                            if (_emailController.text == "") {
                              Utils.flushBarErrorMessage("Vous devez entrer l'adresse E-mail", context);
                            } else if (_passwordController.text == "") {
                              Utils.flushBarErrorMessage("Vous devez entrer le mot de passe", context);
                            } else {
                              setState(() {
                                loading = true;
                              });
                              Map data = {
                                "email": _emailController.text,
                                "password": _passwordController.text
                              };
                              await authViewModel.login(data, context);
                              setState(() {
                                loading = false;
                              });
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Forgot Password ?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.register);
                  },
                  child: Column(
                    children: [
                      Text(
                        "Vous n'avez pas de compte ?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(.5),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Inscrivez-vous",
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