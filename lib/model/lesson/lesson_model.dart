import 'package:flutter/foundation.dart';
import 'package:sondeurs/model/category/category_model.dart';
import 'package:sondeurs/model/user/user_model.dart';

class LessonModel {
  int? id;
  String? title;
  String? description;
  String? audioPath;
  CategoryModel? category;
  UserModel? author;
  String? imagePath;

  LessonModel({
    this.id,
    this.title,
    this.description,
    this.audioPath,
    this.author,
    this.category,
    this.imagePath,
  });

  LessonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    audioPath = json['audioPath'];
    if (json['author'] != null) {
      author = UserModel.fromJson(json['author']);
    }
    if (json['category'] != null) {
      category = CategoryModel.fromJson(json['category']);
    }
    title = json['title'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['audioPath'] = audioPath;
    data['imagePath'] = imagePath;

    if (category != null) {
      data['category'] = category!.toJson();
    }

    if (author != null) {
      data['author'] = author!.toJson();
    }

    return data;
  }
}

class LessonListModel {
  List<LessonModel>? lessons;

  LessonListModel({this.lessons});

  LessonListModel.fromJson(List json) {
    for (var value in json) {
      lessons ??= [];
      lessons!.add(LessonModel.fromJson(value));
    }
  }

  List toJson() {
    const List data = [];
    if (lessons != null) {
      for (var element in lessons!) {
        data.add(element.toJson());
      }
    }
    return data;
  }
}

