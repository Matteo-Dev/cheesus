import 'package:flutter/material.dart';

class FillerAvatar extends StatelessWidget {
  const FillerAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const CircleAvatar(
        backgroundColor: Color.fromRGBO(255, 201, 3, 1.0),
        radius: 23,
      ),
    );
  }
}
