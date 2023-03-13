import 'package:cheesus/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingRoute extends StatefulWidget {
  const LoadingRoute({Key? key}) : super(key: key);

  @override
  State<LoadingRoute> createState() => _LoadingRouteState();
}

class _LoadingRouteState extends State<LoadingRoute> {
  late Future<List<List<Map<String,dynamic>>>> _firebaseData;

  _LoadingRouteState(){
    _firebaseData = FirebaseFirestore.instance.collection("lena").where("date-published", isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))).get().then(
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
        data.add(docs);
        return FirebaseFirestore.instance.collection("users").where("username", isEqualTo: "lena").get().then((value) {
          data.add([value.docs.elementAt(0).data()]);
          // TODO set user and resp Firebase

          Navigator.pushReplacement(
            context,
              MaterialPageRoute(builder: (context) => const MyHomePage(firebaseData: _firebaseData))
          );
          return data;
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
