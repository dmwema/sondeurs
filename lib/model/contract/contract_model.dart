import 'package:quickdep_mob/model/account/account_model.dart';

class ContractModel {
  int? id;
  String? signUrl;
  String? date;
  bool? signed;
  AccountModel? account;

  ContractModel({
    this.id,
    this.signUrl,
    this.date,
    this.signed,
    this.account,
  });

  ContractModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    signUrl = json['signUrl'];
    date = json['date'];
    signed = json['signed'];
    account = json['account'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['signUrl'] = this.signUrl;
    data['date'] = this.date;
    data['signed'] = this.signed;
    data['account'] = this.account;
    return data;
  }
}