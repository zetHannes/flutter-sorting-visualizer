
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vizor/scrollSelector.dart';
import 'package:vizor/sliderWidget.dart';

import 'arraySizeWidget.dart';
class Keys {
  static final GlobalKey<VizorSliderState> sliderKey = GlobalKey();
  static final GlobalKey<ArraySizeWidgetState> arraySizeKey = GlobalKey();
}

class OptionsWidget extends StatefulWidget {

  final ValueChanged<double> onSliderChanged;
  final ValueChanged<int> onSelectionChanged;
  final ValueChanged<int> onSortingAlgoChanged;

  OptionsWidget({Key key, @required this.onSelectionChanged, @required this.onSliderChanged, @required this.onSortingAlgoChanged}) : super(key: key);

  @override
  OptionsWidgetState createState() => OptionsWidgetState();
}

class OptionsWidgetState extends State<OptionsWidget> {
  
  bool disabled = false;
  
  int getArraySize() {
    return Keys.arraySizeKey.currentState.getSelection();
  }

  OptionsWidgetState() {
  }

  // actions after finishing the sort or resetting the data.
  void finish() {
    enable();
  }

  // prepares the OptionsWidget and the child widgets for sorting
  void prepareSortingVisualization() {
    disable();
  }

  // Disable the widget: IgnorePointer ignoring attribute is true
  bool disable() {
    setState(() {
      disabled = true;      
    });
  }

  // Enable the widget: IgnorePointer ignoring attribute is false
  bool enable() {
    setState(() {
      disabled = false;
    });
  }

  void scrollSelectorChanged(int value) {
    widget.onSortingAlgoChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disabled,
      child: Column(children: [
        ScrollSelector(onValueChanged: scrollSelectorChanged,),
        Padding(
          padding: EdgeInsets.only(top:10, bottom:5),
          child: Text("Speed", style: TextStyle(color: Colors.white, fontFamily: "Segoe UI", fontWeight: FontWeight.bold, fontSize:30)),
        ),
        VizorSlider(key: Keys.sliderKey, onValueChanged: widget.onSliderChanged,),
        Padding(
          padding: EdgeInsets.only(top:10,bottom:5),
          child:
          Text("Data Set Size", style: TextStyle(color: Colors.white, fontFamily: "SegoeUI", fontWeight: FontWeight.bold, fontSize:30))
        ),
        ArraySizeWidget(
          key: Keys.arraySizeKey,
          onSelectionChanged: widget.onSelectionChanged,
        )
      ])
    );
  }
}
