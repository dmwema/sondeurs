import 'package:flutter/material.dart';
import 'package:quickdep_mob/data/response/api_response.dart';
import 'package:quickdep_mob/model/account/account_model.dart';
import 'package:quickdep_mob/model/confirmation/shift_confirmation_model.dart';
import 'package:quickdep_mob/model/shift/shift_model.dart';
import 'package:quickdep_mob/repository/confirmation/confirmation_repository.dart';
import 'package:quickdep_mob/routes/routes_name.dart';
import 'package:quickdep_mob/utils/utils.dart';

class ConfirmationViewModel with ChangeNotifier {
  final _myRepo = ConfirmationRepository();
  ApiResponse<dynamic> confirmationsList = ApiResponse.loading();
  ApiResponse<dynamic> confirmation = ApiResponse.loading();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setConfirmation (ApiResponse<dynamic> response) {
    confirmation = response;
    notifyListeners();
  }

  setConfirmationsList (ApiResponse<dynamic> response) {
    confirmationsList = response;
    notifyListeners();
  }

  Future<void> fetchConfirmationsApi({required BuildContext context, required int enterpriseId}) async {
    setConfirmationsList(ApiResponse.loading());
    _myRepo.fetchConfirmationList(context: context, enterpriseId: enterpriseId)
        .then((value) {
      var confirmationsJson = value['data'];
      if (value['success']) {
        setConfirmationsList(ApiResponse.completed(confirmationsJson));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      setConfirmationsList(ApiResponse.error(Utils.errorMessage));
    });
  }

  Future<void> fetchWorkerConfirmationsApi({required BuildContext context, required int workerId}) async {
    setConfirmationsList(ApiResponse.loading());
    _myRepo.fetchWorkerConfirmationList(context: context, workerId: workerId)
        .then((value) {
      var confirmationsJson = value['data'];
      if (value['success']) {
        setConfirmationsList(ApiResponse.completed(confirmationsJson));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      setConfirmationsList(ApiResponse.error(Utils.errorMessage));
    });
  }

  Future<void> fetchShiftDetailApi({required BuildContext context, required int confirmationId}) async {
    setConfirmation(ApiResponse.loading());
    _myRepo.fetchConfirmationDetail(context: context, confirmationId: confirmationId).then((value) {
      print("*********************");
      print("*********************");
      print("*********************");
      print("*********************");
      print("*********************");
      print("*********************");
      print(value["data"]['started']);
      var shiftJson = value['data'];
      if (value['success']) {
        setConfirmation(ApiResponse.completed(ShiftConfirmationModel.fromJson(shiftJson)));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      setConfirmationsList(ApiResponse.error(Utils.errorMessage));
    });
  }

  Future<void> cancelConfirmationApi({required BuildContext context, required int confirmationId, required AccountModel account}) async {
    setConfirmation(ApiResponse.loading());
    _myRepo.cancelConfirmationApi(context: context, confirmationId: confirmationId).then((value) {
      if (value['success']) {
        Utils.toastMessage(value['message']);
        if (Utils.isEnterprise(account)) {
          Navigator.pushReplacementNamed(context, RoutesName.enterpriseShifts);
        } else if (Utils.isWorker(account)) {
          Navigator.pushReplacementNamed(context, RoutesName.workerShifts);
        }
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      setConfirmationsList(ApiResponse.error(Utils.errorMessage));
    });
  }
}