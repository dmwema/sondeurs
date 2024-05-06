import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sondeurs/model/user/user_model.dart';
import 'package:sondeurs/resource/config/app_url.dart';
import 'package:sondeurs/resource/config/colors.dart';
import 'package:sondeurs/routes/routes_name.dart';
import 'package:sondeurs/view_model/user/user_view_model.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<StatefulWidget> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    UserViewModel().getUser().then((value) {
      setState(() {
        user= value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBg,
      drawer: SafeArea(
        child: Container(
          color: Colors.white,
          child: const Column(
            children: [],
          ),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: const Text("Compte", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 17
        ),),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.white,)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.logout, color: Colors.white,)),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: AppColors.lightBlackBg,
                  width: MediaQuery.of(context).size.width,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mon compte",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: user!.imagePath != null ? NetworkImage(AppUrl.domainName + user!.imagePath.toString()) : null,
                  ),
                ),
                Text("${user!.firstname} ${user!.lastname}", style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                ), textAlign: TextAlign.center,),
                const SizedBox(height: 20,),
                ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      onTap: () {
                      },
                      leading: const Icon(Icons.person_remove_alt_1_outlined, color: Colors.white,),
                      title: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Modifier les informations du compte",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white24,
                        size: 15,
                      ),
                      shape: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(.1),
                        ),
                      ),
                      iconColor: Colors.white.withOpacity(.7),
                    ),
                    ListTile(
                      onTap: () {
                      },
                      leading: Icon(Icons.photo_camera_back_outlined, color: Colors.white,),
                      title: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Modifier la photo de profil",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white24,
                        size: 15,
                      ),
                      shape: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(.1),
                        ),
                      ),
                      iconColor: Colors.white.withOpacity(.7),
                    ),
                    ListTile(
                      onTap: () {
                      },
                      leading: Icon(Icons.password, color: Colors.white,),
                      title: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Modifier le mot de passe",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white24,
                        size: 15,
                      ),
                      shape: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(.1),
                        ),
                      ),
                      iconColor: Colors.white.withOpacity(.7),
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                TextButton(onPressed: () {
                  UserViewModel().remove().then((value) {
                    Navigator.pushNamed(context, RoutesName.welcome);
                  });
                }, child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, size: 20, color: Colors.red,),
                    SizedBox(width: 10,),
                    Text("Se deconnecter", style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold
                    ),),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}