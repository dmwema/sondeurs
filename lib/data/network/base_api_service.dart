import 'package:flutter/material.dart';

abstract class BaseApiServices {
  Future<dynamic> getGetResponse(
    String url,
    {bool auth = false,}
  );

  Future<dynamic> getPostApiResponse(
    String url,
    dynamic data,
    {
      bool auth = true,
      String contentType = "application/json",
      bool pass = false
    }
  );

  Future<dynamic> getPatchApiResponse(
    String url,
    dynamic data,
  );

  Future<dynamic> getMultipartApiResponse(
    String url,
    dynamic data,
    {
      required String filename
    }
  );

  Future<dynamic> getDeleteApiResponse(
    String url,
    {
      bool auth = true,
      String contentType = "application/json"
    }
  );
}