import 'package:cheesus/CHBigButton.dart';
import 'package:cheesus/FillerAvatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CHIconButton.dart';
import 'main.dart';

class ChatRoute extends StatefulWidget {
  const ChatRoute({Key? key}) : super(key: key);

  @override
  State<ChatRoute> createState() => _ChatRouteState();
}

class _ChatRouteState extends State<ChatRoute> {
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                  );
                },),
                const Text("Cheese Message", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                const FillerAvatar()
              ],
            ),
            const Center(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(40, 40, 40, 10),
                  child: TextField(
                    expands: false,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 3,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(35)),
                        borderSide: BorderSide(color: Colors.black, width: 3)
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 30
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(35)),
                          borderSide: BorderSide(color: Colors.black, width: 3)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(35)),
                          borderSide: BorderSide(color: Colors.black, width: 3)
                      ),
                      hintText: "The finest cheese comes here"
                    ),
                  ),
                )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ChBigButton(onPressed: (){}, text: "Save"),
                  const SizedBox(width: 10,),
                  ChBigButton(onPressed: (){}, text: "Send")
                ],
              ),
            )
          ],
        )
    );
  }
}
