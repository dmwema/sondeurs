import 'package:flutter/material.dart';
import 'package:quickdep_mob/data/response/api_response.dart';
import 'package:quickdep_mob/model/job/job_model.dart';
import 'package:quickdep_mob/repository/job/job_repository.dart';
import 'package:quickdep_mob/utils/utils.dart';

class   JobViewModel with ChangeNotifier {
  final _myRepo = JobRepository();
  ApiResponse<dynamic> jobsList = ApiResponse.loading();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setJobsList (ApiResponse<dynamic> response) {
    jobsList = response;
    notifyListeners();
  }

  Future<void> fetchJobListApi({required BuildContext context}) async {
    setJobsList(ApiResponse.loading());
    _myRepo.fetchJobListApi(context: context).then((value) {
      List returnList = [];
      value.forEach((element) {
        returnList.add(JobModel.fromJson(element));
      });
      setJobsList(ApiResponse.completed(returnList));
    });
  }
}