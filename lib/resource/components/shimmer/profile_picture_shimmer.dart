import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sondeurs/resource/config/colors.dart';

class ListTileShimmer extends StatelessWidget {
  final bool rounded;
  double titleWidth;

  ListTileShimmer({super.key, this.rounded = false, required this.titleWidth});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(.02),
      highlightColor: Colors.white.withOpacity(.05),
      child: ListTile(
        onTap: () {},
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.black,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 14,
              width: titleWidth,
              color: Colors.black,
              child: const Row(
                children: [],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 10,
              color: Colors.black,
              child: const Row(
                children: [],
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
          color: Colors.black,
          size: 15,
        ),
        shape: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(.02),
          ),
        ),
        iconColor: Colors.black,
      ),
    );
  }
}