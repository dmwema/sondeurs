import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sondeurs/data/response/status.dart';
import 'package:sondeurs/model/lesson/lesson_model.dart';
import 'package:sondeurs/resource/config/colors.dart';
import 'package:sondeurs/routes/routes_name.dart';
import 'package:sondeurs/view_model/lessons/lessons_view_model.dart';

class AllView extends StatefulWidget {
  const AllView({super.key});

  @override
  State<StatefulWidget> createState() => _AllViewState();
}

class _AllViewState extends State<AllView> {
  LessonViewModel lessonViewModel = LessonViewModel();

  Future getData () async {
    lessonViewModel.getCollection();
  }

  @override
  void initState() {
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
          "Enseignements",
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
        child: RefreshIndicator(
          onRefresh: getData,
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
                        "Tous les enseignements",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                ChangeNotifierProvider<LessonViewModel>(
                  create: (BuildContext context) => lessonViewModel,
                  child: Consumer<LessonViewModel>(
                    builder: (context, value, _) {
                      switch (value.lessonsList.status) {
                        case Status.LOADING:
                          return const Padding(
                            padding: EdgeInsets.all(30),
                            child: Center(
                              child: CupertinoActivityIndicator(
                                radius: 15,
                                color: Colors.white,
                              ),
                            ),
                          );
                        case Status.ERROR:
                          return Padding(
                            padding: const EdgeInsets.all(30),
                            child: Text(
                              value.lessonsList.message.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        case Status.COMPLETED:
                          if (value.lessonsList.data!.lessons == null || value.lessonsList.data!.lessons.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 30,),
                                  Image.asset(
                                    "assets/empty.png",
                                    width: 80,
                                    opacity: const AlwaysStoppedAnimation(.1),
                                  ),
                                ],
                              ),
                            );
                          }
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: value.lessonsList.data!.lessons.length,
                            itemBuilder: (context, index) {
                              LessonModel current = value.lessonsList.data!.lessons[index];
                              return ListTile(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RoutesName.lessonDetail,
                                    arguments: current.id!
                                  );
                                },
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    image: current.imagePath == null ? null : DecorationImage(
                                        image: NetworkImage(current.imagePath.toString()),
                                        fit: BoxFit.cover
                                    ),
                                    color: current.imagePath == null ? Colors.white : null,
                                  ),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      current.title.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      current.description.toString().substring(1, 40),
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
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        tooltip: 'Nouveau',
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        onPressed: (){
          Navigator.pushNamed(context, RoutesName.newLesson);
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}