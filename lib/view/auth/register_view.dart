import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sondeurs/resource/components/buttons/rounded_button.dart';
import 'package:sondeurs/resource/components/form/form_field.dart';
import 'package:sondeurs/resource/config/colors.dart';
import 'package:sondeurs/routes/routes_name.dart';
import 'package:sondeurs/utils/utils.dart';
import 'package:sondeurs/view_model/auth/auth_view_model.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  AuthViewModel authViewModel = AuthViewModel();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  bool loading = false;

  ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);
  ValueNotifier<bool> obscurePasswordConfirm = ValueNotifier<bool>(true);

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
              const SizedBox(height: 40),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFormField(
                        label: "Prenom",
                        hint: "Entrez votre prenom",
                        controller: _firstnameController,
                        password: false,
                      ),
                      const SizedBox(height: 15),
                      CustomFormField(
                        label: "Nom",
                        controller: _lastnameController,
                        hint: "Entrez votre nom",
                        password: false,
                      ),
                      const SizedBox(height: 15),
                      CustomFormField(
                        label: "Numero de telephone",
                        controller: _phoneNumberController,
                        hint: "Entrez votre numero de telephone",
                        password: false,
                        type: TextInputType.phone,
                      ),
                      const SizedBox(height: 15),
                      CustomFormField(
                        label: "Adresse",
                        controller: _addressController,
                        hint: "Entrez votre adresse",
                        password: false,
                      ),
                      const SizedBox(height: 10),
                      Divider(color: Colors.white.withOpacity(.1),),
                      const SizedBox(height: 10),
                      CustomFormField(
                        label: "E-mail",
                        controller: _emailController,
                        hint: "Entrez votre adresse E-mail",
                        password: false,
                        type: TextInputType.emailAddress,
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
                      const SizedBox(height: 15),
                      ValueListenableBuilder(
                        valueListenable: obscurePasswordConfirm,
                        builder: (context, value, child) {
                          return CustomFormField(
                            label: "Confirmer le mot de passe",
                            controller: _passwordConfirmController,
                            hint: "Entrez votre a nouveau le mot de passe",
                            password: false,
                            obscurePassword: obscurePasswordConfirm.value,
                            type: TextInputType.visiblePassword,
                            maxLines: 1,
                            suffixIcon: InkWell(
                              onTap: ( ) {
                                obscurePasswordConfirm.value = !obscurePasswordConfirm.value;
                              },
                              child: Icon(
                                  obscurePasswordConfirm.value ? Icons.visibility_off_outlined: Icons.visibility
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      RoundedButton(
                        title: "S'inscrire",
                        loading: loading,
                        onPress: () async {
                          if (!loading) {
                            if (_firstnameController.text == "") {
                              Utils.flushBarErrorMessage("Vous devez entrer votre prenom", context);
                            } else if (_lastnameController.text == "") {
                              Utils.flushBarErrorMessage("Vous devez entrer votre nom", context);
                            } else if (_phoneNumberController.text == "") {
                              Utils.flushBarErrorMessage("Vous devez entrer votre numero de telephone", context);
                            } else if (_addressController.text == "") {
                              Utils.flushBarErrorMessage("Vous devez entrer votre adresse", context);
                            } else if (_emailController.text == "") {
                              Utils.flushBarErrorMessage("Vous devez entrer votre adresse E-mail", context);
                            } else if (_passwordController.text == "") {
                              Utils.flushBarErrorMessage("Vous devez creer un mot de passe", context);
                            } else if (_passwordConfirmController.text == "") {
                              Utils.flushBarErrorMessage("Vous devez confirmer le mot de passe", context);
                            } else if (_passwordController.text != _passwordConfirmController.text) {
                              Utils.flushBarErrorMessage("Les deux mot de passe ne correspondent pas", context);
                            } else {
                              setState(() {
                                loading = true;
                              });
                              Map data = {
                                "firstname": _firstnameController.text,
                                "lastname": _lastnameController.text,
                                "address": _addressController.text,
                                "phone_number": _phoneNumberController.text,
                                "email": _emailController.text,
                                "password": _passwordController.text
                              };
                              await authViewModel.register(data, context);
                              setState(() {
                                loading = false;
                              });
                            }
                          }
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
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}