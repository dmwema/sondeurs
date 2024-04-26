import 'package:flutter/material.dart';
import 'package:quickdep_mob/data/response/api_response.dart';
import 'package:quickdep_mob/model/account/account_model.dart';
import 'package:quickdep_mob/model/shift/shift_model.dart';
import 'package:quickdep_mob/repository/shift/shift_repository.dart';
import 'package:quickdep_mob/routes/routes_name.dart';
import 'package:quickdep_mob/utils/utils.dart';
import 'package:quickdep_mob/view_model/account/account_view_model.dart';

class   ShiftViewModel with ChangeNotifier {
  final _myRepo = ShiftRepository();
  ApiResponse<dynamic> shiftsList = ApiResponse.loading();
  ApiResponse<dynamic> shift = ApiResponse.loading();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setShiftsList (ApiResponse<dynamic> response) {
    shiftsList = response;
    notifyListeners();
  }

  setShift (ApiResponse<dynamic> response) {
    shift = response;
    notifyListeners();
  }

  Future<void> fetchShiftListApi({required BuildContext context, required int enterpriseId}) async {
    setShiftsList(ApiResponse.loading());
    _myRepo.fetchShiftsList(context: context, enterpriseId: enterpriseId).then((value) {
      var shiftsJson = value['data'];
      if (value['success']) {
        AccountModel account = AccountModel.fromJson(value['account']);
        AccountViewModel().updateAccount(account).then((value) {
          setShiftsList(ApiResponse.completed(shiftsJson));
        });
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      setShiftsList(ApiResponse.error(Utils.errorMessage));
    });
  }

  Future<void> notWorkedApi({required BuildContext context, required Map dates, required int confirmationId}) async {
    setShiftsList(ApiResponse.loading());
    _myRepo.notWorked(context: context, dates: dates, confirmationId: confirmationId).then((value) {
      if (value['success']) {
        Utils.toastMessage(value["message"]);
        Navigator.pushNamed(context, RoutesName.enterpriseShifts);
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      setShiftsList(ApiResponse.error(Utils.errorMessage));
    });
  }

  Future<void> fetchWorkerShiftListApi({required BuildContext context}) async {
    setShiftsList(ApiResponse.loading());
    _myRepo.fetchWorkerShiftsList(context: context).then((value) {
      var shiftsJson = value['data'];
      if (value['success']) {
        AccountModel account = AccountModel.fromJson(value['account']);
        AccountViewModel().updateAccount(account).then((value) {
          setShiftsList(ApiResponse.completed(shiftsJson));
        });
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      setShiftsList(ApiResponse.error(Utils.errorMessage));
    });
  }

  Future<void> fetchShiftDetailApi({required BuildContext context, required int shiftId}) async {
    setShift(ApiResponse.loading());
    _myRepo.fetchShiftDetail(context: context, shiftId: shiftId).then((value) {
      var shiftJson = value['data'];
      if (value['success']) {
        setShift(ApiResponse.completed(ShiftModel.fromJson(shiftJson)));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    });
  }

  Future<void> fetchApplyDetailApi({required BuildContext context, required int shiftId}) async {
    setShift(ApiResponse.loading());
    _myRepo.fetchApplyDetail(context: context, shiftId: shiftId).then((value) {
      var shiftJson = value['data'];
      if (value['success']) {
        setShift(ApiResponse.completed(ShiftModel.fromJson(shiftJson)));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    });
  }

  Future<void> publishShiftEndPoint({required BuildContext context, required Map data}) async {
    setShift(ApiResponse.loading());
    _myRepo.publishShiftEndPoint(context: context, data: data).then((value) {
      if (value['success']) {
        Utils.toastMessage(value['message']);
        Navigator.pushReplacementNamed(context, RoutesName.publishedShifts);
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    });
  }

  Future<bool> editShiftEndPoint({required BuildContext context, required Map data, required int shiftId}) async {
    setShift(ApiResponse.loading());
    bool returnValue = false;
    await _myRepo.editShiftEndPoint(context: context, data: data, shiftId: shiftId).then((value) {
      if (value['success']) {
        Utils.toastMessage(value['message']);
        returnValue = true;
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    });
    return returnValue;
  }

  Future<void> deleteShiftEndPoint({required BuildContext context, required int shiftId}) async {
    setShift(ApiResponse.loading());
    _myRepo.deleteShiftEndPoint(context: context, shiftId: shiftId).then((value) {
      if (value['success']) {
        Utils.toastMessage(value['message']);
        Navigator.pushReplacementNamed(context, RoutesName.publishedShifts);
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    });
  }
}