import 'package:flutter/material.dart';
import 'package:quickdep_mob/data/network/base_api_service.dart';
import 'package:quickdep_mob/data/network/network_api_service.dart';
import 'package:quickdep_mob/resource/config/app_url.dart';

class ApplyRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchApplyList ({required BuildContext context, required enterpriseId}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse("${AppUrl.enterpriseEndPoint}/$enterpriseId/applies", context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> fetchWorkerApplyList ({required BuildContext context, required workerId}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse("${AppUrl.workerEndPoint}/$workerId/applies", context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> newApplyApi ({required BuildContext context, required Map data, required int shiftId}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.shiftsEndPoint}/$shiftId/apply", data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> approveApplyAPI ({required BuildContext context, required applyId}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.appliesEndPoint}/$applyId/confirm", {}, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> cancelApplyAPI ({required BuildContext context, required applyId}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.appliesEndPoint}/$applyId/cancel", {}, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }
}