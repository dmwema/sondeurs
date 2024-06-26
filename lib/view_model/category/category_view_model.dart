import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sondeurs/data/response/api_response.dart';
import 'package:sondeurs/model/category/category_model.dart';
import 'package:sondeurs/repository/category/category_repository.dart';

class CategoryViewModel with ChangeNotifier {
  final _myRepo = CategoryRepository();
  ApiResponse<dynamic> categoriesList = ApiResponse.loading();
  ApiResponse<dynamic> categoryDetail = ApiResponse.loading();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setCategoryDetail (ApiResponse<dynamic> response) {
    categoryDetail = response;
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

  Future<void> get(int id) async {
    setCategoryDetail(ApiResponse.loading());
    _myRepo.get(id).then((value) {
      if (kDebugMode) {
        print(value);
      }
      setCategoryDetail(ApiResponse.completed(
          CategoryModel.fromJson(value)
      ));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      setCategoryDetail(ApiResponse.error(error.toString()));
    });
  }

  Future<bool> delete (int id) async {
    bool success = false;
    setCategoriesList(ApiResponse.loading());
    await _myRepo.delete(id).then((value) {
      success = true;
    }).onError((error, stackTrace) {
      setCategoriesList(ApiResponse.error(error.toString()));
    });
    return success;
  }

  Future<bool> create (Map data, Map<String, dynamic> files) async {
    bool success = false;
    await _myRepo.create(data, files).then((value) {
      success = true;
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    });
    return success;
  }

}