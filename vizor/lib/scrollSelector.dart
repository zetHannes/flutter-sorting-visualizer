
import 'dart:io';
import 'dart:math' as math;
import 'package:vizor/modes.dart';
import 'package:flutter/material.dart';
class ScrollSelector extends StatefulWidget {
  final ValueChanged<int> onValueChanged;
  ScrollSelector({Key key, @required this.onValueChanged}) : super(key: key);

  @override
  ScrollSelectorState createState() => ScrollSelectorState();
}

class ScrollSelectorState extends State<ScrollSelector> with TickerProviderStateMixin {

  List<String> items = ["Bubble Sort", "Quick Sort", "Heap Sort", "Merge Sort", "Insertion Sort"];
  bool active = false;
  ScrollController _controller;
  final dataKey = new GlobalKey();
  double elementHeight = 45;
  int _currentIndex = 0;
  ScrollSelectorState() {
  }


 @override
 initState() {
   _controller = ScrollController();
   super.initState();
 }

  Widget getScrollSelectorButton(String label) {
    return Container(
      height: 45,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal:5),
          child: Align(
          alignment: Alignment.centerLeft,
          child: Text(label, style: TextStyle(color: Colors.white, fontFamily: "Segoe UI", fontWeight: FontWeight.bold, fontSize:30)),
        )
      )
    );
  }
  @override
   build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white54, width: 1.0),
          borderRadius: BorderRadius.circular(4.0),
          color: Color.fromARGB(255,0,104,124),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
                Container(
                  width: MediaQuery.of(context).size.width-20-30,
                  height: elementHeight,
                  child: NotificationListener(
                    onNotification: (t) {
                      if (t is ScrollEndNotification) {
                        int index = (_controller.position.pixels/elementHeight).round();
                        
                        // TODO: sometimes the _controller won't animate to the designated position
                        
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          double _position =  index*elementHeight;
                          _controller.animateTo(
                            _position,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.ease);
                        });
                        _currentIndex = index;
                        widget.onValueChanged(_currentIndex);
                      }	
                    },
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      controller: _controller,
                      child: Column(
                        children: [
                          getScrollSelectorButton(items[0]),
                          getScrollSelectorButton(items[1]),
                          getScrollSelectorButton(items[2]),
                          getScrollSelectorButton(items[3]),
                          getScrollSelectorButton(items[4]),
                        ]
                      )
                    )
                  )
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    children: [
                      Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.white,
                        size:25
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size:25
                      ),
                    ]
                  )
                )
              ],
            )
          ],
        )
      )
    );
  }
}