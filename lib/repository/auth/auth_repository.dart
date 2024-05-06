import 'package:flutter/material.dart';
import 'package:sondeurs/data/network/base_api_service.dart';
import 'package:sondeurs/data/network/network_api_service.dart';
import 'package:sondeurs/resource/config/app_url.dart';

class AuthRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> login (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.loginEndPoint, data);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> register (dynamic data) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.baseUrl}/register", data);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> workerRegisterApi (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.baseUrl}/worker-register", data);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> downloadContract (id, data, {required BuildContext context}) async {
    bool fetched = false;
    try  {
      if(!fetched) {
        dynamic response = await _apiServices.getPostApiResponse("${"${AppUrl.contractEndpoint}/$id"}/download", [], auth: true);
        return response;
      }
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> enterprisePaymentApi (dynamic data, {required BuildContext context, required int enterpriseId}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.enterpriseEndPoint}/$enterpriseId/payment", data, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> userEditProfile (dynamic data, {required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPatchApiResponse("${AppUrl.userEndPoint}/$id", data);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  // Future<dynamic> clientPaiementMethod (dynamic data, {required BuildContext context}) async {
  //   try  {
  //     dynamic response = await _apiServices.getPatchApiResponse("${AppUrl.clientsEndPoint}/${data['id']}", data);
  //     return response;
  //   } catch(e) {
  //     rethrow;
  //   }
  // }

  Future<dynamic> resetPasswordRequest (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.passwordReset}/reset-request", data);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> resetPasswordConfirm (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.passwordReset}/reset-confirm", data);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> confirmEmailVerification (dynamic data, int id, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.accountsEndPoint}/$id/confirm-email-verification", data);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> confirmPhoneVerification (dynamic data, int id, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.accountsEndPoint}/$id/confirm-phone-verification", data);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> newPasswordApi (dynamic data, id, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.accountsEndPoint}/$id/password", data);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> emailVerification (dynamic data, id, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.accountsEndPoint}/$id/email-verification", data);

      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> sendWorkerExperiences (data, userId, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.workerEndPoint}/$userId/experiences", data);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> phoneNumberVerification (dynamic data, id, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.accountsEndPoint}/$id/phone-verification", data);

      return response;
    } catch(e) {
      rethrow;
    }
  }

}