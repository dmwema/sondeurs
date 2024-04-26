import 'package:flutter/material.dart';
import 'package:sondeurs/resource/components/buttons/rounded_button.dart';
import 'package:sondeurs/resource/config/colors.dart';

class ConfirmPopUp extends StatefulWidget {
  final VoidCallback onConfirm;
  final String message;
  final String? text;

  const ConfirmPopUp({super.key, required this.onConfirm, this.text, required this.message});

  @override
  State<ConfirmPopUp> createState() => _ConfirmPopUpState();
}

class _ConfirmPopUpState extends State<ConfirmPopUp> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Positioned(
            right: 0,
            top: 0,
            child: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: const Icon(Icons.close)
            )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      width: 5,
                      color: AppColors.primaryColor,
                    )
                ),
                child: Center(
                  child: Icon(
                    Icons.question_mark,
                    color: AppColors.primaryColor,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Column(
                children: [
                  Text(widget.message, style: const TextStyle(
                      fontWeight: FontWeight.bold
                  ), textAlign: TextAlign.center,),
                  if (widget.text != null)
                  const SizedBox(height: 5,),
                  if (widget.text != null)
                  Text(widget.text.toString(), style: const TextStyle(
                    color: Colors.black45
                  ), textAlign: TextAlign.center,),
                ],
              ),
              const SizedBox(height: 20,),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RoundedButton(
                      title: "Confirmer",
                      small: true,
                      loading: loading,
                      onPress: () {
                        if (!loading) {
                          setState(() {
                            loading = true;
                          });
                          widget.onConfirm();
                        }
                      }
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}