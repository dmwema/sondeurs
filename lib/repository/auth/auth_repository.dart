import 'package:flutter/material.dart';
import 'package:quickdep_mob/data/network/base_api_service.dart';
import 'package:quickdep_mob/data/network/network_api_service.dart';
import 'package:quickdep_mob/resource/config/app_url.dart';

class AuthRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> loginApi (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.loginEndPoint, data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> enterpriseRegisterApi (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.baseUrl}/enterprise-register", data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> workerRegisterApi (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.baseUrl}/worker-register", data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> signContract (id, data, {required BuildContext context}) async {
    bool fetched = false;
    try  {
      if(!fetched) {
        dynamic response = await _apiServices.getMultipartApiResponse("${"${AppUrl.contractEndpoint}/$id"}/sign", data, context: context, filename: data['filename']);
        return response;
      }
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> downloadContract (id, data, {required BuildContext context}) async {
    bool fetched = false;
    try  {
      if(!fetched) {
        dynamic response = await _apiServices.getPostApiResponse("${"${AppUrl.contractEndpoint}/$id"}/download", [], context: context, auth: true);
        return response;
      }
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> enterprisePaymentApi (dynamic data, {required BuildContext context, required int enterpriseId}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.enterpriseEndPoint}/$enterpriseId/payment", data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> userEditProfile (dynamic data, {required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPatchApiResponse("${AppUrl.userEndPoint}/$id", data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  // Future<dynamic> clientPaiementMethod (dynamic data, {required BuildContext context}) async {
  //   try  {
  //     dynamic response = await _apiServices.getPatchApiResponse("${AppUrl.clientsEndPoint}/${data['id']}", data, context: context);
  //     return response;
  //   } catch(e) {
  //     rethrow;
  //   }
  // }

  Future<dynamic> resetPasswordRequest (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.passwordReset}/reset-request", data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> resetPasswordConfirm (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.passwordReset}/reset-confirm", data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> confirmEmailVerification (dynamic data, int id, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.accountsEndPoint}/$id/confirm-email-verification", data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> confirmPhoneVerification (dynamic data, int id, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.accountsEndPoint}/$id/confirm-phone-verification", data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> newPasswordApi (dynamic data, id, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.accountsEndPoint}/$id/password", data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> emailVerification (dynamic data, id, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.accountsEndPoint}/$id/email-verification", data, context: context);

      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> sendWorkerExperiences (data, userId, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.workerEndPoint}/$userId/experiences", data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> phoneNumberVerification (dynamic data, id, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.accountsEndPoint}/$id/phone-verification", data, context: context);

      return response;
    } catch(e) {
      rethrow;
    }
  }

}