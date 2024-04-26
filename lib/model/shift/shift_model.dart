import 'package:quickdep_mob/model/apply/apply_model.dart';
import 'package:quickdep_mob/model/confirmation/shift_confirmation_model.dart';
import 'package:quickdep_mob/model/job/job_model.dart';
import 'package:quickdep_mob/model/town/town_model.dart';
import 'package:quickdep_mob/model/user/entreprise_model.dart';

class ShiftModel {
  ShiftData? data;
  bool? consecutive;
  List? datesList;
  String? date;
  String? startHour;
  bool? today;
  String? start;
  String? end;
  String? endHour;
  String? code;
  ShiftConfirmationModel? confirmation;
  String? hour;
  Map? datesIds;
  int? count;
  List<ApplyData>? applies;
  String? status;

  ShiftModel({
    this.data,
    this.applies,
    this.start,
    this.end,
    this.confirmation,
    this.consecutive,
    this.date,
    this.startHour,
    this.hour,
    this.today,
    this.datesList,
    this.endHour,
    this.code,
    this.count,
    this.status,
    this.datesIds
  });

  ShiftModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? ShiftData.fromJson(json['data']) : null;
    consecutive = json['consecutive'];
    date = json['date'];
    startHour = json['startHour'];
    endHour = json['endHour'];
    start = json['start'];
    end = json['end'];
    today = json['today'];
    datesIds = json['datesIds'];
    code = json['code'];
    if (json['confirmation'] != null) {
      confirmation = ShiftConfirmationModel.fromJson(json['confirmation']);
    }
    if (json['datesList'] != null) {
      datesList = [];
      json['datesList'].forEach((v) {
        datesList!.add(v);
      });
    }
    count = json['count'];
    if (json['applies'] != null) {
      applies = [];
      json['applies'].forEach((v) {
        applies!.add(ApplyData.fromJson(v));
      });
    }
    hour = json['hour'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['consecutive'] = consecutive;
    data['date'] = date;
    if (confirmation != null) {
      data['confirmation'] = confirmation!.toJson();
    }
    data['applies'] = applies;
    data['startHour'] = startHour;
    data['endHour'] = endHour;
    data['code'] = code;
    data['today'] = today;
    data['hour'] = hour;
    data['start'] = start;
    data['end'] = end;
    data['count'] = count;
    data['datesIds'] = datesIds;
    if (datesList != null) {
      data['datesList'] = datesList;
    }
    data['status'] = status;
    return data;
  }
}

class ShiftData {
  int? id;
  EnterpriseModel? enterprise;
  JobModel? job;
  TownModel? town;
  int? bonus;
  String? rate;
  String? cloth;
  String? address;
  String? description;
  String? enterpriseRate;
  int? pause;
  bool? consecutive;
  bool? parking;
  DateTime? startDate;
  DateTime? endDate;

  ShiftData({
    this.id,
    this.enterprise,
    this.description,
    this.job,
    this.town,
    this.address,
    this.parking,
    this.bonus,
    this.cloth,
    this.rate,
    this.enterpriseRate,
    this.pause,
    this.consecutive,
    this.startDate,
    this.endDate});

  ShiftData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    enterprise = json['enterprise'] != null
        ? EnterpriseModel.fromJson(json['enterprise'], loadAccount: true)
        : null;
    job = json['job'] != null ? JobModel.fromJson(json['job']) : null;
    town = json['town'] != null ? TownModel.fromJson(json['town']) : null;
    bonus = json['bonus'];
    address = json['address'];
    rate = json['rate'];
    cloth = json['cloth'];
    enterpriseRate = json['enterpriseRate'];
    pause = json['pause'];
    consecutive = json['consecutive'];
    parking = json['parking'];
    description = json['description'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (enterprise != null) {
      data['enterprise'] = enterprise!.toJson();
    }
    if (job != null) {
      data['job'] = job!.toJson();
    }
    if (town != null) {
      data['town'] = town!.toJson();
    }
    data['bonus'] = bonus;
    data['rate'] =rate;
    data['enterpriseRate'] = enterpriseRate;
    data['pause'] =pause;
    data['cloth'] = cloth;
    data['parking'] = parking;
    data['address'] = address;
    data['description'] = description;
    data['consecutive'] = consecutive;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    return data;
  }
}
