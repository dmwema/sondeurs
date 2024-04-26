import 'package:flutter/material.dart';
import 'package:quickdep_mob/model/account/account_model.dart';
import 'package:quickdep_mob/model/apply/apply_model.dart';
import 'package:quickdep_mob/resource/components/buttons/rounded_button.dart';
import 'package:quickdep_mob/resource/components/config/no_data_card.dart';
import 'package:quickdep_mob/resource/components/popup/confirm_popup.dart';
import 'package:quickdep_mob/resource/components/shimmer/profile_picture_shimmer.dart';
import 'package:quickdep_mob/resource/config/app_url.dart';
import 'package:quickdep_mob/resource/config/colors.dart';
import 'package:quickdep_mob/utils/utils.dart';
import 'package:quickdep_mob/view_model/account/account_view_model.dart';
import 'package:quickdep_mob/view_model/apply/apply_view_model.dart';


class WorkerDetailModal extends StatefulWidget {
  final ApplyData data;
  final bool consecutive;
  final bool showActions;
  final bool showContacts;
  final void Function()? onApprove;
  final void Function()? onCancel;

  const WorkerDetailModal({
    Key? key,
    required this.data,
    this.consecutive = false,
    this.showActions = true,
    this.showContacts = false,
    this.onApprove,
    this.onCancel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WorkerDetailModalState();
}

class _WorkerDetailModalState extends State<WorkerDetailModal> {
  ApplyViewModel applyViewModel = ApplyViewModel();
  Map<String, Map> experiencesData = {};
  List<Widget> experiencesList = [];
  AccountModel? account;
  ImageProvider userImg = const AssetImage('assets/default-worker.png');

  @override
  void initState() {
    super.initState();
    AccountViewModel().getAccount().then((value) {
      setState(() {
        account = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!Utils.empty(widget.data.data!.worker!.account!.imagePath)) {
      setState(() {
        userImg = NetworkImage(
          "${AppUrl.domainName}/${widget.data.data!.worker!.account!.imagePath}",
        );
      });
    }

    experiencesData = {};

    if (experiencesData.isEmpty && widget.data.data!.worker!.experiences != null) {
      for(int i = 0; i < widget.data.data!.worker!.experiences!.length; i++) {
        var current = widget.data.data!.worker!.experiences![i];
        setState(() {
          experiencesData[current.id.toString()] = {
            'title': current.job!.title,
            'time': current.time,
            'enterprise': current.enterprise
          };
        });
      }
    }

    if (experiencesList.isEmpty) {
      experiencesData.forEach((key, value) {
        setState(() {
          experiencesList.add(
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.black12, width: 2),
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              margin: const EdgeInsets.only(right: 10, bottom: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value["title"] + " " + "" + value["time"],
                    style: const TextStyle(
                        color: Colors.black38,
                        fontSize: 12
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          );
        });
      });
    }

    return  SingleChildScrollView(
      child: Stack(
        children: [
          Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, icon: const Icon(Icons.close)
              )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      const ProfilePictureShimmer(rounded: true,),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: userImg,
                                fit: BoxFit.cover
                            ),
                            borderRadius: BorderRadius.circular(5)
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Center(
                  child: Text("${widget.data.data!.worker!.firstname} ${widget.data.data!.worker!.lastname}", style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor
                  ),),
                ),
                const SizedBox(height: 7),
                const Divider(),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Flexible(child: Text("complétés", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10
                        ),)),
                        const SizedBox(height: 10),
                        Text(widget.data.data!.worker!.completedShiftsCount != null ?
                        widget.data.data!.worker!.completedShiftsCount.toString() : "0", style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10
                        ),),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Flexible(child: Text("Non complétés", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10
                        ),)),
                        const SizedBox(height: 10),
                        Text(widget.data.data!.worker!.canceledShiftsCount != null ?
                        widget.data.data!.worker!.canceledShiftsCount.toString() : "0", style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10
                        ),),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Flexible(child: Text("Absences", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10
                        ),)),
                        const SizedBox(height: 10),
                        Text(widget.data.data!.worker!.notWorkedShiftsCount != null ?
                        widget.data.data!.worker!.notWorkedShiftsCount.toString() : "0", style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10
                        ),),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(),
                if (widget.consecutive == true)
                  const SizedBox(height: 10,),
                if (widget.consecutive == true && widget.data.dateString != null)
                  Text(widget.data.dateString!),
                if (widget.consecutive == true)
                  const SizedBox(height: 10),
                if (widget.consecutive == true)
                  const Divider(),
                const SizedBox(height: 5,),
                const Flexible(child: Center(
                  child: Text("Expériences de travail", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13
                  ), textAlign: TextAlign.center,),
                )),
                const SizedBox(height: 15),
                if (widget.data.data!.worker!.experiences == null)
                  const NoDataCard(message: "Aucune")
                else
                  Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runAlignment: WrapAlignment.start,
                      children: experiencesList
                  ),
                const SizedBox(height: 20,),
                Center(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: [
                      RoundedButton(
                        onPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: ConfirmPopUp(
                                  message: "Êtes-vous sûr de vouloir approuver ${widget.data.data!.worker!.firstname} ${widget.data.data!.worker!.lastname} au shift?",
                                  onConfirm: () {
                                    applyViewModel.approveApplyApi(context: context, applyId: widget.data.data!.id!.toInt());
                                  },
                                ),
                              );
                            },
                          );
                        },
                        title: "Attribuer",
                        loading: false,
                        // loading: contractViewModel.loading,
                      ),
                      // RoundedButton(
                      //   onPress: () {
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         return Dialog(
                      //           shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(10)
                      //           ),
                      //           child: ConfirmPopUp(
                      //             message: "Êtes-vous sûr de vouloir réjéter la candidature de ${widget.data.data!.worker!.firstname} ${widget.data.data!.worker!.lastname} au shift?",
                      //             onConfirm: () {
                      //               applyViewModel.cancelApplyApi(context: context, applyId: widget.data.data!.id!.toInt(), account: account!);
                      //             },
                      //           ),
                      //         );
                      //       },
                      //     );
                      //   },
                      //   title: "Réjéter",
                      //   color: Colors.red,
                      //   loading: false,
                      //   // loading: contractViewModel.loading,
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}