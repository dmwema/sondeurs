import 'package:flutter/material.dart';
import 'package:sondeurs/resource/components/buttons/rounded_button.dart';

class ErrorPopUp extends StatefulWidget {
  final VoidCallback onConfirm;
  final String message;
  final String btnText;

  const ErrorPopUp({Key? key, required this.onConfirm, required this.btnText, required this.message}) : super(key: key);

  @override
  State<ErrorPopUp> createState() => _ErrorPopUpState();
}

class _ErrorPopUpState extends State<ErrorPopUp> {
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
                      color: Colors.red,
                    )
                ),
                child: const Center(
                  child: Icon(
                    Icons.close_outlined,
                    color: Colors.red,
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
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedButton(
                      title: widget.btnText,
                      loading: false,
                      onPress: () {
                        widget.onConfirm();
                      }
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}