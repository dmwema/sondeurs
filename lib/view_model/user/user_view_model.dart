import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sondeurs/data/response/api_response.dart';
import 'package:sondeurs/model/user/user_model.dart';
import 'package:sondeurs/repository/user/user_repository.dart';

class UserViewModel with ChangeNotifier {
  final _myRepo = UserRepository();
  ApiResponse<dynamic> authorsList = ApiResponse.loading();
  ApiResponse<dynamic> authorDetail = ApiResponse.loading();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setAuthorsList (ApiResponse<dynamic> response) {
    authorsList = response;
    notifyListeners();
  }

  setAuthorsDetail (ApiResponse<dynamic> response) {
    authorDetail = response;
    notifyListeners();
  }

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
    if (user.address != null) {
      sp.setString('user__address', user.address!);
    }
    sp.setString('user__firstname', user.lastname!);
    sp.setString('user__lastname', user.firstname!);

    if (user.phoneNumber != null) {
      sp.setString('user__phone_number', user.phoneNumber!);
    }

    if (user.role != null) {
      sp.setString('user__role', user.role!);
    }
    if (user.imagePath != null) {
      sp.setString('user__image_path', user.imagePath!);
    }

    notifyListeners();
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
    String? address = sp.getString('user__address');
    String? firstname = sp.getString('user__firstname');
    String? lastname = sp.getString('user__lastname');
  
    UserModel user = UserModel(
      id: id,
      token: token,
      email: email,
      phoneNumber: phoneNumber,
      imagePath: imagePath,
      role: role,
      address: address,
      firstname: firstname,
      lastname: lastname,
    );

    return user;
  }

  Future<bool> updateImage(UserModel user) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('user__image_url', user.imagePath.toString());
    notifyListeners();
    return true;
  }

  Future<bool> remove() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    await sp.setBool('initScreen', true);
    return true;
  }

  Future<void> getAuthors() async {
    setAuthorsList(ApiResponse.loading());
    _myRepo.getAuthors().then((value) {
      setAuthorsList(ApiResponse.completed(
          UserListModel.fromJson(value)
      ));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      setAuthorsList(ApiResponse.error(error.toString()));
    });
  }

  Future<void> getNonAuthors() async {
    setAuthorsList(ApiResponse.loading());
    _myRepo.getNonAuthors().then((value) {
      setAuthorsList(ApiResponse.completed(
          UserListModel.fromJson(value)
      ));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      setAuthorsList(ApiResponse.error(error.toString()));
    });
  }

  Future<void> get(int id) async {
    setAuthorsDetail(ApiResponse.loading());
    _myRepo.get(id).then((value) {
      if (kDebugMode) {
        print(value);
      }
      setAuthorsDetail(ApiResponse.completed(
          UserModel.fromJson(value)
      ));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      setAuthorsDetail(ApiResponse.error(error.toString()));
    });
  }
}