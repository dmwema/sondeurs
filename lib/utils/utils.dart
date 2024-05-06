import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sondeurs/model/user/user_model.dart';

class Utils {
  static String pusherAppId = "1543547";
  static String pusherKey = "edff47cb96049de87027";
  static String pusherSecret = "af29f17f93dac673ee31";
  static String pusherCluster = "us2";

  static String errorMessage = "Une erreur est survenue. Veuillez ressayer plutard";
  
  static toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static bool isAuthor (UserModel user) {
    return user.role == 'author';
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(context: context, flushbar: Flushbar(
      message: message,
      forwardAnimationCurve: Curves.decelerate,
      icon: const Icon(Icons.error, size: 25, color: Colors.white,),
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red.withOpacity(.88),
      borderRadius: BorderRadius.circular(5),
      flushbarPosition: FlushbarPosition.TOP,
      barBlur: 10,
      margin: const EdgeInsets.all(10),
    )..show(context));
  }
  static snakBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.black,
      ),
    );
  }

  static getMonthName (String date) {
    var month = date.split(' ')[0];
    Map<String, String> months = {
      "1": "Janvier",
      "2": "Fevrier",
      "3": "Mars",
      "4": "Avril",
      "5": "Mai",
      "6": "Juin",
      "7": "Juillet",
      "8": "Août",
      "9": "Septembre",
      "10": "Octobre",
      "11": "Novembre",
      "12": "Decembre",
    };
    return "${months[month]} ${date.split(' ')[1]}";
  }

  static BoxShadow customShadow () {
    return BoxShadow(
      color: Colors.grey.withOpacity(0.3),
      spreadRadius: .5,
      blurRadius: 7,
      offset: const Offset(0, 1), // changes position of shadow
    );
  }


  static bool emailValid (email) {
    return RegExp(r"^[a-zA-Z\d.a-zA-Z\d.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z\d]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static empty (dynamic data) {
    return data == null || data == "" ||   data == "null";
  }
}