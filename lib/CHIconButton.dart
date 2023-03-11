import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CHIconButton extends StatelessWidget {
  final IconData icon;

  final VoidCallback onPressed;

  const CHIconButton({Key? key, required this.icon, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(onPressed: this.onPressed, icon: Icon(this.icon), padding: EdgeInsets.zero),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.all(Radius.circular(100)),
        color: Colors.white,
      ),
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.zero,
    );
  }
}
