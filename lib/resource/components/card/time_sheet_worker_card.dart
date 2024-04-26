import 'package:flutter/material.dart';
import 'package:quickdep_mob/model/confirmation/shift_confirmation_model.dart';
import 'package:quickdep_mob/model/user/worker_model.dart';
import 'package:quickdep_mob/resource/components/modal/time_sheet_worker_modal.dart';
import 'package:quickdep_mob/resource/components/shimmer/profile_picture_shimmer.dart';
import 'package:quickdep_mob/resource/config/app_url.dart';


class TimeSheetWorkerCard extends StatefulWidget {
  final WorkerModel worker;
  final bool showStats;

  const TimeSheetWorkerCard({
    Key? key,
    required this.worker,
    this.showStats = true,
  }) : super(key: key);

  @override
  State<TimeSheetWorkerCard> createState() => _TimeSheetWorkerCardState();
}

class _TimeSheetWorkerCardState extends State<TimeSheetWorkerCard> {
  ImageProvider userImg = const AssetImage('assets/default-worker.png');


  @override
  void initState() {
    super.initState();
    if (widget.worker.account != null) {
      userImg = NetworkImage("${AppUrl.domainName}/${widget.worker.account!.imagePath}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape:  RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              child: TimeSheetWorkerDetailModal(
                worker: widget.worker,
                showStats: widget.showStats,
              ),
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(.3), width: 1),
            borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          children: [
            Stack(
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
                      borderRadius: BorderRadius.circular(100)
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.worker!.lastname} ${widget.worker!.firstname}", style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11
                ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}