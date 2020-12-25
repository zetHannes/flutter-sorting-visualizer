
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
class DataWidget extends StatefulWidget {
  final VoidCallback onFinish;
  DataWidget({Key key, @required this.onFinish}) : super(key: key);

  @override
  DataWidgetState createState() => DataWidgetState(onFinish: this.onFinish);
}

class DataWidgetState extends State<DataWidget> {
  int _itemCount = 10;
  double _sleepTime = 0.05;
  List<double> values;
  bool stopped = false;
  bool startupMode = true;
  final VoidCallback onFinish;
  final int modeBubbleSort = 0,
            modeQuickSort = 1,
            modeHeapSort = 2;

  DataWidgetState({Key key, @required this.onFinish}) {
    generateNewData(_itemCount);
    startupMode = false;
  }

  void generateNewData(int itemCount) {
    if ( startupMode ) {
      _itemCount = itemCount;
      values = new List<double>();
      Random rand = new Random();
      for(int i = 0; i < _itemCount; i++ ) {
        values.add(rand.nextDouble()*200);
      }
    }
    else {
      setState(() {
        _itemCount = itemCount;
        values = new List<double>();
        Random rand = new Random();
        for(int i = 0; i < _itemCount; i++ ) {
          values.add(rand.nextDouble()*200);
        }
      });
    }
  }

  void swapValues(int idx1, int idx2) {
    double val1 = values.elementAt(idx1);
    double val2 = values.elementAt(idx2);
    setState(() { 
      values.replaceRange(idx1,idx1+1, [val2]);
      values.replaceRange(idx2,idx2+1, [val1]);      
    });
  }


  void bubbleSort() async {
    for(int i = 0; i < values.length-1; i++) {
      for( int j = 0; j < values.length-i-1; j++) {
        if ( stopped ) {
          stopped = false;
          return;
        }
        if ( values.elementAt(j) > values.elementAt(j+1) ) {
          swapValues(j, j+1);
        }
        await Future.delayed(Duration(milliseconds: (_sleepTime*1000).round()));
      }
    }
    onFinish();
  }


  void sort(int whichSortingAlgorithm) {
    if ( whichSortingAlgorithm == modeBubbleSort ) {
      bubbleSort();
    }
    else if ( whichSortingAlgorithm == modeQuickSort ) {
      bubbleSort();
    }
    else if ( whichSortingAlgorithm == modeHeapSort ) {
      bubbleSort();
    }
  }

  void stop() {
    setState(() {
      stopped = true;      
    });
  }

  @override
  Widget build(BuildContext context) {
    Random rand = new Random();
    return GestureDetector(onTap: () {sort(modeBubbleSort);},child:Column(children: [
      Padding(
        padding: EdgeInsets.all(5),
        child: SizedBox(
          height: MediaQuery.of(context).size.height*0.37,
          child: Row(
            children: [
            ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: _itemCount,
              itemBuilder: (BuildContext ctxt, int index) {
                double fullSize = (MediaQuery.of(context).size.width-10)/_itemCount;
                double contHeight = values.elementAt(index);
                return Container(
                  width:fullSize,
                  child: Padding(
                    padding: EdgeInsets.only(right:fullSize*0.25, top:(200.0-contHeight)),
                    child:Container(
                      color: Color.fromARGB(255, 153,155,154),
                      height: contHeight,
                    )
                  )
                );
              }
            ),
          ])
        )
      ),
      Divider(
        color:Colors.white, 
        thickness: 3,
        indent: 5,
        endIndent: 5,
      )
    ],));
  }
}
