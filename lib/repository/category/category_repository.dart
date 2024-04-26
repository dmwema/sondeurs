import 'package:flutter/material.dart';
import 'package:sondeurs/data/network/base_api_service.dart';
import 'package:sondeurs/data/network/network_api_service.dart';
import 'package:sondeurs/resource/config/app_url.dart';

class CategoryRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> getCollection () async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.categoryEndPoint, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }
}