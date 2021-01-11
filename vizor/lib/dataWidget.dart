
import 'dart:io';
import 'dart:math';
import 'package:vizor/modes.dart' as modes;
import 'package:flutter/material.dart';
class DataWidget extends StatefulWidget {
  final VoidCallback onFinish;
  DataWidget({Key key, @required this.onFinish}) : super(key: key);

  @override
  DataWidgetState createState() => DataWidgetState(onFinish: this.onFinish);
}

class DataWidgetState extends State<DataWidget> {
  int _itemCount = 10;

  double _sleepTime = 2;
  double _initialSleepTime = 2;

  List<double> values;

  bool stopped = false;
  bool startupMode = true;

  bool finished = false;
  double previousElement = -100;
  final VoidCallback onFinish;

  DataWidgetState({Key key, @required this.onFinish}) {
    generateNewData(_itemCount);
    startupMode = false;
  }

  // changes the sleep timer in order to accelerate/slow down the sorting operations
  void changeSpeed(double percentage) {
    double factor = 1 - percentage;
    setState(() {
      _sleepTime = _initialSleepTime * factor;
      print("factor:" + factor.toString() + " , sleeptime:" + _sleepTime.toString());
    });
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

Future<int> _partition(low,high) async{
  print("partition: " + stopped.toString());
    if ( stopped ) {
        return -10;
    }
    int idx = low;
    int pivot = high;
    while(idx < pivot) {
        if (pivot > idx && values.elementAt(idx) > values.elementAt(pivot)) {
          setState(() {
            double val = values.elementAt(idx);
            values.removeAt(idx);
            values.insert(pivot,val);
            pivot-=1;
          });
        }
        else if (pivot > idx) {
            idx+=1;
        }
        else if (pivot < idx && values.elementAt(idx) < values.elementAt(pivot)) {
          setState(() {
            double val = values.elementAt(idx);
            values.removeAt(idx);
            values.insert(pivot,val);
            idx+=1;
          });
        }
        await Future.delayed(Duration(milliseconds: (_sleepTime*1000).round()));
    }
    return pivot;
}
Future<void> _quickSort(int low, int high) async {
  print("_quickSort " + stopped.toString());
  if ( stopped ) {
    return;
  }
  if ( low < high) {
      int pi = await _partition(low,high);
      _quickSort(low,pi-1);
      _quickSort(pi+1,high);
    }
    else {
      bool unsorted = false;
      double previous = -100;
      for(int i = 0; i < values.length;i++) {
        double current = values.elementAt(i);
        if ( current < previous ) {
          unsorted = true;
          break;
        }
        previous = current;
      }
      if ( !unsorted ) {
        print("finished!");
        finished = true;
        return;
      }
    }
  }

  void quickSort() async {
    await _quickSort(0, values.length-1);

    // algorithm has finished
    if ( finished ) { 
      print("tell other widgets to finish");
      sleep(Duration(seconds:1)); // wait for the recursion to end
      onFinish();                 // tell the rest of the app to finish off
    }
    else {
      print("user stoppped algorithm. jeez");
    }
  }

  void heapSort() {

  }

  void mergeSort() {

  }

  void insertionSort() {

  }
  
  void sort(int whichSortingAlgorithm) {
    stopped = false;
    switch(whichSortingAlgorithm) {
      case modes.modeBubbleSort:
        bubbleSort();
        break;
      case modes.modeQuickSort:
        quickSort();
        break;
      case modes.modeHeapSort:
        heapSort();
        break;
      case modes.modeMergeSort:
        mergeSort();
        break;
      case modes.modeInsertionSort:
        insertionSort();
        break;
    }
  }

  void stop() {
    print("stopped");
    setState(() {
      stopped = true;      
    });
  }

  @override
  Widget build(BuildContext context) {
    Random rand = new Random();
    return Column(children: [
      Padding(
        padding: EdgeInsets.all(5),
        child: SizedBox(
          height: MediaQuery.of(context).size.height*0.37,
          child: DataPainter()
        )
      ),
      Divider(
        color:Colors.white, 
        thickness: 3,
        indent: 5,
        endIndent: 5,
      )
    ],);
  }
}


class DataPainter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: ShapePainter(),
        child: Container(),
      );
  }
}


class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    Offset startingPoint = Offset(0, size.height / 2);
    Offset endingPoint = Offset(size.width, size.height / 2);

    canvas.drawLine(startingPoint, endingPoint, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}