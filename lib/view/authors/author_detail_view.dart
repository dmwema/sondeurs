import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:sondeurs/data/response/status.dart';
import 'package:sondeurs/model/category/category_model.dart';
import 'package:sondeurs/model/lesson/lesson_model.dart';
import 'package:sondeurs/model/user/user_model.dart';
import 'package:sondeurs/resource/audio/common.dart';
import 'package:sondeurs/resource/config/app_url.dart';
import 'package:sondeurs/resource/config/colors.dart';
import 'package:sondeurs/routes/routes_name.dart';
import 'package:sondeurs/service/user_service.dart';
import 'package:sondeurs/view_model/user/user_view_model.dart';

class AuthorDetailView extends StatefulWidget {
  final int id;
  const AuthorDetailView({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => _AuthorDetailViewState();
}

class _AuthorDetailViewState extends State<AuthorDetailView> with WidgetsBindingObserver {
  bool loadingDelete = false;
  UserModel? user;
  UserViewModel userViewModel = UserViewModel();

  @override
  void dispose() {
    userViewModel.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    userViewModel.get(widget.id);
    UserService().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    BuildContext parentContext = context;
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
        title: const Text("", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 17
        ),),
      ),
      body: ChangeNotifierProvider<UserViewModel>(
        create: (BuildContext context) => userViewModel,
        child: Consumer<UserViewModel>(
          builder: (context, value, _) {
            switch (value.authorDetail.status)  {
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
                  child: Center(
                    child: Text(
                      value.authorDetail.message.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              case Status.COMPLETED:
                UserModel author = value.authorDetail.data!;
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: author.imagePath == null ? null : DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(AppUrl.domainName + author.imagePath.toString()),
                          ),
                        ),
                        height: 280.0,
                      ),
                      Container(
                        height: 280.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            gradient: LinearGradient(
                                begin: FractionalOffset.bottomLeft,
                                end: FractionalOffset.topRight,
                                colors: [
                                  AppColors.primaryColor,
                                  AppColors.blackBg.withOpacity(.3),
                                ],
                                stops: const [
                                  0.0,
                                  1.0
                                ]
                            )
                        ),
                        child: const Column(
                          children: [
                          ],
                        ),
                      )
                    ]),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            padding: const EdgeInsets.only(bottom: 10, left: 20),
                            color: Colors.black.withOpacity(.1),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("${author.firstname} ${author.lastname}", style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white
                                  ),),
                                  Text("${author.email}", style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white54
                                  ),),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 20, bottom: 5),
                            color: AppColors.blackBg,
                            child: const Text("Lecons", style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500
                            ),),
                          ),
                          if (author.lessons!.isEmpty)
                            Expanded(
                              child: Center(
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
                              ),
                            ),
                          if (author.lessons!.isNotEmpty)
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: author.lessons!.length,
                                itemBuilder: (context , index) {
                                  LessonModel current = author.lessons![index];
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
                                        image:current.imagePath == null ? null : DecorationImage(
                                            image: NetworkImage( AppUrl.domainName + current.imagePath.toString()),
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
                                          current.description.toString().length > 40 ? current.description.toString().substring(1, 40) : current.description.toString(),
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
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Opens volume slider dialog
        IconButton(
          icon: const Icon(Icons.volume_up, color: Colors.white60, size: 35,),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),

        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CupertinoActivityIndicator(color: Colors.white, radius: 32,),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(CupertinoIcons.play_arrow_solid, color: Colors.white,),
                iconSize: 100.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(CupertinoIcons.pause_fill, color: Colors.white,),
                iconSize: 100.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay, color: Colors.white,),
                iconSize: 100.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
        // Opens speed slider dialog
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white60,
                    fontSize: 18
                )
            ),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}