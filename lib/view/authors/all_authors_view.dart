import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sondeurs/data/response/status.dart';
import 'package:sondeurs/model/user/user_model.dart';
import 'package:sondeurs/resource/config/app_url.dart';
import 'package:sondeurs/resource/config/colors.dart';
import 'package:sondeurs/routes/routes_name.dart';
import 'package:sondeurs/utils/utils.dart';
import 'package:sondeurs/view_model/user/user_view_model.dart';

class AllAuthorsView extends StatefulWidget {
  const AllAuthorsView({super.key});

  @override
  State<StatefulWidget> createState() => _AllAuthorsViewState();
}

class _AllAuthorsViewState extends State<AllAuthorsView> {
  UserViewModel userViewModel = UserViewModel();
  UserModel? user;

  Future getData () async {
    userViewModel.getAuthors();
  }

  @override
  void initState() {
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    super.initState();
    getData();
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
            Navigator.pushNamedAndRemoveUntil(context, RoutesName.home, (route) => false);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Auteurs",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                      "Tous les auteurs",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              RefreshIndicator(
                onRefresh: getData,
                color: AppColors.primaryColor,
                child: ChangeNotifierProvider<UserViewModel>(
                  create: (BuildContext context) => userViewModel,
                  child: Consumer<UserViewModel>(
                    builder: (context, value, _) {
                      switch (value.authorsList.status) {
                        case Status.LOADING:
                          return const Padding(
                            padding: EdgeInsets.all(30),
                            child: CupertinoActivityIndicator(
                              radius: 15,
                              color: Colors.white,
                            ),
                          );
                        case Status.ERROR:
                          return Padding(
                            padding: const EdgeInsets.all(30),
                            child: Text(
                              value.authorsList.message.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        case Status.COMPLETED:
                          if (value.authorsList.data!.users == null || value.authorsList.data!.users!.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/empty.png",
                                      width: 80,
                                      opacity: const AlwaysStoppedAnimation(.1),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: value.authorsList.data!.users.length,
                            itemBuilder: (context, index) {
                              UserModel current = value.authorsList.data!.users[index];
                              return ListTile(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context,
                                      RoutesName.authorDetail,
                                      arguments: current.id!
                                  );
                                },
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    image: current.imagePath == null ? null : DecorationImage(
                                        image: NetworkImage(AppUrl.domainName + current.imagePath.toString()),
                                        fit: BoxFit.cover
                                    ),
                                    color: current.imagePath == null ? Colors.white : null,
                                  ),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${current.firstname} ${current.lastname}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      current.email.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white.withOpacity(.5),
                                        fontSize: 12,
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
                              );
                            },
                          );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: user != null && Utils.isAuthor(user!) ? FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        tooltip: 'Nouveau',
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        onPressed: (){
          Navigator.pushNamed(context, RoutesName.newAuthors);
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ): null,
    );
  }

}