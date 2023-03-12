import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginRoute extends StatelessWidget {
  const LoginRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        backgroundColor: Color.fromRGBO(255, 201, 3, 1.0),
    );
  }
}
