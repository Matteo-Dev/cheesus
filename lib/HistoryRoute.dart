import 'dart:async';

import 'package:cheesus/FillerAvatar.dart';
import 'package:cheesus/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import "package:collection/collection.dart";

import 'CHIconButton.dart';
import 'ChTag.dart';

class HistoryRoute extends StatefulWidget {
  final Map<String, String> user;

  const HistoryRoute({Key? key, required this.user}) : super(key: key);

  @override
  State<HistoryRoute> createState() => _HistoryRouteState();
}

class _HistoryRouteState extends State<HistoryRoute> {
  Map<T, List<S>> groupBy<S, T>(Iterable<S> values, T Function(S) key) {
    var map = <T, List<S>>{};
    for (var element in values) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }

  List<String> months = ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"];

  List<List<Map<String, dynamic>>> currentData = [];
  List<List<Map<String, dynamic>>> _filteredData = [];

  bool initialFetchCompleted = false;

  List<bool> activeFilters = [false, false, false, false];

  bool _isLoading = false;
  bool _hasMore = true;

  DateTime latestCheck = DateTime.now();

  void _loadMore(){
    _isLoading = true;
    FirebaseFirestore.instance.collection("cheese").where("receiver", isEqualTo: widget.user["username"]).orderBy("date-published", descending: true).where("date-published", isLessThan: latestCheck).limit(10).get().then((data){
      List<List<Map<String, dynamic>>> res = [];
      Map<int, List<QueryDocumentSnapshot<Map<String, dynamic>>>> groupedByMonths = groupBy(data.docs, (doc) {
        return doc.data()["date-published"].toDate().month as int;
      });
      for(int key in groupedByMonths.keys){
        res.add(groupedByMonths[key]?.map((e) => e.data()).toList() ?? []);
      }
      if(res.isNotEmpty){
        int lastCheckedMonthPrev = (currentData.last.last["date-published"] as Timestamp).toDate().month;
        int firstCheckedMonthNow = (res[0][0]["date-published"] as Timestamp).toDate().month;
        print(res);
        setState(() {
          _isLoading = false;
          if(lastCheckedMonthPrev == firstCheckedMonthNow){
            currentData.last.addAll(res[0]);
            currentData.addAll(res.getRange(1, res.length));
          } else {
            currentData.addAll(res);
          }
          filter();
        });
        latestCheck = data.docs.last.data()["date-published"].toDate();
      } else {
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("cheese").where("receiver", isEqualTo: widget.user["username"]).orderBy("date-published", descending: true).limit(10).get().then((data) {
      List<List<Map<String, dynamic>>> res = [];
      Map<int, List<QueryDocumentSnapshot<Map<String, dynamic>>>> groupedByMonths = groupBy(data.docs, (doc) {
        return doc.data()["date-published"].toDate().month as int;
      });
      for(int key in groupedByMonths.keys){
        res.add(groupedByMonths[key]?.map((e) => e.data()).toList() ?? []);
      }
      latestCheck = data.docs.last.data()["date-published"].toDate();
      currentData = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget historyView = ListView.builder(
        padding: EdgeInsets.only(left: 40, right: 40, bottom: 40),
        itemCount: _hasMore ? _filteredData.length + 1 : _filteredData.length,
        itemBuilder: (BuildContext context, int index) {
          if(index >= _filteredData.length){
            if(!_isLoading){
              _loadMore();
            }
            return Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                height: 24,
                width: 24,
              ),
            );
          }
          List<Map<String, dynamic>> cheeseOfTheMonth = _filteredData.elementAt(index);
          List<Widget> msgContainer = cheeseOfTheMonth.map((doc) {
            return Stack(
              alignment: Alignment.bottomRight,
              fit: StackFit.passthrough,
              children: [
                Container(
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
                ),
                doc["favourite"] ? Container(child: Icon(Icons.favorite, size: 15), alignment: Alignment.bottomRight, padding: EdgeInsets.all(10),) : SizedBox(),
                Container(child: Text((doc["cheesiness"]+1).toString() + "C"), alignment: Alignment.bottomLeft, padding: EdgeInsets.all(10),)
              ],
            );
          }).toList();
          int month = cheeseOfTheMonth.elementAt(0)["date-published"].toDate().month;
          int year = cheeseOfTheMonth.elementAt(0)["date-published"].toDate().year;
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(months.elementAt(month-1) + " " + year.toString(), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ...msgContainer
              ],
            ),
          );
        }
    );

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
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
              child: Row(
                children: [
                  ChTag(title: "Favourites", toggle: (active){
                    if(active){
                      activeFilters[0] = true;
                    } else {
                      activeFilters[0] = false;
                    }
                    filter();
                  },),
                  SizedBox(width: 10,),
                  ChTag(title: "C", toggle: (active){
                    if(active){
                      activeFilters[1] = true;
                    } else {
                      activeFilters[1] = false;
                    }
                    filter();
                  },),
                  SizedBox(width: 10,),
                  ChTag(title: "CC", toggle: (active){
                    if(active){
                      activeFilters[2] = true;
                    } else {
                      activeFilters[2] = false;
                    }
                    filter();
                  },),
                  SizedBox(width: 10,),
                  ChTag(title: "CCC", toggle: (active){
                    if(active){
                      activeFilters[3] = true;
                    } else {
                      activeFilters[3] = false;
                    }
                    filter();
                  },),
                ],
              ),
            ),
            Expanded(
              child: historyView,
            )
          ],
        )
    );
  }

  void filter(){
    List<List<Map<String, dynamic>>> filteredDataNew = [];
    List<Map<String, dynamic>> filteredMonthDocs;
    for(List<Map<String, dynamic>> monthDocs in currentData){
      filteredMonthDocs = [];
      if(activeFilters.contains(true)){
        for(Map<String, dynamic> doc in monthDocs){
          if(activeFilters[0] && doc["favourite"]){
            filteredMonthDocs.add(doc);
          } else if(activeFilters[1] && doc["cheesiness"] == 0){
            filteredMonthDocs.add(doc);
          } else if(activeFilters[2] && doc["cheesiness"] == 1){
            filteredMonthDocs.add(doc);
          } else if(activeFilters[3] && doc["cheesiness"] == 2){
            filteredMonthDocs.add(doc);
          }
        }
      } else {
        filteredMonthDocs = monthDocs;
      }
      if(filteredMonthDocs.isNotEmpty){
        filteredDataNew.add(filteredMonthDocs);
      }
    }
    setState(() {
      _filteredData = filteredDataNew;
    });
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
