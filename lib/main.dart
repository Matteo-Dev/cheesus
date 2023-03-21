import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cheesus/CHArrowButton.dart';
import 'package:cheesus/CHCheeseSlider.dart';
import 'package:cheesus/CHFavoriteBtn.dart';
import 'package:cheesus/CHIconButton.dart';
import 'package:cheesus/ChatRoute.dart';
import 'package:cheesus/HistoryRoute.dart';
import 'package:cheesus/LoadingRoute.dart';
import 'package:cheesus/LoginRoute.dart';
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
      home: LoginRoute(),
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
  final List<List<Map<String, dynamic>>> firebaseData;

  const MyHomePage({super.key, required this.firebaseData});

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
  final GlobalKey<ChFavoriteBtnState> _favBtnKey = GlobalKey();
  final GlobalKey<ChCheeseSliderState> _cheeseSliderKey = GlobalKey();

  final CarouselController _carouselController = CarouselController();

  int currentPage = 0;

  late List<Map<String, dynamic>> fbDocs;

  late String partner;

  late Map<String, String> user;

  @override
  Widget build(BuildContext context) {
    fbDocs = widget.firebaseData.elementAt(0);
    user = widget.firebaseData.elementAt(1).elementAt(0).map((key, value) => MapEntry(key, value.toString()));
    partner = user["partner"] ?? "";

    List<int> cheesiness = fbDocs.map((i) => i["cheesiness"] as int).toList();
    List<bool> hearted = fbDocs.map((i) => i["favourite"] as bool).toList();

    // TODO: Check if list empty!
    Widget mainWidget;

    if(widget.firebaseData.elementAt(0).isEmpty){
      mainWidget = const Padding(
        padding: EdgeInsets.all(70),
        child: Text("Bisher ist leider noch kein neuer Cheese für heute angekommen :(", textAlign: TextAlign.center,)
      );
    } else {
      mainWidget = Column(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ChCheeseSlider(
                        key: _cheeseSliderKey,
                        initialValue: (cheesiness?[0] as int).toDouble(),
                        onChangeEnd: (double value){
                          FirebaseFirestore.instance
                              .collection(user["username"] ?? "")
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
                              .collection(user["username"] ?? "")
                              .doc(fbDocs[currentPage]["_id"])
                              .update({"favourite": hearted});
                          fbDocs[currentPage]["favourite"] = hearted;
                        },
                      )
                    ],
                  ),
                  // TextButton(onPressed: (){}, child: Text("Nach neuem Cheese suchen", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black)))
                ],
              )
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      resizeToAvoidBottomInset: false, // https://stackoverflow.com/questions/55312583/overflow-error-in-flutter-when-keyboard-open
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
                  MaterialPageRoute(builder: (context) => HistoryRoute(user: user)),
                );
              },),
              const Text("Cheese Hub", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              CHIconButton(icon: Icons.person_outline, onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileRoute(user: user)),
                );
              })
            ],
          ),
          Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: mainWidget,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ARROW BUTTONS ARE DISABLED BY onPressed = null!!!
              CHArrowButton(onPressed: _carouselController.previousPage, pointsToRight: false,),
              CHIconButton(icon: Icons.chat_outlined, onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatRoute(user: user)),
                );
              }),
              CHArrowButton(onPressed: _carouselController.nextPage, pointsToRight: true,),
            ],
          )
        ],
      )
    );
  }
}
