import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sondeurs/resource/config/colors.dart';

class RoundedButton extends StatefulWidget {
  final String title;
  Color? color;
  bool small;
  final Color textColor;
  final VoidCallback onPress;
  bool loading = false;

    RoundedButton({
      super.key,
      required this.title,
      this.color,
      required this.loading,
      this.textColor = Colors.white,
      required this.onPress,
      this.small = false
    });

  @override
  State<StatefulWidget> createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    widget.color ??= AppColors.primaryColor;
    final String title = widget.title;
    final Color color = widget.color!;
    final Color textColor = widget.textColor;
    return Center(
      child: InkWell(
        onTap: () {
          if (!widget.loading) {
            widget.onPress();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(microseconds: 1),
          curve: Curves.easeInOut,
          height: 50,
          width: widget.small == true ? null : MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: widget.loading ? Colors.black26 : color,
            borderRadius: BorderRadius.circular(5)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.loading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CupertinoActivityIndicator(color: Colors.white, radius: 10,),
              ),
              if (widget.loading)
              const SizedBox(width: 10,),
              Text(title, style: TextStyle(color: textColor, ),),
            ],
          )
        ),
      ),
    );
  }
}