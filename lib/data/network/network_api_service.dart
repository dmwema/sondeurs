import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sondeurs/data/app_exceptions.dart';
import 'package:sondeurs/data/network/base_api_service.dart';
import 'package:sondeurs/model/user/user_model.dart';
import 'package:sondeurs/service/user_service.dart';

class NetworkApiService extends BaseApiServices {
  Future<UserModel> getAccountData () => UserService().getUser();
  UserModel user = UserModel();

  @override
  Future getGetResponse(String url, {bool auth = false,}) async {
    await getAccountData ().then((value) {
      user = value;
    });

    var header = {
      'Content-Type': "application/json"
    };

    var headerAuth = {
      'Content-Type': "application/json",
      'Authorization': 'Bearer ${user.token}'
    };

    dynamic responseJson;
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: auth ? headerAuth : header,
      ).timeout(const Duration(seconds: 120));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("Aucune connexion internet");
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data, {bool auth = false, String contentType = "application/json", bool pass = false}) async {
    dynamic responseJson;

    await getAccountData ().then((value) {
      user = value;
    });

    var header = {
      'Content-Type': contentType
    };

    var headerAuth = {
      'Content-Type': contentType,
      'Authorization': 'Bearer ${user.token}'
    };
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: auth? headerAuth: header,
      ).timeout(const Duration(seconds: 120));

      try {
        if (!pass) {
          print(response);
          responseJson = returnResponse(response);
        }
      } catch (e) {
        print(e);
        print(response.body);
        if (response.body.runtimeType == String && response.body.split(']}').length > 1) {
          print(response.body.split('}]}')[1]);
          Map responseMap = json.decode(response.body.split(']}')[1]);
          return responseMap;
        }
      }
    } on SocketException {
      throw FetchDataException("Aucune connexion internet",);
    } catch (e) {
      rethrow;
    }
    return responseJson;
  }

  @override
  Future getDeleteApiResponse(String url, {bool auth = true, String contentType = "application/json"}) async {
    dynamic responseJson;

    await getAccountData ().then((value) {
      user = value;
    });

    var header = {
      'Content-Type': contentType
    };

    var headerAuth = {
      'Content-Type': contentType,
      'Authorization': 'Bearer ${user.token}'
    };
    try {
      http.Response response = await http.delete(
        Uri.parse(url),
        headers: auth? headerAuth: header,
      ).timeout(const Duration(seconds: 120));
      print("**************************************************");
      print("**************************************************");
      print("**************************************************");
      print(response.body);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("Aucune connexion internet",);
    } catch (e) {
      rethrow;
    }

    return responseJson;
  }

  @override
  Future getPatchApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    var header = {
      'Content-Type': 'application/merge-patch+json'
    };
    try {
      http.Response response = await http.patch(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: header,
      ).timeout(const Duration(seconds: 60));

      responseJson = returnResponse(response,);
    } on SocketException {
      throw FetchDataException('Pas de connexion internet');
    }
    return responseJson;
  }

  @override
  Future getMultipartApiResponse(String url, data, {required Map<String, dynamic> files}) async {
    dynamic responseJson;
    try {
      var postUri = Uri.parse(url);

      http.MultipartRequest request = http.MultipartRequest("POST", postUri);

      files.forEach((name, file) async {
        http.MultipartFile multipartFile = await http.MultipartFile.fromPath(name, file.path);
        request.files.add(multipartFile);
      });

      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      http.StreamedResponse response = await request.send();
      var responseData = await http.Response.fromStream(response);
      responseJson = returnResponse(responseData);
    } on SocketException {
      throw FetchDataException("Aucune connexion internet");
    }
    return responseJson;

  }

  dynamic returnResponse (http.Response response) {
    switch(response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 204:
        return true;
      case 400:
        throw BadRequestException(response.body.toString());
      case 404:
        throw UnauthorisedException(response.body.toString());
      case 401:
        throw UnauthorisedException("Vous devez vous connecter",);
      default:
        throw FetchDataException('Erreur survenue lors de la connexion avec notre serveur' +  ' avec le code de statut ' + response.statusCode.toString() + response.body.toString());
    }
  }
}