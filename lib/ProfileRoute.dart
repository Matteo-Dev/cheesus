import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CHIconButton.dart';
import 'FillerAvatar.dart';

class ProfileRoute extends StatelessWidget {
  final Map<String, String> user;

  const ProfileRoute({Key? key, required this.user}) : super(key: key);

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
                const Text("Cheesy Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                const FillerAvatar()
              ],
            ),
            Center(
              child: CircleAvatar(
                radius: 69,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 59,
                  backgroundImage: AssetImage("images/cheesus.png"),
                ),
              )
            ),
            Text("@"+(user["username"] ?? "")),
            Text((user["email"] ?? "loading"))
          ],
        )
    );
  }
}
