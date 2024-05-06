import 'dart:io';

import 'package:easy_audio_trimmer/easy_audio_trimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sondeurs/model/lesson/lesson_model.dart';
import 'package:sondeurs/model/user/user_model.dart';
import 'package:sondeurs/resource/config/app_url.dart';
import 'package:sondeurs/resource/config/colors.dart';
import 'package:sondeurs/utils/utils.dart';

class EditView extends StatefulWidget {
  final File file;
  final LessonModel lesson;
  const EditView({required this.file, required this.lesson, super.key});

  @override
  State<StatefulWidget> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> with WidgetsBindingObserver {
  UserModel? user;
  bool _isPlaying = false;
  bool _progressVisibility = false;
  bool isLoading = false;
  double _startValue = 0.0;
  double _endValue = 0.0;

  bool loading = false;
  File? audioFile;

  final Trimmer _trimmer = Trimmer();

  void _loadAudio() async {
    setState(() {
      isLoading = true;
    });

    await _trimmer.loadAudio(audioFile: widget.file);

    setState(() {
      isLoading = false;
    });
  }

  _saveAudio() {
    setState(() {
      _progressVisibility = true;
    });

    _trimmer.saveTrimmedAudio(
      startValue: _startValue,
      endValue: _endValue,
      audioFileName: DateTime.now().millisecondsSinceEpoch.toString(),
      onSave: (outputPath) {
        setState(() {
          _progressVisibility = false;
        });

        if (outputPath == null) {
          Utils.flushBarErrorMessage("Une erreur est survenue, Veuillez ressayer plutard", context);
        } else {
          Utils.toastMessage("Audio enregistre dans le stockage du telephone");
        }
        debugPrint('OUTPUT PATH: $outputPath');
      },
    );
  }

  _shareAudio() {
    setState(() {
      _progressVisibility = true;
    });

    _trimmer.saveTrimmedAudio(
      startValue: _startValue,
      endValue: _endValue,
      audioFileName: DateTime.now().millisecondsSinceEpoch.toString(),
      onSave: (outputPath) {
        setState(() {
          _progressVisibility = false;
        });
        if (outputPath == null) {
          Utils.flushBarErrorMessage("Une erreur est survenue, Veuillez ressayer plutard", context);
        } else {
          Share.shareXFiles([XFile(outputPath.toString())]);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBg,
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
        actions: const [
        ],
      ),
      body: isLoading
          ? const Padding(
            padding: EdgeInsets.all(30),
            child: Center(child: CupertinoActivityIndicator(radius: 15, color: Colors.white,)),
          )
          : Center(
        child: Container(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Stack(children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: widget.lesson.imagePath == null ? null : DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(AppUrl.domainName + widget.lesson.imagePath.toString()),
                    ),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  height: 350.0,
                  margin: const EdgeInsets.all(20),
                ),
                Container(
                  height: 350.0,
                  margin: const EdgeInsets.all(20),
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
                      ),
                    borderRadius: BorderRadius.circular(20)
                  ),
                )
              ]),
              const SizedBox(height: 20,),
              Text(widget.lesson.title.toString(), style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.white
              ),),
              const SizedBox(height: 20,),
              if (widget.lesson.author != null)
                Text("${widget.lesson.author!.firstname} ${widget.lesson.author!.lastname}", style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(.5)
                )),
              Visibility(
                visible: _progressVisibility,
                child: LinearProgressIndicator(
                  backgroundColor: AppColors.primaryColor,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TrimViewer(
                        trimmer: _trimmer,
                        viewerHeight: 100,
                        viewerWidth: MediaQuery.of(context).size.width,
                        durationStyle: DurationStyle.FORMAT_MM_SS,
                        backgroundColor: Colors.white10,
                        barColor: Colors.white54,
                        durationTextStyle: const TextStyle(
                            color: Colors.white),
                        allowAudioSelection: true,
                        editorProperties: TrimEditorProperties(
                          circleSize: 10,
                          borderPaintColor: AppColors.primaryColor,
                          borderWidth: 4,
                          borderRadius: 5,
                          circlePaintColor: AppColors.primaryColor,
                        ),
                        areaProperties:
                        TrimAreaProperties.edgeBlur(blurEdges: true),
                        onChangeStart: (value) => _startValue = value,
                        onChangeEnd: (value) => _endValue = value,
                        onChangePlaybackState: (value) {
                          if (mounted) {
                            setState(() => _isPlaying = value);
                          }
                        },
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        color: Colors.black54,
                        child:TextButton(
                          child: _isPlaying
                              ? const Icon(
                            Icons.pause,
                            size: 40.0,
                            color: Colors.white,
                          )
                              : Icon(
                            CupertinoIcons.play_arrow_solid,
                            size: 40.0,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            bool playbackState =
                            await _trimmer.audioPlaybackControl(
                              startValue: _startValue,
                              endValue: _endValue,
                            );
                            setState(() => _isPlaying = playbackState);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: _progressVisibility ? null : () => _shareAudio(),
                              child: Container(
                                width: (MediaQuery.of(context).size.width - 60) / 2,
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                color: Colors.black54,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.share, color: Colors.white,),
                                    SizedBox(width: 15,),
                                    Text("Share", style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20
                                    ),)
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 20,),
                            InkWell(
                              onTap: _progressVisibility ? null : () => _saveAudio(),
                              child: Container(
                                width: (MediaQuery.of(context).size.width - 60) / 2,
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                color: AppColors.primaryColor,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.save, color: Colors.white,),
                                    SizedBox(width: 15,),
                                    Text("Save", style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20
                                    ),)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}