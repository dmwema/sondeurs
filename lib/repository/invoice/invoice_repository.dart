import 'package:flutter/cupertino.dart';
import 'package:quickdep_mob/data/network/base_api_service.dart';
import 'package:quickdep_mob/data/network/network_api_service.dart';
import 'package:quickdep_mob/resource/config/app_url.dart';

class InvoiceRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchAllInvoicesListApi ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse("${AppUrl.invoicesEndPoint}/enterprise", context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> downloadInvoicesApi ({required BuildContext context, required int invoiceId}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.invoicesEndPoint}/$invoiceId/download", {}, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }
}