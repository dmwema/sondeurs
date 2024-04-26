import 'package:flutter/widgets.dart';
import 'package:quickdep_mob/model/account/account_model.dart';
import 'package:quickdep_mob/model/contract/contract_model.dart';
import 'package:quickdep_mob/model/user/worker/experience_model.dart';
import 'package:quickdep_mob/repository/auth/auth_repository.dart';
import 'package:quickdep_mob/resource/components/config/arguments.dart';
import 'package:quickdep_mob/routes/routes_name.dart';
import 'package:quickdep_mob/utils/account_types.dart';
import 'package:quickdep_mob/utils/utils.dart';
import 'package:quickdep_mob/view_model/account/account_view_model.dart';
import 'package:quickdep_mob/view_model/contract/contract_view_model.dart';
import 'package:quickdep_mob/view_model/user/enterprise/enterprise_view_model.dart';
import 'package:quickdep_mob/view_model/user/worker/experience/experience_view_model.dart';

class AuthViewModel with ChangeNotifier{
  final _repository = AuthRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> loginApi(dynamic data, BuildContext context) async {
    setLoading(true);
    await _repository.loginApi(data, context: context).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        AccountModel account = AccountModel.fromJson(value['account']);
        account.token = value['token'];
          AccountViewModel().updateAccount(account).then((value) {
          Utils.toastMessage("Vous êtes connectés avec succès");
          if (account.type == AccountType.enterprise) {
            Navigator.pushReplacementNamed(context, RoutesName.enterpriseDashboard);
          } else if (account.type == AccountType.worker) {
            Navigator.pushReplacementNamed(context, RoutesName.workerShifts);
          }
        });
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<void> enterpriseRegisterApi(dynamic data, BuildContext context) async {
    setLoading(true);
    _repository.enterpriseRegisterApi(data, context: context).then((value) {
      setLoading(false);

      if (value["success"] == true) {
        AccountModel account = AccountModel.fromJson(value['account']);
        account.token = value['token'];
        String message = value['message'];
        AccountViewModel().updateAccount(account).then((value) {
          Utils.toastMessage(message);
          Navigator.pushReplacementNamed(context, RoutesName.enterprisePayment);
        }
        );
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    });
    // .onError((error, stackTrace) {
    //   Utils.flushBarErrorMessage(Utils.errorMessage, context);
    //   setLoading(false);
    // });
  }

  Future<void> workerRegisterApi(dynamic data, BuildContext context) async {
    setLoading(true);
    _repository.workerRegisterApi(data, context: context).then((value) {
      setLoading(false);
      if (value["success"] == true) {
        AccountModel account = AccountModel.fromJson(value['account']);
        account.token = value['token'];
        String message = value['message'];
        AccountViewModel().updateAccount(account).then((value) {
          Utils.toastMessage(message);
          Navigator.pushReplacementNamed(context, RoutesName.workerJobExperiences);
        });
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
  }

  Future<void> enterprisePaymentApi({
    required dynamic data,
    required BuildContext context,
    required int enterpriseId,
    bool profile = false
  }) async {
    setLoading(true);
    _repository.enterprisePaymentApi(data, context: context, enterpriseId: enterpriseId).then((value) {
      setLoading(false);

      if (value["success"] == true) {
        String message = value['message'];
        EnterpriseViewModel().updateEnterprisePaymentMethod(value['method']).then((value) {
          Utils.toastMessage(message);
          if (profile) {
            Navigator.pushNamed(context, RoutesName.enterpriseProfilePayment);
          } else {
            Navigator.pushNamed(context, RoutesName.contractSign);
          }
        });
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
  }

  Future<void> signContract(id, data, {required BuildContext context}) async {
    setLoading(true);
    _repository.signContract(id, data, context: context).then((value) {
      setLoading(false);
      if (value["success"]) {
        String message = "Contrat signé avec succès !";
        ContractModel contract = ContractModel.fromJson(value['contract']);
        AccountViewModel().getAccount().then((value) {
          AccountModel account = value;
          account.contract!.signed = true;
          account.contract = contract;
          ContractViewModel().updateContract(contract).then((value) {
            setLoading(false);
            Utils.toastMessage(message);

            if (Utils.isEnterprise(account)) {
              Navigator.pushNamed(context, RoutesName.enterpriseShifts);
            }
            if (Utils.isWorker(account)) {
              Navigator.pushNamed(context, RoutesName.workerShifts);
            }
          });
        });
      } else {
        setLoading(false);
        Utils.flushBarErrorMessage(value["message"], context);
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
    });
  }

  Future<bool> downloadContract(id, data, {required BuildContext context}) async {
    setLoading(true);
    await _repository.downloadContract(id, data, context: context).then((value) {
      setLoading(false);
      if (value["success"]) {
        String message = value['message'];
        Utils.toastMessage(message);
      } else {
        setLoading(false);
        Utils.flushBarErrorMessage(value["message"], context);
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
    });
    return true;
  }

  Future<bool> emailVerification (dynamic data, BuildContext context, id) async {
    bool returnValue = false;
    setLoading(true);
    await _repository.emailVerification(data, id, context: context).then((value) {
      setLoading(false);
      if (value["success"] == true){
        Utils.toastMessage(value["message"]);
        returnValue = true;
      } else {
        Utils.flushBarErrorMessage(value["message"], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return returnValue;
  }

  Future<bool> confirmEmailVerificationConfirm(dynamic data, id, BuildContext context) async {
    setLoading(true);
    await _repository.confirmEmailVerification(data, id, context: context).then((value) async {
      setLoading(false);
      if (value["success"] == true){
        String message = value['message'];
        AccountModel account = AccountModel();
        await AccountViewModel().getAccount().then((value) {
          account = value;
        });
        account.emailVerified = true;

        AccountViewModel().updateAccount(account).then((value) {
          Utils.toastMessage(message);
          if (Utils.isWorker(account)) {
            Navigator.pushNamed(context, RoutesName.workerShifts);
          } else if (Utils.isEnterprise(account)) {
            Navigator.pushNamed(context, RoutesName.enterpriseShifts);
          }
        });
      } else {
        Utils.flushBarErrorMessage(value["message"], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<bool> phoneNumberVerification (dynamic data, BuildContext context, id) async {
    setLoading(true);
    bool returnValue = false;
    await _repository.phoneNumberVerification(data, id, context: context).then((value) {
      setLoading(false);
      if (value["success"] == true){
        Utils.toastMessage(value["message"]);
        returnValue = true;
      } else {
        Utils.flushBarErrorMessage(value["message"], context);
      }

    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return returnValue;
  }

  Future<void> confirmPhoneNumberVerification(dynamic data, id, BuildContext context) async {
    setLoading(true);
    _repository.confirmPhoneVerification(data, id, context: context).then((value) async {
      setLoading(false);
      if (value["success"] == true){
        String message = value['message'];
        AccountModel account = AccountModel();
        await AccountViewModel().getAccount().then((value) {
          account = value;
        });
        account.phoneNumberVerified = true;

        AccountViewModel().updateAccount(account).then((value) {
          Utils.toastMessage(message);
          if (Utils.isWorker(account)) {
            Navigator.pushNamed(context, RoutesName.workerShifts);
          } else if (Utils.isEnterprise(account)) {
            Navigator.pushNamed(context, RoutesName.enterpriseShifts);
          }
        });
      } else {
        Utils.flushBarErrorMessage(value["message"], context);
      }

    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
  }

  Future<void> resetPasswordRequest(dynamic data, BuildContext context) async {
    setLoading(true);
    _repository.resetPasswordRequest(data, context: context).then((value) {
      setLoading(false);
      if (value["success"] == true){
        Utils.toastMessage(value["message"]);
        Navigator.pushNamed(context, RoutesName.confirmResetPasswordView, arguments: Arguments(email: data["email"]));
      } else {
        Utils.flushBarErrorMessage(value["message"], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
  }

  Future<bool> confirmResetPassword(dynamic data, BuildContext context) async {
    setLoading(true);
    await _repository.resetPasswordConfirm(data, context: context).then((value) {
      setLoading(false);
      if (value["success"] == true){
        Utils.toastMessage(value["message"]);
        Navigator.pushNamed(context, RoutesName.newPasswordView, arguments: Arguments(id: value['account_id']));
      } else {
        Utils.flushBarErrorMessage(value["message"], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<void> newPasswordApi (dynamic data, BuildContext context, id) async {
    setLoading(true);
    _repository.newPasswordApi(data, id, context: context).then((value) {
      setLoading(false);
      if (value["success"] == true){
        Utils.toastMessage(value["message"]);
        Navigator.pushNamed(context, RoutesName.login);
      } else {
        Utils.flushBarErrorMessage(value["message"], context);
      }

    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
  }

  Future<bool> sendWorkerExperiencesApi(data, userId, {required BuildContext context, bool profile = false}) async {
    setLoading(true);
    await _repository.sendWorkerExperiences(data, userId, context: context).then((value) {
      List<ExperienceModel> experiences = [];

      try {
        for (var element in value['experiences']) {
          experiences.add(ExperienceModel.fromJson(element));
        }
      } catch (e) {
        value['experiences'].forEach((key, element) {
          experiences.add(ExperienceModel.fromJson(element));
        });
      }

      String message = value['message'];
      ExperienceViewModel().updateExperiences(experiences).then((value) {
        setLoading(false);
        Utils.toastMessage(message);
        if (profile) {
          Navigator.pushNamed(context, RoutesName.workerProfile);
        } else {
          Navigator.pushReplacementNamed(context, RoutesName.workerTowns);
        }
      });
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }
}