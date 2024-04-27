import 'package:flutter/foundation.dart';
import 'package:sondeurs/data/response/api_response.dart';
import 'package:sondeurs/model/lesson/lesson_model.dart';
import 'package:sondeurs/repository/lesson/lesson_repository.dart';

class LessonViewModel with ChangeNotifier {
  final _myRepo = LessonRepository();
  ApiResponse<dynamic> lessonsList = ApiResponse.loading();
  ApiResponse<dynamic> lessonDetail = ApiResponse.loading();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setLessonsList (ApiResponse<dynamic> response) {
    lessonsList = response;
    notifyListeners();
  }

  setLessonDetail (ApiResponse<dynamic> response) {
    lessonDetail = response;
    notifyListeners();
  }

  Future<void> getCollection() async {
    setLessonsList(ApiResponse.loading());
    _myRepo.getCollection().then((value) {
      setLessonsList(ApiResponse.completed(
          LessonListModel.fromJson(value)
      ));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      setLessonsList(ApiResponse.error(error.toString()));
    });
  }

  Future<void> get(int id) async {
    setLessonDetail(ApiResponse.loading());
    _myRepo.get(id).then((value) {
      if (kDebugMode) {
        print(value);
      }
      setLessonDetail(ApiResponse.completed(
          LessonModel.fromJson(value)
      ));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      setLessonDetail(ApiResponse.error(error.toString()));
    });
  }

  Future<void> getSimilar(int id) async {
    setLessonsList(ApiResponse.loading());
    _myRepo.getSimilar(id).then((value) {
      if (kDebugMode) {
        print(value);
      }
      setLessonsList(ApiResponse.completed(
          LessonListModel.fromJson(value)
      ));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      setLessonsList(ApiResponse.error(error.toString()));
    });
  }

  Future<bool> delete (int id) async {
    bool success = false;
    setLessonsList(ApiResponse.loading());
    await _myRepo.delete(id).then((value) {
      success = true;
    }).onError((error, stackTrace) {
      setLessonsList(ApiResponse.error(error.toString()));
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