import 'package:flutter/material.dart';
import 'package:quickdep_mob/data/network/base_api_service.dart';
import 'package:quickdep_mob/data/network/network_api_service.dart';
import 'package:quickdep_mob/resource/config/app_url.dart';

class TimeSheetRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchTimeSheetNotSentApi ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse("${AppUrl.timeSheetEndPoint}/not_send", context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> fetchTimeSheetWaitingApi ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse("${AppUrl.timeSheetEndPoint}/waiting", context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> fetchTimeSheetApprovedApi ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse("${AppUrl.timeSheetEndPoint}/approve", context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> fetchTimeSheetDetail ({required BuildContext context, required timeSheetId}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse("${AppUrl.timeSheetEndPoint}/$timeSheetId", context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> approveTimeSheetApi ({required BuildContext context, required timeSheetId}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.timeSheetEndPoint}/$timeSheetId/approve", {}, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> sendTimeSheetApi ({required BuildContext context, required Map data, required timeSheetId}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.timeSheetEndPoint}/$timeSheetId/send", data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }
}