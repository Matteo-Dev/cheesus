import 'package:cheesus/CHBigButton.dart';
import 'package:cheesus/FillerAvatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CHIconButton.dart';
import 'main.dart';

class ChatRoute extends StatefulWidget {
  final String partner;

  const ChatRoute({Key? key, required this.partner}) : super(key: key);

  @override
  State<ChatRoute> createState() => _ChatRouteState();
}

class _ChatRouteState extends State<ChatRoute> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(toolbarHeight: 0),
          backgroundColor: Color.fromRGBO(255, 201, 3, 1.0),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CHIconButton(icon: Icons.arrow_back, onPressed: (){
                    if(_textEditingController.value.text.isEmpty) {
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    } else {
                      // # https://api.flutter.dev/flutter/material/AlertDialog-class.html
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                        title: const Text('Warte kurz!'),
                        content: const Text('Du hast noch ein wenig Cheese ungespeichert übrig gelassen. Willst du ihn wirklich verwerfen?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              Navigator.pop(context, 'Cancel');
                              Navigator.pop(context, 'Cancel');
                            },
                            child: const Text('Egal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('Stop!'),
                          ),
                        ],
                      ));
                    }
                  },),
                  const Text("Cheese Message", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  const FillerAvatar()
                ],
              ),
              Center(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 40, 40, 10),
                    child: TextField(
                      controller: _textEditingController,
                      expands: false,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 3,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
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
                    ChBigButton(onPressed: (){
                      FocusScope.of(context).unfocus();
                    }, text: "Save"),
                    const SizedBox(width: 10,),
                    ChBigButton(onPressed: (){
                      FocusScope.of(context).unfocus();

                    }, text: "Send")
                  ],
                ),
              ),
              Text(widget.partner)
            ],
          )
      ),
    );
  }
}
