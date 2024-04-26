import 'package:quickdep_mob/model/document/document_type_model.dart';

class DocumentModel {
  int? id;
  String? status;
  DocumentTypeModel? type;
  String? text;
  String? message;
  String? fileUrl;

  DocumentModel({
    this.id,
    this.status,
    this.type,
    this.message,
    this.text,
    this.fileUrl
  });

  DocumentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    type = json['type'] != null ? DocumentTypeModel.fromJson(json['type']) : null;
    text = json['text'];
    message = json['message'];
    fileUrl = json['fileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['status'] = status;
    if (type != null) {
      data['type'] = type!.toJson();
    }
    data['text'] = text;
    data['message'] = message;
    data['fileUrl'] = fileUrl;
    return data;
  }
}

