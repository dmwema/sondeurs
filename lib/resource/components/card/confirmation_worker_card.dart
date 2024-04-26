import 'package:flutter/material.dart';
import 'package:quickdep_mob/model/confirmation/shift_confirmation_model.dart';
import 'package:quickdep_mob/resource/components/shimmer/profile_picture_shimmer.dart';
import 'package:quickdep_mob/resource/config/app_url.dart';


class ConfirmationWorkerCard extends StatefulWidget {
  final ShiftConfirmationData data;
  final bool consecutive;
  List? dates;
  final void Function()? onTap;

  ConfirmationWorkerCard({
    Key? key,
    required this.data,
    this.dates,
    this.consecutive = false,
    this.onTap
  }) : super(key: key);

  @override
  State<ConfirmationWorkerCard> createState() => _ConfirmationWorkerCardState();
}

class _ConfirmationWorkerCardState extends State<ConfirmationWorkerCard> {
  ImageProvider userImg = const AssetImage('assets/default-worker.png');

  @override
  void initState() {
    super.initState();
    if (widget.data.worker!.account != null) {
      userImg = NetworkImage("${AppUrl.domainName}/${widget.data.worker!.account!.imagePath}");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> datesListWidget = [];
    for (var element in widget.dates!) {
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
              children: [
                Text("${widget.data.worker!.lastname} ${widget.data.worker!.firstname}", style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11
                ),),
                // if (widget.consecutive)
                //   const SizedBox(height: 5,),
                // if (widget.consecutive)
                //   Wrap(
                //     spacing: 5,appro
                //     runSpacing: 5,
                //     children: datesListWidget,
                //   )
              ],
            ),
          ],
        ),
      ),
    );
  }
}