import 'package:flutter/cupertino.dart';
import 'package:sondeurs/data/network/base_api_service.dart';
import 'package:sondeurs/data/network/network_api_service.dart';
import 'package:sondeurs/resource/config/app_url.dart';

class UserRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> userImage (id, data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getMultipartApiResponse("${AppUrl.userEndPoint}/$id/image", data, filename: "image");
      return response;
    } catch(e) {
      rethrow;
    }
  }
}