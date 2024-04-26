import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quickdep_mob/data/response/api_response.dart';
import 'package:quickdep_mob/model/account/account_model.dart';
import 'package:quickdep_mob/model/contract/contract_model.dart';
import 'package:quickdep_mob/model/town/town_model.dart';
import 'package:quickdep_mob/model/user/entreprise_model.dart';
import 'package:quickdep_mob/repository/town/town_repository.dart';
import 'package:quickdep_mob/routes/routes_name.dart';
import 'package:quickdep_mob/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class TownViewModel with ChangeNotifier {
  final _repository = TownRepository();
  ApiResponse<List<TownModel>> townsList = ApiResponse.loading();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setTownsList (ApiResponse<List<TownModel>> response) {
    townsList = response;
    notifyListeners();
  }

  Future<bool> updateTown({bool multiple = false, List<TownModel>? towns, TownModel? town}) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    if (multiple) {
      if (towns != null) {
        List<int> townIds = [];
        for (TownModel townV in towns!) {
          if (!townIds.contains(townV.id)) {
            townIds.add(townV.id!);
          }
        }
        sp.setString('towns__ids', townIds.toString());

        for (TownModel townV in towns) {
          sp.setString('town__${townV.id}__name', townV.name!);
        }
      }
    } else {
      if (town != null) {
        sp.setInt('town__id', town.id!);
        sp.setString('town__name', town.name!);
      }
    }
    return true;
  }

  Future<void> fetchTownsListApi({required BuildContext context}) async {
    setTownsList(ApiResponse.loading());
    _repository.fetchTownsList(context: context).then((value) {
      List<TownModel> townsDataList = [];
      value.forEach((element) {
        townsDataList.add(TownModel.fromJson(element));
      });
      setTownsList(ApiResponse.completed(townsDataList));
    }).onError((error, stackTrace) {
      setTownsList(ApiResponse.error(Utils.errorMessage));
    });
  }

  Future<void> fetchWorkerTownsListApi({required BuildContext context, required int workerid}) async {
    setTownsList(ApiResponse.loading());
    _repository.fetchWorkerTownsList(context: context, workerId: workerid).then((value) {
      List<TownModel> townsDataList = [];
      value['data'].forEach((element) {
        townsDataList.add(TownModel.fromJson(element));
      });
      setTownsList(ApiResponse.completed(townsDataList));
    }).onError((error, stackTrace) {
      setTownsList(ApiResponse.error(Utils.errorMessage));
    });
  }

  Future<bool> sendTownsApi({
    required BuildContext context,
    bool profile = false,
    required Map data,
    required int workerId
  }) async {
    await _repository.sendTownApi(
        data: data,
        workerId: workerId,
        context: context
    ).then((value) {
      if (value["success"]) {
        Utils.toastMessage(value["message"]);
        if (profile) {
          Navigator.pushNamed(context, RoutesName.workerProfile);
        } else {
          Navigator.pushNamed(context, RoutesName.sendFilesView);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }
}