import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChFavoriteBtn extends StatefulWidget {
  final bool initHearted;
  final void Function(bool) onPressed;
  const ChFavoriteBtn({Key? key, required this.initHearted, required this.onPressed}) : super(key: key);

  @override
  State<ChFavoriteBtn> createState() => ChFavoriteBtnState();
}

class ChFavoriteBtnState extends State<ChFavoriteBtn> {
  bool hearted = false;

  void setHearted(bool hearted){
    setState(() {
      this.hearted = hearted;
    });
  }

  void reset(){
    setState(() {
      hearted = false;
    });
  }

  void _toggle(){
    setState(() {
      hearted = !hearted;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hearted = this.widget.initHearted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(20),
      padding: EdgeInsets.zero,
      child: IconButton(
          onPressed: () {
            widget.onPressed(!hearted);
            _toggle();
          },
          icon: (hearted) ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
          padding: EdgeInsets.zero),
    );
  }
}
