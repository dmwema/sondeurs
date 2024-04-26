import 'dart:async';
import 'dart:io';

import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickdep_mob/model/account/account_model.dart';
import 'package:quickdep_mob/model/contract/contract_model.dart';
import 'package:quickdep_mob/model/town/town_model.dart';
import 'package:quickdep_mob/model/user/entreprise_model.dart';
import 'package:quickdep_mob/model/user/worker_model.dart';
import 'package:quickdep_mob/view_model/contract/contract_view_model.dart';
import 'package:quickdep_mob/view_model/user/enterprise/enterprise_view_model.dart';
import 'package:quickdep_mob/view_model/user/worker/worker_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class AccountViewModel with ChangeNotifier {
  Future<bool> saveAccount(AccountModel account) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('account__id', account.id!.toInt());
    sp.setString('token', account.token.toString());
    notifyListeners();
    return true;
  }

  Future<bool> addNotification() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int? notifications = sp.getInt('notifications_count');
    if (notifications != null) {
      notifications++;
    } else {
      notifications = 1;
    }
    sp.setInt('notifications_count', notifications);
    notifyListeners();
    return true;
  }

  Future<bool> removeNotification() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int? notifications = sp.getInt('notifications_count');
    if (notifications != null && notifications > 1) {
      notifications--;
    } else {
      notifications = 0;
    }
    sp.setInt('notifications_count', notifications);
    notifyListeners();
    return true;
  }

  Future<int?> getNotification() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int? notifications = sp.getInt('notifications');
    notifyListeners();
    return notifications;
  }

  Future<bool> updateAccount(AccountModel account) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('account__id', account.id!.toInt());
    if (account.token != null) {
      sp.setString('account__token', account.token.toString());
    }
    sp.setString('account__email', account.email!);
    sp.setString('account__phone_number', account.phoneNumber!);
    if (account.imagePath != null) {
      sp.setString('account__imageUrl', account.imagePath!);
    }
    sp.setString('account__type', account.type!);
    if (account.status != null) {
      sp.setString('account__status', account.status!);
    }
    if (account.imagePath != null) {
      sp.setString('account__image_url', account.imagePath!);
    }
    if (account.emailVerified != null) {
      sp.setBool('account__email_verified', account.emailVerified!);
    }
    if (account.phoneNumberVerified != null) {
      sp.setBool('account__phone_number_verified', account.phoneNumberVerified!);
    }

    if (account.contract != null) {
      ContractViewModel().updateContract(account.contract!);
    }

    if (account.enterprise != null) {
      EnterpriseViewModel().updateEnterprise(account.enterprise!);
    }

    if (account.worker != null) {
      WorkerViewModel().updateWorker(account.worker!);
    }

    notifyListeners();
    return true;
  }

  Future<bool> download(BuildContext context, String url, String fileName) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String filePath = '$appDocPath/$fileName';

    try {
      var dio = Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient dioClient) {
        dioClient.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
        return dioClient;
      };
      await dio.download(url, filePath);
      return true;
    }
    catch (e) {
      return false;
    }
  }

  Future<AccountModel> getAccount() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int? id = sp.getInt('account__id');
    String? token = sp.getString('account__token');
    String? email = sp.getString('account__email');
    String? phoneNumber = sp.getString('account__phone_number');
    String? imageUrl = sp.getString('account__image_url');
    String? type = sp.getString('account__type');
    String? status = sp.getString('account__status');
    bool? emailVerified = sp.getBool('account__email_verified');
    bool? phoneNumberVerified = sp.getBool('account__phone_number_verified');

    WorkerModel? worker  = await WorkerViewModel().getWorker();

    AccountModel account = AccountModel(
      id: id,
      token: token,
      email: email,
      phoneNumber: phoneNumber,
      imagePath: imageUrl,
      type: type,
      status: status,
      emailVerified: emailVerified,
      phoneNumberVerified: phoneNumberVerified,
      worker: worker
    );

    // get contract
    int? contractId = sp.getInt('contract__id');
    if (contractId != null) {
      String? contractSignUrl = sp.getString('contract__sign_url');
      bool? contractSigned = sp.getBool('contract__signed');
      String? contractDate = sp.getString('contract__date');

      ContractModel contract = ContractModel(
        id: contractId,
        signUrl: contractSignUrl,
        date: contractDate,
        signed: contractSigned
      );

      account.contract = contract;
    }

    int? enterpriseId = sp.getInt('enterprise__id');
    if (enterpriseId != null) {
      String? enterpriseName = sp.getString('enterprise__name');
      String? enterpriseAddress = sp.getString('enterprise__address');
      String? enterpriseBillingAddress = sp.getString('enterprise__billing_address');
      String? enterpriseZipCode = sp.getString('enterprise__zip_code');
      String? enterpriseBillingZipCode = sp.getString('enterprise__billing_zip_code');
      bool? enterpriseValidated = sp.getBool('enterprise__validated');
      String? enterpriseOwnerName = sp.getString('enterprise__owner_name');
      int? enterprisePaymentMethod = sp.getInt('enterprise__payment_method');

      EnterpriseModel enterprise = EnterpriseModel(
          id: enterpriseId,
          name: enterpriseName,
          ownerName: enterpriseOwnerName,
          address: enterpriseAddress,
          zipCode: enterpriseZipCode,
          billingAddress: enterpriseBillingAddress,
          billingZipCode: enterpriseBillingZipCode,
          validated: enterpriseValidated,
          paymentMethod: enterprisePaymentMethod
      );

      int? townId = sp.getInt('town__id');
      if (enterpriseId != null) {
        String? townName = sp.getString('town__name');

        TownModel town  = TownModel(
            id: townId,
            name: townName
        );

        enterprise.town = town;
      }
      account.enterprise = enterprise;
    }

    int? workerId = sp.getInt('worker__id');
    if (enterpriseId != null) {
      String? enterpriseName = sp.getString('enterprise__name');
      String? enterpriseAddress = sp.getString('enterprise__address');
      String? enterpriseBillingAddress = sp.getString('enterprise__billing_address');
      String? enterpriseZipCode = sp.getString('enterprise__zip_code');
      String? enterpriseBillingZipCode = sp.getString('enterprise__billing_zip_code');
      bool? enterpriseValidated = sp.getBool('enterprise__validated');
      String? enterpriseOwnerName = sp.getString('enterprise__owner_name');
      int? enterprisePaymentMethod = sp.getInt('enterprise__payment_method');

      EnterpriseModel enterprise = EnterpriseModel(
          id: enterpriseId,
          name: enterpriseName,
          ownerName: enterpriseOwnerName,
          address: enterpriseAddress,
          zipCode: enterpriseZipCode,
          billingAddress: enterpriseBillingAddress,
          billingZipCode: enterpriseBillingZipCode,
          validated: enterpriseValidated,
          paymentMethod: enterprisePaymentMethod
      );

      int? townId = sp.getInt('town__id');
      if (enterpriseId != null) {
        String? townName = sp.getString('town__name');

        TownModel town  = TownModel(
            id: townId,
            name: townName
        );

        enterprise.town = town;
      }
      account.enterprise = enterprise;
    }

    return account;
  }

  Future<bool> updateImage(AccountModel account) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('account__image_url', account.imagePath.toString());
    notifyListeners();
    return true;
  }

  Future<bool> remove() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    await sp.setBool('initScreen', true);
    return true;
  }
}