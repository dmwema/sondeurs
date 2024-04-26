import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sondeurs/data/response/api_response.dart';
import 'package:sondeurs/model/category/category_model.dart';
import 'package:sondeurs/repository/category/category_repository.dart';

class CategoryViewModel with ChangeNotifier {
  final _myRepo = CategoryRepository();
  ApiResponse<dynamic> categoriesList = ApiResponse.loading();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setCategoriesList (ApiResponse<dynamic> response) {
    categoriesList = response;
    notifyListeners();
  }

  Future<CategoryListModel?> getCollection() async {
    setCategoriesList(ApiResponse.loading());
    CategoryListModel? returnValue;
    await _myRepo.getCollection().then((value) {
      returnValue = CategoryListModel.fromJson(value);
      setCategoriesList(ApiResponse.completed(returnValue));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      setCategoriesList(ApiResponse.error(error.toString()));
    });
    return returnValue;
  }

}