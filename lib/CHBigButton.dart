import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChBigButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const ChBigButton({Key? key, required this.onPressed, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          overlayColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(255, 201, 3, 0.5)),
          foregroundColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(255, 201, 3, 1.0)),
          splashFactory: InkRipple.splashFactory
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              text,
              style: const TextStyle(
                  fontFamily: "Inter",
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            )
        ),
      ),
    );;
  }
}
