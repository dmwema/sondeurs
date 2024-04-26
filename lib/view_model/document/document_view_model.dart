import 'package:flutter/material.dart';
import 'package:quickdep_mob/data/response/api_response.dart';
import 'package:quickdep_mob/model/document/document_models.dart';
import 'package:quickdep_mob/repository/documents/document_repository.dart';
import 'package:quickdep_mob/utils/utils.dart';
import 'package:quickdep_mob/view_model/user/worker/worker_view_model.dart';

class DocumentViewModel with ChangeNotifier {
  final _myRepo = DocumentRepository();
  ApiResponse<List<DocumentModel>> documents = ApiResponse.loading();
  bool success = false;
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setDocuments (ApiResponse<List<DocumentModel>> response) {
    documents = response;
    notifyListeners();
  }

  setSuccess (bool value) {
    success = value;
    notifyListeners();
  }

  Future<void> fetchDocumentTypeApi(id, {required BuildContext context}) async {
    setDocuments(ApiResponse.loading());
    _myRepo.fetchDocumentTypes(id, context: context).then((value) {
      if (value['success']) {
        setLoading(false);
        List<DocumentModel> documentsList = [];
        value['data'].forEach((element) {
          documentsList.add(DocumentModel.fromJson(element));
        });
        setDocuments(ApiResponse.completed(documentsList));
      }

    }).onError((error, stackTrace) {
      setDocuments(ApiResponse.error(Utils.errorMessage));
    });
  }

  Future<bool> sendFileApi(dynamic data, BuildContext context) async {
    setLoading(true);
    await _myRepo.senFileApi(data, context: context).then((value) async {
      setLoading(false);
      if (value["success"]) {
        String documentsStatus = value['worker_status'];
        String message = value['message'];
        await WorkerViewModel().updateWorkerStatus(documentsStatus).then((value) {
          if (value == true) {
            setSuccess(true);
            Utils.toastMessage(message);
            return true;
          } else {
            Utils.flushBarErrorMessage("Erreur lors de l'enrégistrément de l'utilisateur", context);
          }
        });
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return success;
  }

  Future<bool> sendTextApi(dynamic data, id, BuildContext context) async {
    setLoading(true);
    await _myRepo.sendTextApi(data, id, context: context).then((value) async {
      setLoading(false);
      if (value["success"]) {
        String documentsStatus = value['worker_status'];
        String message = value['message'];
        await WorkerViewModel().updateWorkerStatus(documentsStatus).then((value) {
          if (value == true) {
            setSuccess(true);
            Utils.flushBarErrorMessage(message, context);
            return true;
          } else {
            Utils.flushBarErrorMessage("Erreur lors de l'enrégistrément de l'utilisateur", context);
          }
        });
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return success;
  }
}