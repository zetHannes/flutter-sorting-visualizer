
import 'dart:io';
import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
class ArraySizeWidget extends StatefulWidget {

  final ValueChanged<int> onSelectionChanged;

  ArraySizeWidget({Key key, this.onSelectionChanged}) : super(key: key);

  @override
  ArraySizeWidgetState createState() => ArraySizeWidgetState();
}

class ArraySizeWidgetState extends State<ArraySizeWidget> with TickerProviderStateMixin {

  final Color _colorGreen = Color.fromARGB(255,0,167,40);
  final Color _colorGray = Color.fromARGB(255, 59, 59, 59);
  
  int _selectedIndex = 1;
  bool startupMode = true;
  List<int> values = [5,10,50,100,200];
  ArraySizeWidgetState() {
  }

  int getSelection() {
    return values[_selectedIndex];
  }


 @override
 initState() {
 }

 void changeIndex(int val) {
   setState(() {
    _selectedIndex = val;
    widget.onSelectionChanged(values.elementAt(_selectedIndex));
  });
 }

  @override
   build(BuildContext context) {
    double wdt = 62;   // the width of each element
    double margin = 7; // the margin of each element
    return Padding(
      padding: EdgeInsets.all(5), 
      child:Center(
        child:Row(
          children: [ 
            GestureDetector(
              onTap: () {
                changeIndex(0);
              },
              child: Padding(
                padding: EdgeInsets.only(left:margin, right: margin),
                child: DottedBorder(
                  color: Colors.white,
                  dashPattern: [10,4],
                  borderType: BorderType.RRect,
                    radius: Radius.circular(8),

                  strokeWidth: 3,
                  child: Container(
                    width: wdt,
                    height:35,
                    decoration: BoxDecoration(
                      color: ( _selectedIndex == 0 ) ? _colorGreen : _colorGray,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(child:Text(values[0].toString(),style: TextStyle(fontFamily: "SegoeUI", fontSize: 25, color:  Colors.white)))
                  ),
                )
                )
            ),
            GestureDetector(
              onTap: () {
                changeIndex(1);
              },
              child: Padding(
                padding: EdgeInsets.only(left:margin, right: margin),
                child: DottedBorder(
                  color: Colors.white,
                  dashPattern: [10,4],
                  borderType: BorderType.RRect,
                    radius: Radius.circular(8),

                  strokeWidth: 3,
                  child: Container(
                    width: wdt,
                    height:35,
                    decoration: BoxDecoration(
                      color: ( _selectedIndex == 1 ) ? _colorGreen : _colorGray,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(child:Text(values[1].toString(),style: TextStyle(fontFamily: "SegoeUI", fontSize: 25, color:  Colors.white)))
                  ),
                )
                )
            ),
            GestureDetector(
              onTap: () {
                changeIndex(2);
              },
              child: Padding(
                padding: EdgeInsets.only(left:margin, right: margin),
                child: DottedBorder(
                  color: Colors.white,
                  dashPattern: [10,4],
                  borderType: BorderType.RRect,
                    radius: Radius.circular(8),

                  strokeWidth: 3,
                  child: Container(
                    width: wdt,
                    height:35,
                    decoration: BoxDecoration(
                      color: ( _selectedIndex == 2 ) ? _colorGreen : _colorGray,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(child:Text(values[2].toString(),style: TextStyle(fontFamily: "SegoeUI", fontSize: 25, color:  Colors.white)))
                  ),
                )
                )
            ),
            GestureDetector(
              onTap: () {
                changeIndex(3);
              },
              child: Padding(
                padding: EdgeInsets.only(left:margin, right: margin),
                child: DottedBorder(
                  color: Colors.white,
                  dashPattern: [10,4],
                  borderType: BorderType.RRect,
                    radius: Radius.circular(8),

                  strokeWidth: 3,
                  child: Container(
                    width: wdt,
                    height:35,
                    decoration: BoxDecoration(
                      color: ( _selectedIndex == 3 ) ? _colorGreen : _colorGray,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(child:Text(values[3].toString(),style: TextStyle(fontFamily: "SegoeUI", fontSize: 25, color:  Colors.white)))
                  ),
                )
                )
            ),
            GestureDetector(
              onTap: () {
                changeIndex(4);
              },
              child: Padding(
                padding: EdgeInsets.only(left:margin, right: margin),
                child: DottedBorder(
                  color: Colors.white,
                  dashPattern: [10,4],
                  borderType: BorderType.RRect,
                    radius: Radius.circular(8),

                  strokeWidth: 3,
                  child: Container(
                    width: wdt,
                    height:35,
                    decoration: BoxDecoration(
                      color: ( _selectedIndex == 4 ) ? _colorGreen : _colorGray,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(child:Text(values[4].toString(),style: TextStyle(fontFamily: "SegoeUI", fontSize: 25, color:  Colors.white)))
                  ),
                )
                )
            )
          ]
        )
      )
    );
  }
}

