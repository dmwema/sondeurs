import 'package:flutter/material.dart';
import 'package:quickdep_mob/data/network/base_api_service.dart';
import 'package:quickdep_mob/data/network/network_api_service.dart';
import 'package:quickdep_mob/model/town/town_model.dart';
import 'package:quickdep_mob/resource/config/app_url.dart';

class ShiftRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchShiftsList ({required BuildContext context, required enterpriseId}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse("${AppUrl.enterpriseEndPoint}/$enterpriseId/shifts", context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> fetchWorkerShiftsList ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse("${AppUrl.workerEndPoint}/shifts", context: context, auth: true);

      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> notWorked ({required BuildContext context, required Map dates, required int confirmationId}) async {
    try  {
      print("${AppUrl.confirmationsEndPoint}/$confirmationId/not-worked");
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.confirmationsEndPoint}/$confirmationId/not-worked", dates, context: context, auth: true);

      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> publishShiftEndPoint ({required BuildContext context, required Map data}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.shiftsEndPoint, data, context: context, auth: true);
      return response;
    } catch(e) {
      return {
        'success': true,
        'message': 'Shift publié avec succès'
      };
    }
  }

  Future<dynamic> deleteShiftEndPoint ({required BuildContext context, required int shiftId}) async {
    try  {
      dynamic response = await _apiServices.getDeleteApiResponse("${AppUrl.shiftsEndPoint}/$shiftId", context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> editShiftEndPoint ({required BuildContext context, required Map data, required int shiftId}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.shiftsEndPoint}/$shiftId/edit", data, context: context, auth: true);
      return response;
    } catch(e) {
      return {
        'success': true,
        'message': 'Shift modifié avec succès'
      };
    }
  }

  Future<dynamic> fetchShiftDetail ({required BuildContext context, required shiftId}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse("${AppUrl.shiftsEndPoint}/$shiftId", context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> fetchApplyDetail ({required BuildContext context, required shiftId}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse("${AppUrl.shiftsEndPoint}/$shiftId/apply", context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> fetchNotificationList ({required BuildContext context, required int  id}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse("${AppUrl.userEndPoint}/$id/notifications", context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> fetchJobListApi ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.jobsEndpoint, context: context);
      return response/* = ContractListModel.fromJson(response)*/;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> fetchTownsApi ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.townsEndPoint, context: context, auth: true);
      return TownModel.fromJson(response);
    } catch(e) {
      rethrow;
    }
  }


  Future<dynamic> fetchAcppliesContracts (id, page, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse("${"${AppUrl.userEndPoint}/$id"}/applies?current_page=$page", context: context);

      List<dynamic> responseData = [];
      for(var v in response) {
        var contract = v;
        if (contract.runtimeType.toString() != "String") {
          contract['likes'] = [];
          contract['tags'] = [];
        }
        responseData.add(contract);
      }
      return responseData;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> fetchClientContracts (id, page, {required BuildContext context}) async {
    bool fetched = false;
    try  {
      if(!fetched) {
        dynamic response = await _apiServices.getGetResponse("${"${AppUrl.shiftsEndPoint}/$id"}/contracts", context: context);
        fetched = true;
        return response;
      }
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> fetchClientsAppliedContractApi (id, page, {required BuildContext context}) async {
    bool fetched = false;
    try  {
      if(!fetched) {
        dynamic response = await _apiServices.getGetResponse("${"${AppUrl.shiftsEndPoint}/$id"}/applies", context: context);
        List<dynamic> responseData = [];
        for(var v in response) {
          var contract = v;
          if (contract.runtimeType.toString() != "String") {
            contract['likes'] = [];
            contract['tags'] = [];
          }
          responseData.add(contract);
        }
        fetched = true;
        return responseData;
      }
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> downloadInvoice (id, {required BuildContext context}) async {
    bool fetched = false;
    try  {
      if(!fetched) {
        dynamic response = await _apiServices.getPostApiResponse("${"${AppUrl.invoicesEndPoint}/$id"}/download", {}, context: context);
        return response;
      }
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> downloadContractFile (id, {required BuildContext context}) async {
    bool fetched = false;
    try  {
      if(!fetched) {
        dynamic response = await _apiServices.getPostApiResponse("${"${AppUrl.userEndPoint}/$id"}/contract-file-download", {}, context: context);
        return response;
      }
    } catch(e) {
      rethrow;
    }
  }
}