import 'package:quickdep_mob/model/shift/shift_model.dart';

class ShiftDateModel {
  int? id;
  // String? start;
  // String? end;
  ShiftData? shift;
  String? code;
  int? late;
  int? pause;
  bool? notify2sent;
  bool? notify24sent;
  String? status;

  ShiftDateModel({
    this.id,
    // this.start,
    // this.end,
    this.shift,
    this.code,
    this.late,
    this.pause,
    this.notify2sent,
    this.notify24sent,
    this.status
  });

  ShiftDateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    late = json['late'];
    pause = json['pause'];
    notify2sent = json['notify2sent'];
    notify24sent = json['notify24sent'];
    status = json['status'];
    if (json['shift'] != null) {
      shift = ShiftData.fromJson(json['shift']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    // data['start'] = start;
    // data['end'] = end;
    if (shift != null) {
      data['shift'] = shift!.toJson();
    }
    data['code'] = code;
    data['late'] = late;
    data['pause'] = pause;
    data['notify2sent'] = notify2sent;
    data['notify24sent'] = notify24sent;
    data['status'] = status;
    return data;
  }
}