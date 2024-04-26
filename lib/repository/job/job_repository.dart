import 'package:flutter/cupertino.dart';
import 'package:quickdep_mob/data/network/base_api_service.dart';
import 'package:quickdep_mob/data/network/network_api_service.dart';
import 'package:quickdep_mob/resource/config/app_url.dart';

class JobRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchJobListApi ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.jobsEndpoint, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }
}