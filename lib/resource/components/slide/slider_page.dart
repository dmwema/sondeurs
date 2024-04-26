import 'package:flutter/material.dart';
import 'package:quickdep_mob/resource/config/colors.dart';

class SliderPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  Color textColor;

  SliderPage({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    this.textColor  = Colors.black
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: textColor == Colors.white ? AppColors.primaryColor: null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, width: width * 0.6,),
          const SizedBox(height: 60,),
          Text(title, style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor
          ),),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(description, style: TextStyle(
                height: 1.5,
                fontSize: 15, fontWeight: FontWeight.normal, letterSpacing: 0.7,
                color: textColor.withOpacity(0.7)
            ), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 60,)
        ],
      ),
    );
  }
}