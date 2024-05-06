import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:easy_audio_trimmer/easy_audio_trimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sondeurs/data/response/status.dart';
import 'package:sondeurs/model/lesson/lesson_model.dart';
import 'package:sondeurs/model/user/user_model.dart';
import 'package:sondeurs/resource/audio/common.dart';
import 'package:sondeurs/resource/components/popup/confirm_popup.dart';
import 'package:sondeurs/resource/components/shimmer/profile_picture_shimmer.dart';
import 'package:sondeurs/resource/config/app_url.dart';
import 'package:sondeurs/resource/config/colors.dart';
import 'package:sondeurs/routes/routes_name.dart';
import 'package:sondeurs/service/user_service.dart';
import 'package:sondeurs/utils/utils.dart';
import 'package:sondeurs/view/lessons/edit_view.dart';
import 'package:sondeurs/view_model/lessons/lessons_view_model.dart';
import 'package:dio/dio.dart';

class DetailView extends StatefulWidget {
  final int id;
  const DetailView({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> with WidgetsBindingObserver {
  final _player = AudioPlayer();
  bool empty = false;
  bool audioLoaded = false;
  bool loadingDelete = false;
  UserModel? user;
  LessonViewModel lessonViewModel = LessonViewModel();

  bool isLoading = false;

  bool loadingDetail = true;
  bool loadingSimilar = true;
  bool loading = false;

  File? audioFile;

  LessonModel? lessonData;

  final Trimmer _trimmer = Trimmer();

  Future<void> downloadFile(String url) async {
    final appDocumentsDir = await getApplicationDocumentsDirectory();
    final savePath = '${appDocumentsDir.path}/lesson.mp3';

    final dio = Dio();
    await dio.download(url, savePath);
    setState(() {
      audioFile = File(savePath);
    });
  }

  @override
  void dispose() {
    lessonViewModel.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _player.stop();
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero)
      )
  ;

  @override
  void initState() {
    super.initState();
    lessonViewModel.get(widget.id);
    lessonViewModel.getSimilar(widget.id);
    ambiguates(WidgetsBinding.instance)!.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    UserService().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    _player.playbackEventStream.listen((event) {},
      onError: (Object e, StackTrace stackTrace) {
        print('A stream error occurred: $e');
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
        actions: [
          IconButton(onPressed: () async {
            if (audioFile != null && lessonData != null) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return EditView(
                      lesson: lessonData!,
                      file: audioFile!
                  );
                }),
              );
            }
          }, icon: const Icon(Icons.cut, color: Colors.white,)),
          IconButton(onPressed: () async {
            if (lessonData != null && audioFile != null) {
              Share.shareXFiles([XFile(audioFile!.path)]);
            }
          }, icon: const Icon(Icons.share_rounded, color: Colors.white,)),
          if (user != null && Utils.isAuthor(user!))
          IconButton(onPressed: () {
            showDialog(
              context: context, builder: (context) {
                return Dialog(
                  shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: ConfirmPopUp(
                    onConfirm: () async {
                      await lessonViewModel.delete(widget.id).then((value) {
                        if (value) {
                          Utils.toastMessage("Lecon supprime avec succes");
                          Navigator.of(parentContext).pushNamedAndRemoveUntil(
                              RoutesName.allLessons,
                                  (route) => false
                          );
                        } else {
                          Utils.flushBarErrorMessage("Impossible de supprimer cette lecon", context);
                          Navigator.pop(parentContext);
                        }
                      });
                    },
                    message: "Etes-vous sure de vouloir suppriemer cette lesson ?",
                  ),
                );
              }
            );
          }, icon: const Icon(Icons.delete_outline, color: Colors.white,)),
        ],
      ),
      body: ChangeNotifierProvider<LessonViewModel>(
        create: (BuildContext context) => lessonViewModel,
        child: Consumer<LessonViewModel>(
          builder: (context, value, _) {
            switch (value.lessonDetail.status)  {
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
                      value.lessonsList.message.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              case Status.COMPLETED:
                LessonModel lesson = value.lessonDetail.data!;
                lessonData = lesson;
                if (!audioLoaded) {
                  audioLoaded = true;
                  downloadFile(AppUrl.domainName + lesson.audioPath.toString());
                  _player.setAudioSource(AudioSource.uri(Uri.parse(AppUrl.domainName + lesson.audioPath.toString())));
                }
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: lesson.imagePath == null ? null : DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(AppUrl.domainName + lesson.imagePath.toString()),
                          ),
                        ),
                        height: 300.0,
                      ),
                      Container(
                        height: 300.0,
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
                        child: Column(
                          children: [
                            SizedBox(
                              height: 240,
                              child: ControlButtons(_player)
                            ),
                            Container(
                              height: 60,
                              color: Colors.black.withOpacity(.4),
                              child: StreamBuilder<PositionData>(
                                stream: _positionDataStream,
                                builder: (context, snapshot) {
                                  final positionData = snapshot.data;
                                  return SeekBar(
                                    duration: positionData?.duration ?? Duration.zero,
                                    position: positionData?.position ?? Duration.zero,
                                    bufferedPosition:
                                    positionData?.bufferedPosition ?? Duration.zero,
                                    onChangeEnd: _player.seek,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            height: 90,
                            padding: const EdgeInsets.only(bottom: 10, left: 20),
                            color: Colors.black.withOpacity(.1),
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            backgroundColor: Colors.transparent,
                                            builder: (context) {
                                                return StatefulBuilder(
                                                    builder: (context, setState) {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(10)
                                                        ),
                                                        margin: const EdgeInsets.all(10),
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width,
                                                          padding: const EdgeInsets.all(20),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Flexible(
                                                                child: Text(lesson.title.toString(), style: const TextStyle(
                                                                    fontSize: 20,
                                                                    fontWeight: FontWeight.w600,
                                                                    color: Colors.black
                                                                ),),
                                                              ),
                                                              const SizedBox(height: 2,),
                                                              if (lesson.author != null)
                                                                Text("${lesson.author!.firstname} ${lesson.author!.lastname}", style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w400,
                                                                    color: Colors.black.withOpacity(.5)
                                                                )),
                                                              const Divider(),
                                                              Flexible(
                                                                child: Text(lesson.description.toString(), style: const TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.w400,
                                                                    color: Colors.black
                                                                ),),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                );
                                              }
                                          );
                                        },
                                        icon: Icon(Icons.info_outline, color: Colors.white,)
                                      ),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(lesson.title.toString(), style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white
                                        ),),
                                      ),
                                      const SizedBox(height: 2,),
                                      if (lesson.author != null)
                                      Text("${lesson.author!.firstname} ${lesson.author!.lastname}", style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white.withOpacity(.5)
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 20, bottom: 5),
                            color: AppColors.blackBg,
                            child: const Text("Suggestions", style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500
                            ),),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: ChangeNotifierProvider<LessonViewModel>(
                                create: (BuildContext context) => lessonViewModel,
                                child: Consumer<LessonViewModel>(
                                  builder: (context, value, _) {
                                    switch (value.lessonsList.status) {
                                      case Status.LOADING:
                                        return ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: 3,
                                          itemBuilder: (context , index) {
                                            return ListTileShimmer(
                                              titleWidth: index == 1 ? 180 : (index == 2 ? 130 : 100),
                                            );
                                          },
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
                                          itemBuilder: (context , index) {
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
                                                  image:current.imagePath == null ? null : DecorationImage(
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
                                        );
                                    }
                                  },
                                ),
                              ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        tooltip: 'Commentaires',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
        },
        child: const Icon(Icons.chat_outlined, color: Colors.white, size: 28),
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