import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomTimeFiel extends StatefulWidget {
  TextEditingController? controller;
  final String title;
  void Function()? onTap;

  CustomTimeFiel({Key? key, this.controller, required this.title, this.onTap}) : super(key: key);

  @override
  State<CustomTimeFiel> createState() => _CustomTimeFielState();
}

class _CustomTimeFielState extends State <CustomTimeFiel> {
  @override
  Widget build(BuildContext context) {
    return
      TextField(
        controller: widget.controller, //editing controller of this TextField
        decoration: InputDecoration(
          labelText: widget.title,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(35)),
          ),
          contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
        ),
        readOnly: true,  //set it true, so that user will not able to edit text
        onTap: widget.onTap,
      );
  }

}