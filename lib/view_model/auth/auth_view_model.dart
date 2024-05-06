import 'package:flutter/widgets.dart';
import 'package:sondeurs/model/user/user_model.dart';
import 'package:sondeurs/repository/auth/auth_repository.dart';
import 'package:sondeurs/routes/routes_name.dart';
import 'package:sondeurs/utils/utils.dart';
import 'package:sondeurs/view_model/user/user_view_model.dart';

class AuthViewModel with ChangeNotifier{
  final _repository = AuthRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> login(dynamic data, BuildContext context) async {
    await _repository.login(data, context: context).then((value) {
      if (value['success'] == true  ) {
        UserModel user = UserModel.fromJson(value['user']);
        user.token = value['token'];
          UserViewModel().updateUser(user).then((value) {
          Utils.toastMessage("Vous êtes connectés avec succès");
          Navigator.pushReplacementNamed(context, RoutesName.home);
        });
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<void> register(dynamic data, BuildContext context) async {
    setLoading(true);
    await _repository.register(data).then((value) {
      print("*********************");
      print("*********************");
      print("*********************");
      print(value);
      setLoading(false);
      if (value["success"] == true) {
        UserModel user = UserModel.fromJson(value['user']);
        user.token = value['token'];
        String message = value['message'];
        UserViewModel().updateImage(user).then((value) {
          Utils.toastMessage(message);
          Navigator.pushReplacementNamed(context, RoutesName.home);
        }
        );
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    });
    // .onError((error, stackTrace) {
    //   Utils.flushBarErrorMessage(Utils.errorMessage, context);
    //   setLoading(false);
    // });
  }
}