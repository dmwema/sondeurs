import 'package:flutter/material.dart';
import 'package:quickdep_mob/resource/config/colors.dart';

class AuthContainer extends StatelessWidget {
  final Widget child;

  const AuthContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
      ),
      child: child,
    );
  }

}