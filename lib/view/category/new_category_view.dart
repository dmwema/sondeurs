import 'dart:io';

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
class NewCategoryView extends StatefulWidget {
  const NewCategoryView({super.key});

  @override
  State<StatefulWidget> createState() => _NewCategoryViewState();
}

class _NewCategoryViewState extends State<NewCategoryView> {
  CategoryViewModel categoryViewModel = CategoryViewModel();
  bool loading = false;

  final TextEditingController _nameController = TextEditingController();

  XFile? image;

  final ImagePicker picker = ImagePicker();

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
            Navigator.pushNamedAndRemoveUntil(context, RoutesName.allCategories, (route) => false);
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
                      "Nouvelle categorie",
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
                        label: "Nom",
                        hint: "Entrez le nom de la categorie",
                        controller: _nameController,
                        password: false
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
                    const SizedBox(height: 20,),
                    RoundedButton(
                        title: "Enregistrer",
                        loading: loading,
                        onPress: () async {
                          if (!loading) {
                            if (_nameController.text == "") {
                              Utils.flushBarErrorMessage("Vous devez entrer le nom de la categorie", context);
                            } else {
                              setState(() {
                                loading = true;
                              });
                              Map data = {
                                "name": _nameController.text,
                              };
                              Map<String, dynamic> files = {
                                "image": image,
                              };

                              await categoryViewModel.create(data, files).then((value) {
                                setState(() {
                                  loading = false;
                                });
                                if (value) {
                                  Utils.toastMessage("Categorie enregistre avec succes");
                                  Navigator.pushNamedAndRemoveUntil(context, RoutesName.allCategories, (route) => false);
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