import 'package:flutter/material.dart';
import 'package:quickdep_mob/data/response/api_response.dart';
import 'package:quickdep_mob/model/account/account_model.dart';
import 'package:quickdep_mob/repository/apply/apply_repository.dart';
import 'package:quickdep_mob/resource/components/buttons/rounded_button.dart';
import 'package:quickdep_mob/resource/components/popup/error_popup.dart';
import 'package:quickdep_mob/routes/routes_name.dart';
import 'package:quickdep_mob/utils/utils.dart';
import 'package:quickdep_mob/view_model/account/account_view_model.dart';
import 'package:quickdep_mob/view_model/auth/auth_view_model.dart';

class   ApplyViewModel with ChangeNotifier {
  final _myRepo = ApplyRepository();
  ApiResponse<dynamic> appliesList = ApiResponse.loading();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setAppliesList (ApiResponse<dynamic> response) {
    appliesList = response;
    notifyListeners();
  }

  Future<void> fetchAppliesApi({required BuildContext context, required int enterpriseId}) async {
    setAppliesList(ApiResponse.loading());
    _myRepo.fetchApplyList(context: context, enterpriseId: enterpriseId).then((value) {
      var appliesJson = value['data'];
      if (value['success']) {
        setAppliesList(ApiResponse.completed(appliesJson));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      setAppliesList(ApiResponse.error(Utils.errorMessage));
    });
  }

  Future<void> fetchWorkerAppliesApi({required BuildContext context, required int workerId}) async {
    setAppliesList(ApiResponse.loading());
    _myRepo.fetchWorkerApplyList(context: context, workerId: workerId).then((value) {
      var appliesJson = value['data'];
      if (value['success']) {
        setAppliesList(ApiResponse.completed(appliesJson));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      setAppliesList(ApiResponse.error(Utils.errorMessage));
    });
  }

  Future<bool> newApplyApi({required BuildContext context, required int shiftId, required Map data}) async {
    setAppliesList(ApiResponse.loading());
    AuthViewModel authViewModel = AuthViewModel();
    AccountModel? account;
    AccountViewModel().getAccount().then((value) {
      account = value;
    });
    await _myRepo.newApplyApi(context: context, shiftId: shiftId, data: data).then((value) {
      if (value['success']) {
        Navigator.pushNamedAndRemoveUntil(context, RoutesName.workerApplies, (route) => false);
        Utils.toastMessage(value['message']);
      } else {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              child: ErrorPopUp(
                message: value['message'],
                btnText: value['errorType'] == "email_error" ? "Vérifier votre e-mail" : (
                    value['errorType'] == "phone_error" ? "Vérifier votre téléphone" : (
                      value['errorType'] == "contract_error" ? "Signer le contrat" : (
                        value['errorType'] == 'documents_error' ? "Mes documents" : "ok"
                      )
                    )
                ),
                onConfirm: () {
                  if (account != null) {
                    if (value['errorType'] == 'email_error') {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.error,
                                    color: Colors.black54,
                                    size: 50,
                                  ),
                                  const SizedBox(height: 10,),
                                  Column(
                                    children: [
                                      Text("Un mail sera envoyé à votre adresse (${account!.email}) pour finaliser la vérification.",
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const Divider(),
                                      const Text("Êtes-vous sûr de vouloir continuer ?",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RoundedButton(
                                        title: "Confirmer",
                                        loading: loading,
                                        onPress: () {
                                          if (account!.id != null) {
                                            authViewModel.emailVerification({}, context, account!.id);
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 10,),
                                      RoundedButton(
                                        title: "Annuler",
                                        loading: false,
                                        color: Colors.black38,
                                        onPress: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              )
                          )
                      );
                    }
                    else if (value['errorType'] == 'phone_error') {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.error,
                                    color: Colors.black54,
                                    size: 50,
                                  ),
                                  const SizedBox(height: 10,),
                                  Column(
                                    children: [
                                        Text("Un SMS sera envoyé à votre numéro de téléphone (${account!.phoneNumber}) pour finaliser la vérification.",
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      const Divider(),
                                      const Text("Êtes-vous sûr de vouloir continuer ?",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RoundedButton(
                                        title: "Confirmer",
                                        loading: loading,
                                        onPress: () {
                                          if (account!.id != null) {
                                            authViewModel.phoneNumberVerification({}, context, account!.id);
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 10,),
                                      RoundedButton(
                                        title: "Annuler",
                                        loading: false,
                                        color: Colors.black38,
                                        onPress: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              )
                          )
                      );
                    }
                    else if (value['errorType'] == 'contract_error') {
                      Navigator.pushNamed(context, RoutesName.contractSign);
                    } else if (value['errorType'] == 'documents_error') {
                      Navigator.pushNamed(context, RoutesName.workerProfileDocument);
                    } else {
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            );
          },
        );
        // Navigator.pushNamed(context, RoutesName.workerShifts);
        // Utils.flushBarErrorMessage(value['message'], context);
      }
    });
    // .onError((error, stackTrace) {
    //   Utils.flushBarErrorMessage(Utils.errorMessage, context);
    // });
    return true;
  }

  Future<void> approveApplyApi({required BuildContext context, required int applyId}) async {
    setAppliesList(ApiResponse.loading());
    _myRepo.approveApplyAPI(context: context, applyId: applyId).then((value) {
      if (value['success']) {
        Utils.toastMessage(value['message']);
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, RoutesName.enterpriseShifts);
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      setAppliesList(ApiResponse.error(Utils.errorMessage));
    });
  }

  Future<void> cancelApplyApi({required BuildContext context, required int applyId, required AccountModel account}) async {
    setAppliesList(ApiResponse.loading());
    _myRepo.cancelApplyAPI(context: context, applyId: applyId).then((value) {
      if (value['success']) {
        Utils.toastMessage(value['message']);
        Navigator.pop(context);
        if (Utils.isEnterprise(account)) {
          Navigator.pushReplacementNamed(context, RoutesName.enterpriseShifts);
        } else if (Utils.isWorker(account)){
          Navigator.pushReplacementNamed(context, RoutesName.workerShifts);
        }
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      setAppliesList(ApiResponse.error(Utils.errorMessage));
    });
  }
}