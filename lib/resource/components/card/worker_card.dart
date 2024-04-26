import 'package:flutter/material.dart';
import 'package:quickdep_mob/model/apply/apply_model.dart';
import 'package:quickdep_mob/resource/components/shimmer/profile_picture_shimmer.dart';
import 'package:quickdep_mob/resource/config/app_url.dart';
import 'package:quickdep_mob/resource/config/colors.dart';


class WorkerCard extends StatefulWidget {
  final ApplyData data;
  final bool consecutive;
  final void Function()? onTap;

  const WorkerCard({
    Key? key,
    required this.data,
    this.consecutive = false,
    this.onTap
  }) : super(key: key);

  @override
  State<WorkerCard> createState() => _WorkerCardState();
}

class _WorkerCardState extends State<WorkerCard> {
  ImageProvider userImg = const AssetImage('assets/default-worker.png');

  @override
  void initState() {
    super.initState();
    if (widget.data.data!.worker!.account != null) {
      userImg = NetworkImage("${AppUrl.domainName}/${widget.data.data!.worker!.account!.imagePath}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
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
              children:
              [
                if (widget.data.data != null)
                Text("${widget.data.data!.worker!.lastname} ${widget.data.data!.worker!.firstname}", style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11
                ),),
                if (widget.consecutive)
                  const SizedBox(height: 5,),
                if (widget.consecutive && widget.data.dateString != null)
                  Container(
                    padding: const EdgeInsets.only( top: 3, bottom: 2, left: 5, right: 5),
                    color: widget.data.dateColor == 'green' ? Colors.green 
                      : (widget.data.dateColor == 'blue' ? Colors.blueAccent 
                      : (widget.data.dateColor == 'orange' ? Colors.orange : Colors.grey)
                    ),
                    child: Text(widget.data.dateString!, style: const TextStyle(
                      fontSize: 9, fontWeight: FontWeight.w600, color: Colors.white
                    ),)
                  )
              ],
            ),
            Expanded(child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: const Text("Voir", style: TextStyle(color: Colors.white),),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}