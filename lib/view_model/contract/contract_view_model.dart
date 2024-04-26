import 'package:flutter/material.dart';
import 'package:quickdep_mob/model/contract/contract_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContractViewModel with ChangeNotifier {
  Future<bool> updateContract(ContractModel contract) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('contract__id', contract.id!);
    if (contract.signUrl != null) {
      sp.setString('contract__sign_url', contract.signUrl.toString());
    }
    if (contract.date != null) {
      sp.setString('contract__date', contract.date.toString());
    }
    if (contract.signed != null) {
      sp.setBool('contract__signed', contract.signed!);
    }
    return true;
  }
}