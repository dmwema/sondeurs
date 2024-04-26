import 'package:flutter/material.dart';
import 'package:quickdep_mob/data/network/base_api_service.dart';
import 'package:quickdep_mob/data/network/network_api_service.dart';
import 'package:quickdep_mob/resource/config/app_url.dart';

class TownRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchTownsList ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.townsEndPoint, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> sendTownApi ({required BuildContext context, required Map data, required int workerId}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.workerEndPoint}/$workerId/towns", data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> fetchWorkerTownsList ({required BuildContext context, required int workerId}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse("${AppUrl.workerEndPoint}/$workerId/towns", context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }
}