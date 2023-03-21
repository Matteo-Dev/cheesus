import 'package:cheesus/LoadingRoute.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginRoute extends StatefulWidget {

  @override
  State<LoginRoute> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  bool shouldDoRequest = FirebaseAuth.instance.currentUser == null;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if(shouldDoRequest){
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(toolbarHeight: 0),
        backgroundColor: Color.fromRGBO(255, 201, 3, 1.0),
        body: Center(
          child: Padding(
              padding: EdgeInsets.all(60),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Cheesus", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                    const SizedBox(height: 40,),
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50)), borderSide: BorderSide(width: 3, color: Colors.black)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(35)),
                              borderSide: BorderSide(color: Colors.black, width: 3)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(35)),
                              borderSide: BorderSide(color: Colors.black, width: 3)
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 30
                          ),
                          hintText: "Username",
                          hintStyle: TextStyle(fontWeight: FontWeight.bold),
                          fillColor: Colors.white,
                          filled: true
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50)), borderSide: BorderSide(width: 3, color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(35)),
                            borderSide: BorderSide(color: Colors.black, width: 3)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(35)),
                            borderSide: BorderSide(color: Colors.black, width: 3)
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 30
                        ),
                        hintText: "Passwort",
                        hintStyle: TextStyle(fontWeight: FontWeight.bold),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 30,),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            border: Border.all(color: Colors.black, width: 3)
                        ),
                        child: TextButton(onPressed: (){
                          if(usernameController.value.text.isNotEmpty && passwordController.value.text.isNotEmpty){
                            FirebaseFirestore.instance.collection("users").where("username", isEqualTo: usernameController.value.text).get().then((value) {
                              if(value.docs.isNotEmpty){
                                FirebaseAuth.instance.signInWithEmailAndPassword(email: value.docs.elementAt(0).data()["email"] ?? "", password: passwordController.value.text).then((value) {
                                  User? user = value.user;
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoadingRoute(user: user))
                                  );
                                });
                              }
                            });
                          }
                        },child: Text("Log in", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))
                    )
                  ]
              )
          ),
        ),
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoadingRoute(user: FirebaseAuth.instance.currentUser))
        );
      });
      return Container(child: SizedBox(), color: Color.fromRGBO(255, 201, 3, 1.0),);
    }
  }
}
