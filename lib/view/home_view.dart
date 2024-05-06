import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sondeurs/model/user/user_model.dart';
import 'package:sondeurs/resource/config/colors.dart';
import 'package:sondeurs/routes/routes_name.dart';
import 'package:sondeurs/view_model/user/user_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  UserModel? user;

  @override
  void initState() {
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBg,
      // drawer: SafeArea(
      //   child: Container(
      //     color: Colors.white,
      //     child: const Column(
      //       children: [],
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: const Text("Accueil", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 17
        ),),
        actions: const [
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Colors.white.withOpacity(.05),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Bienvenue", style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(.5),
                      ),),
                      if (user != null)
                      Text("${user!.firstname} ${user!.lastname}", style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                      ),),
                    ],
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(40),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.allLessons);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.primaryColor
                        ),
                        padding: const EdgeInsets.all(20),
                        width: (MediaQuery.of(context).size.width - 90) / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(CupertinoIcons.music_note_list, color: Colors.white, size: 50,),
                            const SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Tous", style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color:  Colors.white.withOpacity(.7)
                                ),),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.allCategories);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.primaryColor
                        ),
                        padding: const EdgeInsets.all(20),
                        width: (MediaQuery.of(context).size.width - 90) / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(CupertinoIcons.square_grid_2x2_fill, color: Colors.white, size: 50,),
                            const SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Categories", style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color:  Colors.white.withOpacity(.7)
                                ),),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.allAuthors);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.primaryColor
                        ),
                        padding: const EdgeInsets.all(20),
                        width: (MediaQuery.of(context).size.width - 90) / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(CupertinoIcons.person_2_fill, color: Colors.white, size: 50,),
                            const SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Auteurs", style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color:  Colors.white.withOpacity(.7)
                                ),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.account);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.primaryColor
                        ),
                        padding: const EdgeInsets.all(20),
                        width: (MediaQuery.of(context).size.width - 90) / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(CupertinoIcons.person_alt, color: Colors.white, size: 50,),
                            const SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Mon compte", style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color:  Colors.white.withOpacity(.7)
                                ),),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text("Proin id ligula dictum, convallis enim uit convallis enim ut, facilisis massa. Mauris a nisi ut sapien blandit imperdie", style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.white.withOpacity(.4)
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}