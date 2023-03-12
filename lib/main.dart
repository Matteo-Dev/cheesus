import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cheesus/CHArrowButton.dart';
import 'package:cheesus/CHCheeseSlider.dart';
import 'package:cheesus/CHFavoriteBtn.dart';
import 'package:cheesus/CHIconButton.dart';
import 'package:cheesus/ChatRoute.dart';
import 'package:cheesus/HistoryRoute.dart';
import 'package:cheesus/ProfileRoute.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: generateMaterialColor(const Color.fromRGBO(255, 201, 3, 1.0)),
          appBarTheme: const AppBarTheme(backgroundColor: Color.fromRGBO(255, 201, 3, 1.0), centerTitle: true),
        useMaterial3: true,
        fontFamily: "Karla"
      ),
      home: const MyHomePage(),
    );
  }
}

// # https://medium.com/@morgenroth/using-flutters-primary-swatch-with-a-custom-materialcolor-c5e0f18b95b0

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<List<Map<String,dynamic>>>> _textLoaded;

  _MyHomePageState(){
    _textLoaded = FirebaseFirestore.instance.collection("lena").where("date-published", isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))).get().then(
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
        if(docs.isNotEmpty){
          setState(() {
            _enableArrowBtns = true;
          });
        }
        data.add(docs);
        return FirebaseFirestore.instance.collection("users").where("username", isEqualTo: "lena").get().then((value) {
          data.add([value.docs.elementAt(0).data()]);

          setState(() {
            _resFirebase = true;
          });
          return data;
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  final GlobalKey<ChFavoriteBtnState> _favBtnKey = GlobalKey();
  final GlobalKey<ChCheeseSliderState> _cheeseSliderKey = GlobalKey();

  bool _enableArrowBtns = false;

  final CarouselController _carouselController = CarouselController();

  int currentPage = 0;

  List<Map<String, dynamic>> fbDocs = [];

  String partner = "partner";

  bool _resFirebase = false;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      backgroundColor: Color.fromRGBO(255, 201, 3, 1.0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CHIconButton(icon: Icons.history, onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryRoute()),
                );
              },),
              const Text("Cheese Hub", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              CHIconButton(icon: Icons.person_outline, onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileRoute()),
                );
              })
            ],
          ),
          Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: FutureBuilder<List<List<Map<String, dynamic>>>>(
              future: _textLoaded,
              builder: (BuildContext context, AsyncSnapshot<List<List<Map<String,dynamic>>>> snapshot){
                if(snapshot.hasData){
                  if(snapshot.data?.elementAt(0).isEmpty ?? true){
                    return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text("Nothing here yet for today :( \n (Does not mean that you aren't gorgeous or sexy - you are both)", textAlign: TextAlign.center,)
                    );
                  }
                  partner = snapshot.data?.elementAt(1).elementAt(0)["partner"].toString() ?? "";
                  fbDocs = snapshot.data?.elementAt(0) ?? [];
                  List? cheesiness = fbDocs.map((i) => i["cheesiness"]).toList();
                  List? hearted = fbDocs.map((i) => i["favourite"]).toList();
                  return Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 250.0,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          onPageChanged: (pageNum, changeReason){
                            _favBtnKey.currentState!.setHearted(fbDocs.map((i) => i["favourite"]).toList()[pageNum] as bool);
                            _cheeseSliderKey.currentState!.setValue((fbDocs.map((i) => i["cheesiness"]).toList()[pageNum] as int).toDouble());
                            currentPage = pageNum;
                          },
                        ),
                        carouselController: _carouselController,
                        items: fbDocs.map((i) {
                          return i["msg"];
                        }).map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(35)),
                                      border: Border.all(color: Colors.black, width: 3)
                                  ),
                                  child: Padding(
                                      padding: EdgeInsets.all(25),
                                      child: Center(
                                        child: Text('$i', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                      )
                                  )
                              );
                            },
                          );
                        }).toList(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40, right: 20),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ChCheeseSlider(
                              key: _cheeseSliderKey,
                              initialValue: (cheesiness?[0] as int).toDouble(),
                            onChangeEnd: (double value){
                              FirebaseFirestore.instance
                                  .collection("lena")
                                  .doc(fbDocs[currentPage]["_id"])
                                  .update({"cheesiness": value.toInt()});
                              fbDocs[currentPage]["cheesiness"] = value.toInt();
                            },
                          ),
                          ChFavoriteBtn(
                            key: _favBtnKey,
                            initHearted: (hearted?[0] as bool),
                            onPressed: (bool hearted){
                              FirebaseFirestore.instance
                                  .collection("lena")
                                  .doc(fbDocs[currentPage]["_id"])
                                  .update({"favourite": hearted});
                              fbDocs[currentPage]["favourite"] = hearted;
                            },
                          )
                        ],
                      ),
                      )
                    ],
                  );
                }
                else{
                  return Text("Nothing here yet :(");
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ARROW BUTTONS ARE DISABLED BY onPressed = null!!!
              CHArrowButton(onPressed: (_enableArrowBtns) ? (){
                _carouselController.previousPage();
              } : null, pointsToRight: false,),
              CHIconButton(icon: Icons.chat_outlined, onPressed: (_resFirebase) ? (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatRoute(partner: partner,)),
                );
              } : null),
              CHArrowButton(onPressed: (_enableArrowBtns) ? (){
                _carouselController.nextPage();
              } : null, pointsToRight: true,),
            ],
          )
        ],
      )
    );
  }
}
