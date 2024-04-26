import 'package:flutter/material.dart';
import 'package:quickdep_mob/data/network/base_api_service.dart';
import 'package:quickdep_mob/data/network/network_api_service.dart';
import 'package:quickdep_mob/resource/config/app_url.dart';

class ConfirmationRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchConfirmationList ({required BuildContext context, required enterpriseId}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse("${AppUrl.enterpriseEndPoint}/$enterpriseId/confirmations", context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> fetchWorkerConfirmationList ({required BuildContext context, required workerId}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse("${AppUrl.workerEndPoint}/$workerId/confirmations", context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> fetchConfirmationDetail ({required BuildContext context, required confirmationId}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse("${AppUrl.confirmationsEndPoint}/$confirmationId", context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> cancelConfirmationApi ({required BuildContext context, required confirmationId}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.confirmationsEndPoint}/$confirmationId/cancel", {}, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }
}