import 'package:flutter/foundation.dart';
import 'package:sondeurs/model/lesson/lesson_model.dart';

class CategoryModel {
  int? id;
  String? name;
  String? imagePath;
  List<LessonModel>? lessons;

  CategoryModel({
    this.id,
    this.name,
    this.imagePath,
    this.lessons
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imagePath = json['imagePath'];
    lessons = [];
    if (json['lessons'] != null && json['lessons'].length > 0) {
      json['lessons'].forEach((lesson) {
        lessons!.add(LessonModel.fromJson(lesson));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['imagePath'] = imagePath;
    data['lessons'] = [];
    if (lessons != null && lessons!.length > 0) {
      for (var lesson in lessons!) {
        data['lessons'].add(lesson.toJson());
      }
    }
    return data;
  }
}

class CategoryListModel {
  List<CategoryModel>? categories;

  CategoryListModel({this.categories});

  CategoryListModel.fromJson(List json) {
    for (var value in json) {
      categories ??= [];
      categories!.add(CategoryModel.fromJson(value));
    }
  }

  List toJson() {
    const List data = [];
    if (categories != null) {
      for (var element in categories!) {
        data.add(element.toJson());
      }
    }
    return data;
  }
}

