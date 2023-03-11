import 'package:flutter/material.dart';

class CHArrowButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool pointsToRight;

  const CHArrowButton({Key? key, required this.onPressed, required this.pointsToRight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(15),
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            (pointsToRight) ? "--->" : "<---",
            style: const TextStyle(
                fontFamily: "Inter",
                color: Colors.black,
                fontWeight: FontWeight.bold),
          )
        ),
      ),
    );
  }
}
