import 'package:flutter/material.dart';
import 'package:quickdep_mob/model/account/account_model.dart';
import 'package:quickdep_mob/model/confirmation/shift_confirmation_model.dart';
import 'package:quickdep_mob/resource/components/buttons/rounded_button.dart';
import 'package:quickdep_mob/resource/components/popup/confirm_popup.dart';
import 'package:quickdep_mob/resource/components/shimmer/profile_picture_shimmer.dart';
import 'package:quickdep_mob/resource/config/app_url.dart';
import 'package:quickdep_mob/resource/config/colors.dart';
import 'package:quickdep_mob/utils/utils.dart';
import 'package:quickdep_mob/view_model/account/account_view_model.dart';
import 'package:quickdep_mob/view_model/confirmation/confirmation_view_model.dart';
import 'package:quickdep_mob/view_model/shift/shift_view_model.dart';


class ConfirmationWorkerDetailModal extends StatefulWidget {

  final ShiftConfirmationModel data;
  final bool consecutive;
  final bool showActions;
  final bool showContacts;
  final int confirmationId;
  final void Function()? onApprove;
  final void Function()? onCancel;

  const ConfirmationWorkerDetailModal({
    Key? key,
    required this.data,
    required this.confirmationId,
    this.consecutive = false,
    this.showActions = true,
    this.showContacts = false,
    this.onApprove,
    this.onCancel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConfirmationWorkerDetailModalState();
}

class _ConfirmationWorkerDetailModalState extends State<ConfirmationWorkerDetailModal> {
  ImageProvider userImg = const AssetImage('assets/default-worker.png');
  ConfirmationViewModel confirmationViewModel = ConfirmationViewModel();
  ShiftViewModel shiftViewModel = ShiftViewModel();
  AccountModel? account;

  @override
  void initState() {
    super.initState();
    AccountViewModel().getAccount().then((value) {
      account = value;
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

    List<Widget> datesListWidget = [];
    for (var element in widget.data.dates!) {
      datesListWidget.add(
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Colors.grey.withOpacity(.2),
            ),
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
            child: Text(element.toString(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 8
              ),
            ),
          )
      );
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
                const SizedBox(height: 10,),
                Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mail_outline, color: AppColors.primaryColor, size: 15,),
                        const SizedBox(width: 10,),
                        Text("${widget.data.data!.worker!.account!.email}", style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black45
                        ),),
                      ],
                    )
                ),
                const SizedBox(height: 5,),
                Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone_outlined, color: AppColors.primaryColor, size: 15,),
                        const SizedBox(width: 7,),
                        Text("${widget.data.data!.worker!.account!.phoneNumber}", style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black45
                        ),),
                      ],
                    )
                ),
                const SizedBox(height: 20,),
                if (widget.data.started != true)
                Center(
                  child: RoundedButton(
                      title: "Rétirer",
                      color: Colors.red,
                      loading: false,
                      onPress: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            if (account != null) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: ConfirmPopUp(
                                  message: "Êtes-vous sûr de vouloir rétirer ce shift au travailleur ?",
                                  onConfirm: () {
                                    confirmationViewModel.cancelConfirmationApi(context: context, confirmationId: widget.data.data!.id!, account: account!);
                                  },
                                ),
                              );
                            }
                            return Dialog(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30),
                                  )
                              ),
                              child: Container(),
                            );
                          },
                        );
                      }
                  ),
                ),
                if (widget.data.started != true)
                // const SizedBox(height: 5),
                // const Divider(),
                // const SizedBox(height: 10,),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Column(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         const Flexible(child: Text("Complétés", style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             fontSize: 10
                //         ),)),
                //         const SizedBox(height: 10),
                //         Text(widget.data.data!.worker!.completedShiftsCount != null ?
                //         widget.data.data!.worker!.completedShiftsCount.toString() : "0", style: const TextStyle(
                //             fontWeight: FontWeight.bold,
                //             fontSize: 10
                //         ),),
                //       ],
                //     ),
                //     Column(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         const Flexible(child: Text("Non complétés", style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             fontSize: 10
                //         ),)),
                //         const SizedBox(height: 10),
                //         Text(widget.data.data!.worker!.canceledShiftsCount != null ?
                //         widget.data.data!.worker!.canceledShiftsCount.toString() : "0", style: const TextStyle(
                //             fontWeight: FontWeight.bold,
                //             fontSize: 10
                //         ),),
                //       ],
                //     ),
                //     Column(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         const Flexible(child: Text("Absences", style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             fontSize: 10
                //         ),)),
                //         const SizedBox(height: 10),
                //         Text(widget.data.data!.worker!.notWorkedShiftsCount != null ?
                //         widget.data.data!.worker!.notWorkedShiftsCount.toString() : "0", style: const TextStyle(
                //             fontWeight: FontWeight.bold,
                //             fontSize: 10
                //         ),),
                //       ],
                //     ),
                //   ],
                // ),
                // // if (widget.data.consecutive == true)
                // // const SizedBox(height: 10),
                // if (widget.data.consecutive == true)
                // const Divider(),
                if (widget.data.consecutive == true)
                const SizedBox(height: 10,),
                if (widget.data.consecutive == true)
                Center(
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: datesListWidget,
                  ),
                ),
                if (widget.data.consecutive == true)
                const SizedBox(height: 10),
                if (widget.data.consecutive == true)
                const Divider(),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}