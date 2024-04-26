import 'package:flutter/material.dart';

class NoDataCard extends StatelessWidget {
  final String message;

  const NoDataCard({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Center(
            child:  Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/empty.png", width: 80,),
                const SizedBox(height: 15,),
                Text(message, style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(.4)
                ), textAlign: TextAlign.center),
              ],
            ),
          )
      ),
    );
  }
}