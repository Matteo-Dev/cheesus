import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CHIconButton extends StatelessWidget {
  final IconData icon;

  final void Function()? onPressed;

  final double margin;

  final bool primary;

  const CHIconButton({Key? key, required this.icon, required this.onPressed, this.margin = 20, this.primary = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(onPressed: this.onPressed, icon: Icon(this.icon, color: primary ? Colors.white : Colors.black), padding: EdgeInsets.zero),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.all(Radius.circular(100)),
        color: primary ? Colors.black : Colors.white,
      ),
      margin: EdgeInsets.all(margin),
      padding: EdgeInsets.zero,
    );
  }
}
