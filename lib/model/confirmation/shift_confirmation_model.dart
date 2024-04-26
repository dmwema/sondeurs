import 'package:quickdep_mob/model/shift/shift_model.dart';
import 'package:quickdep_mob/model/user/worker_model.dart';

class ShiftConfirmationModel {
  ShiftConfirmationData? data;
  bool? consecutive;
  String? date;
  String? startHour;
  String? endHour;
  bool? today;
  bool? started;
  String? hour;
  List<String>? dates;
  Map<String, int>? datesId;
  String? code;
  // ShiftData? shift;
  String? status;

  ShiftConfirmationModel({
    this.data,
    this.consecutive,
    this.started,
    this.today,
    this.date,
    this.hour,
    // this.shift,
    this.dates,
    this.datesId,
    this.code,
    this.status
  });

  ShiftConfirmationModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? ShiftConfirmationData.fromJson(json['data']) : null;
    consecutive = json['consecutive'];
    date = json['date'];
    hour = json['hour'];
    today = json['today'];
    started = json['started'];
    startHour = json['startHour'];
    endHour = json['endHour'];
    if (json['dates'] != null) {
      dates = [];
      json['dates'].forEach((v) {
        dates!.add(v.toString());
      });
    }
    if (json['datesId'] != null) {
      datesId = {};
      json['datesId'].forEach((k, v) {
        datesId!['date$v'] = v;
      });
    }
    // if (json['shift'] != null) {
    //   shift = ShiftData.fromJson(json['shift']);
    // }
    code = json['code'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['consecutive'] = consecutive;
    data['date'] = date;
    data['dates'] = dates;
    data['datesId'] = datesId;  
    data['hour'] = hour;
    data['startHour'] = startHour;
    data['started'] = started;
    data['today'] = today;
    data['endHour'] = endHour;
    data['code'] = code;
    // if (shift != null) {
    //   data['shift'] = shift!.toJson();
    // }
    data['status'] = status;
    return data;
  }
}

class ShiftConfirmationData {
  int? id;
  WorkerModel? worker;
  ShiftData? shift;

  ShiftConfirmationData({this.id, this.worker, this.shift});

  ShiftConfirmationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    worker =
    json['worker'] != null ? WorkerModel.fromJson(json['worker'], loadAccount: true) : null;
    shift = json['shift'] != null ? ShiftData.fromJson(json['shift']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.worker != null) {
      data['worker'] = this.worker!.toJson();
    }
    if (this.shift != null) {
      data['shift'] = this.shift!.toJson();
    }
    return data;
  }
}

