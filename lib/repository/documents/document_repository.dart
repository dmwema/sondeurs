import 'package:flutter/cupertino.dart';
import 'package:quickdep_mob/data/network/base_api_service.dart';
import 'package:quickdep_mob/data/network/network_api_service.dart';
import 'package:quickdep_mob/resource/config/app_url.dart';

class DocumentRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchDocumentTypes (id, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse("${"${AppUrl.workerEndPoint}/$id"}/files", context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> senFileApi (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getMultipartApiResponse("${AppUrl.documentsEndPoint}/${data["id"]}/send", data, context: context, filename: "file");
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> sendTextApi (dynamic data, id, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.documentsEndPoint}/$id/send", data, auth: false, context: context);
      return response;
    } catch(e) {
      throw e;
    }
  }
}