import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sondeurs/model/user/user_model.dart';

class UserService with ChangeNotifier {
  Future<bool> saveUser(UserModel user) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('user__id', user.id!.toInt());
    sp.setString('token', user.token.toString());
    notifyListeners();
    return true;
  }

  Future<bool> updateUser(UserModel user) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('user__id', user.id!.toInt());
    if (user.token != null) {
      sp.setString('user__token', user.token.toString());
    }
    sp.setString('user__email', user.email!);
    sp.setString('user__phone_number', user.phoneNumber!);
    if (user.imagePath != null) {
      sp.setString('user__image_path', user.imagePath!);
    }
    sp.setString('user__role', user.role!);

    return true;
  }

  Future<UserModel> getUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int? id = sp.getInt('user__id');
    String? token = sp.getString('user__token');
    String? email = sp.getString('user__email');
    String? phoneNumber = sp.getString('user__phone_number');
    String? imagePath = sp.getString('user__image_path');
    String? role = sp.getString('user__role');

    UserModel user = UserModel(
        id: id,
        token: token,
        email: email,
        phoneNumber: phoneNumber,
        imagePath: imagePath,
        role: role,
    );

    return user;
  }

  Future<bool> updateImage(UserModel user) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('user__image_path', user.imagePath.toString());
    notifyListeners();
    return true;
  }

  Future<bool> remove() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    await sp.setBool('initScreen', true);
    return true;
  }
}