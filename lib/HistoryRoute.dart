import 'package:cheesus/FillerAvatar.dart';
import 'package:cheesus/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CHIconButton.dart';

class HistoryRoute extends StatefulWidget {
  const HistoryRoute({Key? key}) : super(key: key);

  @override
  State<HistoryRoute> createState() => _HistoryRouteState();
}

class _HistoryRouteState extends State<HistoryRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        backgroundColor: Color.fromRGBO(255, 201, 3, 1.0),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CHIconButton(icon: Icons.arrow_back, onPressed: (){
                  Navigator.pop(context);
                },),
                const Text("Cheese History", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                const FillerAvatar()
              ],
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 40),
                children: [
                  Text("test 1"),
                  Text("test 2")
                ],
              ),
            )
          ],
        )
    );
  }
}
