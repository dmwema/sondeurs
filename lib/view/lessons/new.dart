import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sondeurs/model/category/category_model.dart';
import 'package:sondeurs/resource/components/buttons/rounded_button.dart';
import 'package:sondeurs/resource/components/form/form_field.dart';
import 'package:sondeurs/resource/config/colors.dart';
import 'package:sondeurs/routes/routes_name.dart';
import 'package:sondeurs/utils/utils.dart';
import 'package:sondeurs/view_model/category/category_view_model.dart';
import 'package:sondeurs/view_model/lessons/lessons_view_model.dart';
import 'package:audioplayers_platform_interface/src/api/player_state.dart' as AudioPlayerState;
class NewView extends StatefulWidget {
  const NewView({super.key});

  @override
  State<StatefulWidget> createState() => _NewViewState();
}

class _NewViewState extends State<NewView> {
  LessonViewModel lessonViewModel = LessonViewModel();
  CategoryViewModel categoryViewModel = CategoryViewModel();
  CategoryListModel? categories;
  CategoryModel? selectedCategory;
  String time = "00:00";

  bool loading = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  XFile? image;

  File? audioFile;
  bool isPlaying = false;
  Duration audioDuration = Duration.zero;
  Duration position = Duration.zero;

  bool recorderOpen = false;

  final ImagePicker picker = ImagePicker();

  AudioPlayer audioPlayer = AudioPlayer();

  final recorder = FlutterSoundRecorder();

  Duration duration = Duration.zero;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      await recorder.openRecorder();
      recorder.setSubscriptionDuration(
          const Duration(milliseconds: 100)
      );
    }
  }

  Future setAudio () async {
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == AudioPlayerState.PlayerState.playing;
      });
      print("----------------- paying -----------------");
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
      print("----------------- $position -----------------");
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        audioDuration = newDuration;
      });
      print("----------------- $audioDuration -----------------");
    });
    await audioPlayer.getDuration().then((value) {
      setState(() {
        audioDuration = value ?? Duration.zero;
      });
    });
    audioPlayer.setReleaseMode(ReleaseMode.stop);
    audioPlayer.setSourceUrl(audioFile!.path.toString());
  }

  Future getCategories () async {
    categoryViewModel.getCollection().then((value) {
      setState(() {
        categories = value;
      });
    });
  }

  Future record () async {
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    await recorder.stopRecorder().then((value) {
      setState(() {
        audioFile = File(value.toString());
      });
      setAudio();
      print(value);
    });
  }

  Future resume () async {
    recorder.resumeRecorder();
  }

  void updateSelectedCategory(CategoryModel category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  void initState() {
    initRecorder();
    super.initState();
    getCategories();
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
            Navigator.pushNamedAndRemoveUntil(context, RoutesName.allLessons, (route) => false);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Nouveau",
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
                      "Nouvel enseignement",
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CustomFormField(
                      label: "Titre",
                      hint: "Entrez un titre",
                      controller: _titleController,
                      password: false
                    ),
                    const SizedBox(height: 10,),
                    CustomFormField(
                      label: "Description",
                      hint: "Entrez une description",
                      maxLines: 3,
                      password: false,
                      controller: _descriptionController,
                    ),
                    const SizedBox(height: 10,),
                    InkWell(
                      onTap: () {
                        if (categories == null) {
                          return;
                        }
                        showModalBottomSheet(
                          context: context,
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
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: categories!.categories!.length,
                                      itemBuilder: (context, index) {
                                        CategoryModel current = categories!.categories![index];
                                        return InkWell(
                                          onTap: () {
                                            updateSelectedCategory(current);
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: selectedCategory != null && current.id == selectedCategory!.id ? AppColors.primaryColor.withOpacity(.3 ) : Colors.white,
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                            child: Text(current.name.toString(), style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500
                                            ),),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                            );
                          }
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(top: 14, bottom: 14, left: 16, right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white.withOpacity(.1),
                        ),
                        child: Row(
                          children: [
                            if (categories == null)
                            CupertinoActivityIndicator(color: Colors.white.withOpacity(.5), radius: 10,),
                            if (categories == null)
                            const SizedBox(width: 10,),
                            Row(
                              children: [
                                Text("Categorie", style: TextStyle(
                                    color: Colors.white.withOpacity(.5)
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                if (selectedCategory != null)
                                  Text(selectedCategory!.name.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    InkWell(
                      onTap: () async {
                        var img = await picker.pickImage(source: ImageSource.gallery).onError((error, stackTrace) {
                          Utils.flushBarErrorMessage("Une erreur est survenue lors de l'importation de l'image", context);
                          return null;
                        });
                        if (img != null) {
                          setState(() {
                            image = img;
                          });
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(top: 14, bottom: 14, left: 16, right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: image == null ? Colors.white.withOpacity(.1) : Colors.green.withOpacity(.1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(CupertinoIcons.photo, color: Colors.white.withOpacity(.5), size: 18,),
                                const SizedBox(width: 10,),
                                Text("Image a la une", style: TextStyle(
                                    color: Colors.white.withOpacity(.5)
                                ),
                                ),
                              ],
                            ),
                            if (image != null)
                            const Icon(CupertinoIcons.checkmark_circle, color: CupertinoColors.activeGreen, size: 18,)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 10, right: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: recorder.isRecording ? Colors.orangeAccent.withOpacity(.1) : audioFile != null ? Colors.green.withOpacity(.1) : Colors.white.withOpacity(.1),
                        border: Border.all(width: 1, color: audioFile == null ? Colors.white : Colors.green.withOpacity(.7))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (!recorder.isRecording && audioFile == null)
                            Row(
                              children: [
                                Icon(CupertinoIcons.music_note, color: Colors.white.withOpacity(.7), size: 18,),
                                const SizedBox(width: 10,),
                                Text("Enregistrer l'enseignement", style: TextStyle(
                                    color: Colors.white.withOpacity(.7)
                                ),
                                ),
                              ],
                            ),

                          if (recorder.isStopped && audioFile != null)
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    if (isPlaying) {
                                      await audioPlayer.pause();
                                    } else {
                                      await audioPlayer.resume();
                                    }
                                  },
                                  icon: Icon(isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_arrow_solid, color: Colors.white.withOpacity(.7), size: 18,)
                                ),
                                Text("${position.inMinutes.toString().padLeft(2, '0')}:${position.inSeconds.toString().padLeft(2, '0')}", style: const TextStyle(
                                  color: Colors.white
                                ),),
                                Slider(
                                  min: 0,
                                  max: audioDuration.inSeconds.toDouble(),
                                  value: position.inSeconds.toDouble(),
                                  onChanged: (value) async {
                                    final position = Duration(seconds: value.toInt());
                                    await audioPlayer.seek(position);
                                    await audioPlayer.resume();
                                  },
                                  activeColor: AppColors.primaryColor,
                                ),
                                Text("${audioDuration.inMinutes.toString().padLeft(2, '0')}:${audioDuration.inSeconds.toString().padLeft(2, '0')}", style: const TextStyle(
                                    color: Colors.white
                                ),),
                              ],
                            ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                if (recorder.isRecording)
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Image.asset("assets/wave.gif", width: 20, opacity: const AlwaysStoppedAnimation(.5),),
                                    const SizedBox(width: 10),
                                    if (recorder.isRecording)
                                      StreamBuilder<RecordingDisposition>(
                                          stream: recorder.onProgress,
                                          builder: (context, snapshot) {
                                            if (recorder.isRecording && snapshot.hasData) {
                                              duration = snapshot.data!.duration;

                                              String twoDigits(int n) => n.toString().padLeft(2, '0');
                                              String min = twoDigits(duration.inMinutes.remainder(60));
                                              String sec = twoDigits(duration.inSeconds.remainder(60));

                                              time = "$min:$sec";
                                            }

                                            return Text(time, style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600
                                            ),);
                                          }
                                      ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (recorder.isRecording)
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              await stop();
                                              setState(() {});
                                            },
                                            icon: const Icon(
                                              CupertinoIcons.stop_circle_fill,
                                              color: Colors.white, size: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                                if (recorder.isStopped && audioFile == null)
                                  IconButton(
                                    onPressed: () async {
                                      await record();
                                      setState(() {
                                      });
                                    },
                                    icon: Icon(
                                      audioFile == null ? CupertinoIcons.mic_circle_fill : CupertinoIcons.trash_circle_fill,
                                      color: Colors.white, size: 40,
                                    ),
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    if (recorder.isStopped && audioFile != null)
                    const SizedBox(height: 5,),
                    if (recorder.isStopped && audioFile != null)
                      InkWell(
                      onTap: () {
                        setState(() {
                          audioFile = null;
                        });
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Annuler", style: TextStyle(
                            color: Colors.white
                          ),),
                          SizedBox(width: 5,),
                          Icon(Icons.close, color: Colors.white, size: 18,)
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    RoundedButton(
                      title: "Enregistrer",
                      loading: loading,
                      onPress: () async {
                        if (!loading) {
                          if (_titleController.text == "") {
                            Utils.flushBarErrorMessage("Vous devez entrer un titre", context);
                          } else if (_descriptionController.text == "") {
                            Utils.flushBarErrorMessage("Vous devez entrer une description", context);
                          } else if (selectedCategory == null) {
                            Utils.flushBarErrorMessage("Vous devez selectionner une categorie", context);
                          } else if (audioFile == null) {
                            Utils.flushBarErrorMessage("Vous devez enregistrer la lecon", context);
                          } else {
                            setState(() {
                              loading = true;
                            });
                            Map data = {
                              "title": _titleController.text,
                              "description": _descriptionController.text,
                              "category": "${selectedCategory!.id}",
                            };
                            Map<String, dynamic> files = {
                              "image": image,
                              "audio": audioFile
                            };

                            await lessonViewModel.create(data, files).then((value) {
                              setState(() {
                                loading = false;
                              });
                              if (value) {
                                Utils.toastMessage("Lecon enregistre avec succes");
                                Navigator.pushNamedAndRemoveUntil(context, RoutesName.allLessons, (route) => false);
                              } else {
                                Utils.flushBarErrorMessage("Une erreur est survenue. Veuillez verifier les informations entrees", context);
                              }
                            });
                          }
                        }
                      }
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}