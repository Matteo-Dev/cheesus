import 'package:cheesus/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingRoute extends StatefulWidget {
  final User? user;

  const LoadingRoute({Key? key, required this.user}) : super(key: key);

  @override
  State<LoadingRoute> createState() => _LoadingRouteState();
}

class _LoadingRouteState extends State<LoadingRoute> {
  late Future<List<List<Map<String,dynamic>>>> _firebaseData;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _firebaseData = FirebaseFirestore.instance.collection("cheese").where("receiver", isEqualTo: widget.user?.displayName).where("date-published", isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day)).get().then(
          (event) {
        List<List<Map<String, dynamic>>> data = [];
        List<Map<String, dynamic>> docs = [];
        for(var doc in event.docs){
          Map<String, dynamic> extDoc = {
            ...doc.data(),
            ...{"_id": doc.id}
          };
          docs.add(extDoc);
        }
        // TODO docs.notEmpty check
        data.add(docs.reversed.toList());

        return FirebaseFirestore.instance.collection("users").where("username", isEqualTo: widget.user?.displayName).get().then((value) {
          data.add([value.docs.elementAt(0).data()]);
          // TODO set user and resp Firebase

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if(context.mounted){
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage(firebaseData: data))
              );
            }
          });
          WidgetsBinding.instance.ensureVisualUpdate();
          return data;
        });

      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => LoadingRoute(user: widget.user))
      );
    });

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(toolbarHeight: 0),
        backgroundColor: const Color.fromRGBO(255, 201, 3, 1.0),
        body: Padding(
          padding: const EdgeInsets.all(80.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: const [
                    CircleAvatar(
                      radius: 59,
                      backgroundImage: AssetImage("images/cheesus.png"),
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "hold on, cheesus is trying its/his best to load your cheese",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                )
              ],
            )
          ),
        )
    );
  }
}
