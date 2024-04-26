import 'package:quickdep_mob/model/user/worker_model.dart';

class ApplyData {
  List<String>? datesList;
  String? dateString;
  String? dateColor;
  ApplyModel? data;

  ApplyData({this.datesList, this.data, this.dateString, this.dateColor});

  ApplyData.fromJson(Map<String, dynamic> json) {
    if (json['datesList'] != null) {
      datesList = [];
      json['datesList'].forEach((v) {
        datesList!.add(v);
      });
    }
    dateString = json['dateString'];
    dateColor = json['dateColor'];
    if (json['data'] != null) {
      data = ApplyModel.fromJson(json['data']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataR = <String, dynamic>{};
    if (datesList != null) {
      dataR['datesList'] = datesList;
    }
    if (data != null) {
      dataR['data'] = datesList;
    }
    if (dateString != null) {
      dataR['dateString'] = dateString;
    }
    if (dateColor != null) {
      dataR['dateColor'] = dateColor;
    }
    return dataR;
  }
}

class ApplyModel {
  int? id;
  WorkerModel? worker;
  String? shift;
  bool? consecutive;

  ApplyModel({this.id, this.worker, this.shift, this.consecutive});

  ApplyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['worker'] != null) {
      worker = WorkerModel.fromJson(json['worker'], loadAccount: true);
    }
    shift = json['shift'];
    consecutive = json['consecutive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['worker'] = worker;
    data['shift'] = shift;
    data['consecutive'] = consecutive;
    return data;
  }
}