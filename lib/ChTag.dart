import 'package:flutter/material.dart';

class ChTag extends StatefulWidget {
  final String title;
  final void Function(bool) toggle;

  const ChTag({Key? key, required this.title, required this.toggle}) : super(key: key);

  @override
  State<ChTag> createState() => _ChTagState();
}

class _ChTagState extends State<ChTag> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          _active = !_active;
        });
        widget.toggle(_active);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        decoration: BoxDecoration(
          color: _active ? Colors.black : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(100)),
          border: Border.all(color: Colors.black, width: 2)
        ),
        child: Text(
            widget.title,
          style: TextStyle(color: _active ? Colors.white : Colors.black, fontWeight: FontWeight.bold)
        )
      ),
    );
  }
}
