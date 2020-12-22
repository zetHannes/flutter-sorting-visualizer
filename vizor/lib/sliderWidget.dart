
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
class VizorSlider extends StatefulWidget {
  VizorSlider({Key key}) : super(key: key);

  @override
  VizorSliderState createState() => VizorSliderState();
}

class VizorSliderState extends State<VizorSlider> with TickerProviderStateMixin {
  double _min = 0,
      _max = 100,
      _currentValue = 0,
      _offset = 0,  // left side of the slider circle
      padding = 30;
  Color _green = Color.fromARGB(255,0,167,40);

  VizorSliderState() {
  }

  double getOffset() {
    return _offset;
  }
  
 @override
 initState() {
 }

  @override
   build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {  
        setState(() {
          if ( event.position.dx > padding && event.position.dx < MediaQuery.of(context).size.width-50 ) {
            double dx = event.position.dx - padding - _offset;
            _offset += dx;
          }
        });      
      },
      onPointerMove: (PointerMoveEvent event) {
          setState(() {
            if ( event.position.dx > padding && event.position.dx < MediaQuery.of(context).size.width-50 ) {
              double dx = event.position.dx - padding - _offset;
              _offset += dx;
            }
        });   
      },
      onPointerUp: (PointerUpEvent event) {
        
      },
      child:Stack(children:[
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255,150,150,150),
            borderRadius: BorderRadius.all(Radius.circular(50))
          ),
          width:MediaQuery.of(context).size.width-padding,
          height: 50
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 1),
          curve: Curves.linear,
          width:_offset+50,
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255,0,167,40),
              borderRadius: BorderRadius.all(Radius.circular(50))
            ),
            height: 50
          )
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 1),
          curve: Curves.linear,
          left: _offset,
          width: 50,
          height:50,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            width:50,height:50,
          )
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 1),
          curve: Curves.linear,
          left: _offset + 15,
          width: 20,
          height:20,
          top:15,
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255,0,167,40),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            width:20,height:20,
          )
        )
      ])
    );
  }
}
