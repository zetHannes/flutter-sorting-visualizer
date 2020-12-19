
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vizor/sliderWidget.dart';
class OptionsWidget extends StatefulWidget {
  OptionsWidget({Key key}) : super(key: key);

  @override
  OptionsWidgetState createState() => OptionsWidgetState();
}

class OptionsWidgetState extends State<OptionsWidget> {
  GlobalKey<VizorSliderState> _myKey = GlobalKey();


  double getSliderValue() {
    return _myKey.currentState.getOffset();
  }
  OptionsWidgetState() {
  }


  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Speed", style: TextStyle(color: Colors.white, fontFamily: "Segoe UI", fontWeight: FontWeight.bold, fontSize:30)),
      VizorSlider(key: _myKey)
    ]);
  }
}
