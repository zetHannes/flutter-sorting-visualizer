
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vizor/sliderWidget.dart';

import 'arraySizeWidget.dart';
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
      Padding(
        padding: EdgeInsets.only(top:10, bottom:5),
        child: Text("Speed", style: TextStyle(color: Colors.white, fontFamily: "Segoe UI", fontWeight: FontWeight.bold, fontSize:30)),
      ),
      VizorSlider(key: _myKey),
      Padding(
        padding: EdgeInsets.only(top:10,bottom:5),
        child:
        Text("Data Set Size", style: TextStyle(color: Colors.white, fontFamily: "SegoeUI", fontWeight: FontWeight.bold, fontSize:30))
      ),
      ArraySizeWidget()
    ]);
  }
}
