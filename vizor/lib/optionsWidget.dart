
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vizor/sliderWidget.dart';

import 'arraySizeWidget.dart';
class Keys {
  static final GlobalKey<VizorSliderState> sliderKey = GlobalKey();
  static final GlobalKey<ArraySizeWidgetState> arraySizeKey = GlobalKey();
}

class OptionsWidget extends StatefulWidget {

  final ValueChanged<int> onSelectionChanged;

  OptionsWidget({Key key, @required this.onSelectionChanged}) : super(key: key);

  @override
  OptionsWidgetState createState() => OptionsWidgetState();
}

class OptionsWidgetState extends State<OptionsWidget> {

  double getSliderValue() {
    return Keys.sliderKey.currentState.getValue();
  }

  int getArraySize() {
    return Keys.arraySizeKey.currentState.getSelection();
  }

  OptionsWidgetState() {
  }

  // actions after finishing the sort or resetting the data.
  void finish() {
    Keys.arraySizeKey.currentState.enable();
  }

  // prepares the OptionsWidget and the child widgets for sorting
  void prepareSortingVisualization() {
    Keys.arraySizeKey.currentState.disable();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(top:10, bottom:5),
        child: Text("Speed", style: TextStyle(color: Colors.white, fontFamily: "Segoe UI", fontWeight: FontWeight.bold, fontSize:30)),
      ),
      VizorSlider(key: Keys.sliderKey),
      Padding(
        padding: EdgeInsets.only(top:10,bottom:5),
        child:
        Text("Data Set Size", style: TextStyle(color: Colors.white, fontFamily: "SegoeUI", fontWeight: FontWeight.bold, fontSize:30))
      ),
      ArraySizeWidget(
        key: Keys.arraySizeKey,
        onSelectionChanged: widget.onSelectionChanged,
      )
    ]);
  }
}
