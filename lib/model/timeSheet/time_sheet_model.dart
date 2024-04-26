import 'package:quickdep_mob/model/shift/date/shift_date_model.dart';
import 'package:quickdep_mob/model/shift/shift_model.dart';
import 'package:quickdep_mob/model/user/worker_model.dart';

class TimeSheetModel {
  TimeSheetData? data;
  ShiftData? shift;
  String? date;
  String? startHour;
  String? endHour;
  String? code;
  int? pause;
  String? status;
  int? total;
  String? totalString;
  WorkerModel? worker;

  TimeSheetModel({
    this.data,
    this.worker,
    this.shift,
    this.date,
    this.startHour,
    this.endHour,
    this.pause,
    this.code,
    this.status,
    this.total,
    this.totalString
  });

  TimeSheetModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? TimeSheetData.fromJson(json['data']) : null;
    shift = json['shift'] != null ? ShiftData.fromJson(json['shift']) : null;
    date = json['date'];
    startHour = json['startHour'];
    endHour = json['endHour'];
    code = json['code'];
    total = json['total'];
    pause = json['pause'];
    totalString = json['totalString'];
    status = json['status'];
    if (json['worker'] != null) {
      worker = WorkerModel.fromJson(json['worker'], loadAccount: true);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.shift != null) {
      data['shift'] = this.shift!.toJson();
    }
    data['date'] = this.date;
    data['startHour'] = this.startHour;
    data['endHour'] = this.endHour;
    data['code'] = this.code;
    data['total'] = total;
    data['totalString'] = totalString;
    data['pause'] = this.code;
    data['status'] = this.status;
    if (worker != null) {
      data['worker'] = worker!.toJson();
    }
    return data;
  }
}

class TimeSheetData {
  int? id;
  ShiftDateModel? shiftDate;
  String? status;
  String? startdate;
  String? enddate;
  int? pause;
  String? totaltimes;
  bool? enterpriseEdited;

  TimeSheetData({
    this.id,
    this.shiftDate,
    this.status,
    this.startdate,
    this.enddate,
    this.pause,
    this.totaltimes,
    this.enterpriseEdited
  });

  TimeSheetData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shiftDate = json['shiftDate'] != null
        ? ShiftDateModel.fromJson(json['shiftDate'])
        : null;
    status = json['status'];
    startdate = json['startdate'];
    enddate = json['enddate'];
    pause = json['pause'];
    totaltimes = json['totaltimes']?.toString();
    enterpriseEdited = json['enterpriseEdited'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (shiftDate != null) {
      data['shiftDate'] = shiftDate!.toJson();
    }
    data['status'] = status;
    data['startdate'] = startdate;
    data['enddate'] = enddate;
    data['pause'] = pause;
    data['totaltimes'] = totaltimes;
    data['enterpriseEdited'] = enterpriseEdited;
    return data;
  }
}