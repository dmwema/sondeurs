import 'package:sondeurs/data/network/base_api_service.dart';
import 'package:sondeurs/data/network/network_api_service.dart';
import 'package:sondeurs/resource/config/app_url.dart';

class LessonRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> getCollection () async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.lessonsEndPoint, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> get (int id) async {
    try  {
      dynamic response = await _apiServices.getGetResponse("${AppUrl.lessonsEndPoint}/$id", auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> getSimilar (int id) async {
    try  {
      dynamic response = await _apiServices.getGetResponse("${AppUrl.lessonsEndPoint}/$id/similar", auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> delete (int id) async {
    try  {
      dynamic response = await _apiServices.getDeleteApiResponse("${AppUrl.lessonsEndPoint}/$id", auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> create (Map data, Map<String, dynamic> $files) async {
    try  {
      dynamic response = await _apiServices.getMultipartApiResponse(AppUrl.lessonsEndPoint, data, files: $files, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }
}