import 'package:flutter/material.dart';
import 'package:quickdep_mob/data/response/api_response.dart';
import 'package:quickdep_mob/model/invoice/invoice_model.dart';
import 'package:quickdep_mob/repository/invoice/invoice_repository.dart';
import 'package:quickdep_mob/utils/utils.dart';

class   InvoiceViewModel with ChangeNotifier {
  final _myRepo = InvoiceRepository();
  ApiResponse<dynamic> invoicesList = ApiResponse.loading();

  bool _loading = false;
  bool _loadingDownload = false;
  bool get loading => _loading;
  bool get loadingDownload => _loadingDownload;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setLoadingDownload(bool value) {
    _loadingDownload = value;
    notifyListeners();
  }

  setInvoicesList (ApiResponse<dynamic> response) {
    invoicesList = response;
    notifyListeners();
  }

  Future<void> fetchAllInvoicesListApi({required BuildContext context, required bool paid}) async {
    setInvoicesList(ApiResponse.loading());
    _myRepo.fetchAllInvoicesListApi(context: context).then((value) {
      if (value['success']) {
        List returnList = [];
        value['data'].forEach((element) {
          if (paid) {
            if (element['paid']) {
              returnList.add(element);
            }
          } else {
            if (element['paid'] != true) {
              returnList.add(element);
            }
          }
        });
        setInvoicesList(ApiResponse.completed(returnList));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    });
  }

  Future<void> downloadInvoicesApi({required BuildContext context, required int invoiceId}) async {
    setLoadingDownload(true);
    await _myRepo.downloadInvoicesApi(context: context, invoiceId: invoiceId).then((value) {
      if (value['success']) {
        Utils.toastMessage(value['message']);
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
      setLoadingDownload(false);
    }).onError((error, stackTrace) {
    });
  }
}