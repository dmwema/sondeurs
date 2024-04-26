import 'package:flutter/material.dart';
import 'package:quickdep_mob/data/response/api_response.dart';
import 'package:quickdep_mob/model/account/account_model.dart';
import 'package:quickdep_mob/model/timeSheet/time_sheet_model.dart';
import 'package:quickdep_mob/repository/time_sheet/time_sheet_repository.dart';
import 'package:quickdep_mob/routes/routes_name.dart';
import 'package:quickdep_mob/utils/utils.dart';

class   TimeSheetViewModel with ChangeNotifier {
  final _myRepo = TimeSheetRepository();
  ApiResponse<dynamic> timeSheetsList = ApiResponse.loading();
  ApiResponse<dynamic> timeSheet = ApiResponse.loading();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setTimeSheetsList (ApiResponse<dynamic> response) {
    timeSheetsList = response;
    notifyListeners();
  }

  setTimeSheet (ApiResponse<dynamic> response) {
    timeSheet = response;
    notifyListeners();
  }

  Future<void> fetchTimeSheetWaiting({required BuildContext context}) async {
    setTimeSheetsList(ApiResponse.loading());
    _myRepo.fetchTimeSheetWaitingApi(context: context).then((value) {
      var shiftsJson = value['data'];
      if (value['success']) {
        setTimeSheetsList(ApiResponse.completed(shiftsJson));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      setTimeSheetsList(ApiResponse.error(Utils.errorMessage));
    });
  }

  Future<void> fetchTimeSheetNotSent({required BuildContext context}) async {
    setTimeSheetsList(ApiResponse.loading());
    _myRepo.fetchTimeSheetNotSentApi(context: context).then((value) {
      var shiftsJson = value['data'];
      if (value['success']) {
        setTimeSheetsList(ApiResponse.completed(shiftsJson));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      setTimeSheetsList(ApiResponse.error(Utils.errorMessage));
    });
  }

  Future<void> fetchTimeSheetApproved({required BuildContext context}) async {
    setTimeSheetsList(ApiResponse.loading());
    _myRepo.fetchTimeSheetApprovedApi(context: context).then((value) {
      var shiftsJson = value['data'];
      if (value['success']) {
        setTimeSheetsList(ApiResponse.completed(shiftsJson));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    });
  }

  Future<void> fetchTimeSheetDetailApi({required BuildContext context, required int timeSheetId}) async {
    setTimeSheet(ApiResponse.loading());
    _myRepo.fetchTimeSheetDetail(context: context, timeSheetId: timeSheetId).then((value) {
      var shiftJson = value['data'];
      if (value['success']) {
        setTimeSheet(ApiResponse.completed(TimeSheetModel.fromJson(shiftJson)));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    });
  }

  Future<void> approveTimeSheetApi({required BuildContext context, required int timeSheetId}) async {
    setTimeSheet(ApiResponse.loading());
    _myRepo.approveTimeSheetApi(context: context, timeSheetId: timeSheetId).then((value) {
      if (value['success']) {
        Utils.toastMessage(value['message']);
        Navigator.pushNamed(context, RoutesName.enterpriseTimeSheets);
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    });
  }

  Future<void> sendTimeSheetApi({required BuildContext context, required Map data, required int timeSheetId, required AccountModel account}) async {
    setTimeSheet(ApiResponse.loading());
    _myRepo.sendTimeSheetApi(context: context, timeSheetId: timeSheetId, data: data).then((value) {
      if (value['success']) {
        Utils.toastMessage(value['message']);
        if (Utils.isEnterprise(account)) {
          Navigator.pushNamed(context, RoutesName.enterpriseTimeSheets);
        } else if (Utils.isWorker(account)) {
          Navigator.pushNamed(context, RoutesName.workerTimeSheets);
        }
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    });
  }
}