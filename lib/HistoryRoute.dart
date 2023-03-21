import 'dart:async';

import 'package:cheesus/FillerAvatar.dart';
import 'package:cheesus/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import "package:collection/collection.dart";

import 'CHIconButton.dart';

class HistoryRoute extends StatefulWidget {
  final Map<String, String> user;

  const HistoryRoute({Key? key, required this.user}) : super(key: key);

  @override
  State<HistoryRoute> createState() => _HistoryRouteState();
}

class _HistoryRouteState extends State<HistoryRoute> {
  late Future<List<List<Map<String, dynamic>>>> initialData;

  Map<T, List<S>> groupBy<S, T>(Iterable<S> values, T Function(S) key) {
    var map = <T, List<S>>{};
    for (var element in values) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }

  @override
  void initState() {
    super.initState();
    initialData = FirebaseFirestore.instance.collection(widget.user["username"] ?? "").where("type", isEqualTo: "RM").orderBy("date-published", descending: true).limit(10).get().then((data) {
      List<List<Map<String, dynamic>>> res = [];
      Map<int, List<QueryDocumentSnapshot<Map<String, dynamic>>>> groupedByMonths = groupBy(data.docs, (doc) {
        print( doc.data()["date-published"]);
        return doc.data()["date-published"].toDate().month as int;
      });
      print(groupedByMonths);
      for(int key in groupedByMonths.keys){
        res.add(groupedByMonths[key]?.map((e) => e.data()).toList() ?? []);
      }
      print(res);
      return res;
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
                const Text("Cheese History", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                const FillerAvatar()
              ],
            ),
            Expanded(
              child: FutureBuilder(
                  future: initialData,
                  builder: (BuildContext context, AsyncSnapshot<List<List<Map<String, dynamic>>>> snapshot){
                    if(snapshot.hasData){
                      List<List<Map<String, dynamic>>> data = snapshot.data ?? [];
                      return ListView.builder(
                        padding: EdgeInsets.all(40),
                        itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            List<Map<String, dynamic>> cheeseOfTheMonth = data.elementAt(index);
                            List<Container> msgContainer = cheeseOfTheMonth.map((doc) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(color: Colors.black, width: 2)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(doc["msg"], textAlign: TextAlign.center,),
                                ),
                              );
                            }).toList();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(cheeseOfTheMonth.elementAt(0)["date-published"].toDate().month.toString(), textAlign: TextAlign.center),
                                ...msgContainer
                              ],
                            );
                          }
                      );
                    }
                    return const Text("loading...");
                  }
              ),
            )
          ],
        )
    );
  }

  Future<List<List<Map<String, dynamic>>>> initialLoad() {
    return FirebaseFirestore.instance.collection(widget.user["username"] ?? "").orderBy("date-published", descending: true).limit(10).get().then((data) {
      List<List<Map<String, dynamic>>> res = [];
      Map<int, List<QueryDocumentSnapshot<Map<String, dynamic>>>> groupedByMonths = groupBy(data.docs, (doc) => doc.data()["date-published"].month as int);
      for(int key in groupedByMonths.keys){
        res.add(groupedByMonths[key]?.map((e) => e.data()).toList() ?? []);
      }
      print(res);
      return res;
    });
  }

  /*
  Future<List<List<Map<String, dynamic>>>> initialLoad() async {
    List<List<Map<String, dynamic>>> res = [];
    int month = (DateTime.now().month - 3) % 12;
    List<int> checkedMonths = [month, (month+1)%12, (month+2)%12];
    DateTime now = DateTime.now();

    // initial request
    await FirebaseFirestore.instance.collection(widget.user["username"] ?? "").where("type", isEqualTo: "RM").where("date-published", isGreaterThanOrEqualTo: DateTime(now.year, month)).get().then((value) {
        Map<int, List<QueryDocumentSnapshot<Map<String, dynamic>>>> groupedByMonth = groupBy(value.docs, (doc) => (doc.data()["date-published"] as DateTime).month);
        for(int key in groupedByMonth.keys){
          res.add(groupedByMonth[key]?.map((e) => e.data()).toList() ?? []);
        }
    });



    DateTime lastChecked = DateTime(now.year, month);

    while(res.length < 3){
      month = (month - 1) % 12;
      checkedMonths.add(month);
      if(checkedMonths.length == 12){
        break;
      }

      await FirebaseFirestore.instance.collection(widget.user["username"] ?? "")
          .where("type", isEqualTo: "RM")
          .where("date-published", isLessThan: lastChecked)
          .where("date-published", isGreaterThanOrEqualTo: DateTime(now.year, month))
          .get().then((value) {

          }
      );
      lastChecked = DateTime(now.year, month);
    }

    return res;
  }*/
}
