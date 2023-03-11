import 'package:flutter/material.dart';

class ChCheeseSlider extends StatefulWidget {
  final double initialValue;
  final void Function(double) onChangeEnd;

  const ChCheeseSlider({Key? key, required this.initialValue, required this.onChangeEnd}) : super(key: key);

  @override
  State<ChCheeseSlider> createState() => ChCheeseSliderState();
}

class ChCheeseSliderState extends State<ChCheeseSlider> {
  late double _value;

  double get value => _value;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _value = widget.initialValue;
  }

  void setValue(double value){
    setState(() {
      _value = value;
    });
  }

  void reset(){
    setState(() {
      _value = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.all(Radius.circular(100)),
        color: Colors.white,
      ),
      // https://blog.logrocket.com/flutter-slider-widgets-deep-dive-with-examples/
      child: SliderTheme(
        data: const SliderThemeData(
          activeTrackColor: Colors.black,
          inactiveTrackColor: Colors.black,
          thumbColor: Colors.black,
          inactiveTickMarkColor: Colors.yellow,
          thumbShape: RoundSliderThumbShape(disabledThumbRadius: 7, enabledThumbRadius: 7),
          overlayColor: Colors.white
        ),
        child: Slider(
          min: 0.0,
          max: 2.0,
          divisions: 2,
          value: _value,
          onChanged: (double value) {
            setState(() {
              _value = value;
            });
          },
          onChangeEnd: widget.onChangeEnd,
        ),
      )
    );
  }
}
