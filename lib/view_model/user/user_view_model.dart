import 'package:flutter/material.dart';
import 'package:sondeurs/repository/user/user_repository.dart';

class UserViewModel with ChangeNotifier {
  final _myRepo = UserRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // Future<bool> userImage(data, {required BuildContext context, required AccountModel account, required int id}) async {
  //   await _myRepo.userImage(account.id, data, context: context).then((value) {
  //     account.imagePath = value['imageUrl'];
  //     String message = "Photo de profile profile enrégistrée avec succès!";
  //     AccountViewModel().updateImage(account).then((value) {
  //       Utils.toastMessage(message);
  //       if (Utils.isWorker(account)) {
  //         Navigator.pushNamedAndRemoveUntil(context, RoutesName.workerInformation, (route) => false, arguments: ScreenArguments(id));
  //       } else if (Utils.isEnterprise(account)) {
  //         Navigator.pushNamedAndRemoveUntil(context, RoutesName.enterpriseInformation, (route) => false, arguments: ScreenArguments(id));
  //       }
  //     });
  //   }).onError((error, stackTrace) {
  //     print("Une erreur est survenue, veuillez réssayer plutard.");
  //     print(error.toString());
  //     print(stackTrace);
  //   });
  //   return true;
  // }
}