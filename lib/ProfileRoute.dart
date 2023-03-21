import 'package:cheesus/LoginRoute.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CHIconButton.dart';
import 'FillerAvatar.dart';

class ProfileRoute extends StatelessWidget {
  final Map<String, dynamic> user;

  late final Future<List<int>> cheeseData;

  ProfileRoute({super.key, required this.user}){
    cheeseData = FirebaseFirestore.instance.collection("cheese").where("receiver", isEqualTo: user["username"]).get().then((value) {
      List<int> res = [];
      res.add(value.docs.length);

      return FirebaseFirestore.instance.collection("cheese").where("creator", isEqualTo: user["username"]).get().then((value) {
        res.add(value.docs.length);
        return res;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ListView(
                  children: [
                    Center(
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 3)
                          ),
                          child: const CircleAvatar(
                            radius: 69,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 59,
                              backgroundImage: AssetImage("images/cheesus.png"),
                            ),
                          ),
                        )
                    ),
                    const SizedBox(height: 10,),
                    Center(child: Text("@${user["username"] ?? ""}", style: TextStyle(fontWeight: FontWeight.bold))),
                    Center(child: Text((user["email"] ?? "loading"))),
                    const SizedBox(height: 20,),
                    const Text("Dein cheesy Partner:", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                          border: Border.all(color: Colors.black, width: 3)
                      ),
                      child: Center(child: Text("@"+ (user["partner"] ?? ""), style: TextStyle(fontWeight: FontWeight.bold))),
                    ),
                    SizedBox(height: 15,),
                    Divider(height: 5, color: Colors.black, thickness: 2),
                    SizedBox(height: 10),
                    FutureBuilder(
                        future: cheeseData,
                        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot){
                          if(snapshot.hasData){
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Gesendeter Cheese:", style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                                      border: Border.all(color: Colors.black, width: 3)
                                  ),
                                  child: Center(child: Text((snapshot.data?.elementAt(1) ?? 0).toString(), style: TextStyle(fontWeight: FontWeight.bold))),
                                ),
                                SizedBox(height: 10,),
                                const Text("Empfangener Cheese:", style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                                      border: Border.all(color: Colors.black, width: 3)
                                  ),
                                  child: Center(child: Text((snapshot.data?.elementAt(0) ?? 0).toString(), style: TextStyle(fontWeight: FontWeight.bold))),
                                ),
                              ],
                            );
                          }
                          return SizedBox();
                        }
                    ),
                    SizedBox(height: 15,),
                    Divider(height: 5, color: Colors.black, thickness: 2),
                    SizedBox(height: 10),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            border: Border.all(color: Colors.black, width: 3)
                        ),
                        child: TextButton(onPressed: (){
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Warte kurz!'),
                                content: const Text('Möchtest du dich wirklich ausloggen oder war das doch nur ein Vertipper?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'OK'),
                                    child: const Text('Ups, Vertippt'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      FirebaseAuth.instance.signOut().then((_) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => LoginRoute())
                                        );
                                      });
                                    },
                                    child: const Text('Ausloggen'),
                                  ),
                                ],
                              ));
                        },child: Text("Log out", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))
                    )
                  ]
                ),
              ),
            )
          ],
        )
    );
  }
}
