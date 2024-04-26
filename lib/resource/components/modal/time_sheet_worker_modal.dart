import 'package:flutter/material.dart';
import 'package:quickdep_mob/model/user/worker_model.dart';
import 'package:quickdep_mob/resource/components/shimmer/profile_picture_shimmer.dart';
import 'package:quickdep_mob/resource/config/app_url.dart';
import 'package:quickdep_mob/resource/config/colors.dart';
import 'package:quickdep_mob/utils/utils.dart';


class TimeSheetWorkerDetailModal extends StatefulWidget {

  final WorkerModel worker;
  final bool showStats;

  const TimeSheetWorkerDetailModal({
    Key? key,
    required this.worker,
    this.showStats = true
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TimeSheetWorkerDetailModalState();
}

class _TimeSheetWorkerDetailModalState extends State<TimeSheetWorkerDetailModal> {
  Map<String, Map> experiencesData = {};
  List<Widget> experiencesList = [];
  ImageProvider userImg = const AssetImage('assets/default-worker.png');

  @override
  Widget build(BuildContext context) {

    if (!Utils.empty(widget.worker.account!.imagePath)) {
      setState(() {
        userImg = NetworkImage(
          "${AppUrl.domainName}/${widget.worker.account!.imagePath}",
        );
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
                  child: Text("${widget.worker.firstname} ${widget.worker.lastname}", style: TextStyle(
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
                        Text("${widget.worker.account!.email}", style: const TextStyle(
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
                        Text("${widget.worker.account!.phoneNumber}", style: const TextStyle(
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
                        Icon(Icons.pin_drop_outlined, color: AppColors.primaryColor, size: 15,),
                        const SizedBox(width: 7,),
                        Text("${widget.worker.address}", style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black45
                        ),),
                      ],
                    )
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