import 'package:flutter/material.dart';

class TownCard extends StatefulWidget {
  final String title;
  void Function()? onTap;
  bool selected;

  TownCard({Key? key, required this.title, this.selected = false, this.onTap}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TownCardState();
}

class _TownCardState extends State<TownCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: widget.selected ? Colors.blueAccent.withOpacity(.5): Colors.black.withOpacity(.1)
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        margin: const EdgeInsets.all(10),
        child:  Text(widget.title),
      ),
    );
  }
}

