import 'package:sondeurs/model/lesson/lesson_model.dart';

class UserModel {
  int? id;
  String? email;
  String? token;
  String? phoneNumber;
  String? imagePath;
  String? firstname;
  String? lastname;
  String? address;
  String? role;
  List<LessonModel>? lessons;
  
  UserModel({
    this.id,
    this.email,
    this.phoneNumber,
    this.firstname,
    this.address,
    this.lastname,
    this.imagePath,
    this.token,
    this.role,
    this.lessons
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    role = json['role'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    imagePath = json['imagePath'];
    token = json['token'];
    lessons = [];
    if (json['lessons'] != null && json['lessons'].length > 0) {
      json['lessons'].forEach((lesson) {
        lessons!.add(LessonModel.fromJson(lesson));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['address'] = address;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['phoneNumber'] = phoneNumber;
    data['imagePath'] = imagePath;
    data['role'] = role;
    data['token'] = token;
    data['lessons'] = [];
    if (lessons != null && lessons!.isNotEmpty) {
      for (var lesson in lessons!) {
        data['lessons'].add(lesson.toJson());
      }
    }
    return data;
  }
}

class UserListModel {
  List<UserModel>? users;

  UserListModel({this.users});

  UserListModel.fromJson(List json) {
    for (var value in json) {
      users ??= [];
      users!.add(UserModel.fromJson(value));
    }
  }

  List toJson() {
    const List data = [];
    if (users != null) {
      for (var element in users!) {
        data.add(element.toJson());
      }
    }
    return data;
  }
}
