
import 'dart:io';
import 'dart:math';
import 'package:vizor/modes.dart' as modes;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class DataWidget extends StatefulWidget {
  final VoidCallback onFinish;
  DataWidget({Key key, @required this.onFinish}) : super(key: key);

  @override
  DataWidgetState createState() => DataWidgetState(onFinish: this.onFinish);
}

class Change {
  List<double> values;

  Change(List<double> vals) {
    this.values = vals;
  }
}

class DataWidgetState extends State<DataWidget> {
  int _itemCount = 10;

  double _sleepTime = 2;
  double _initialSleepTime = 2;

  List<double> values;

  bool renewed = true;
  bool stopped = false;
  bool startupMode = true;
  int steps = 0;
  bool finished = false;
  double previousElement = -100;
  final VoidCallback onFinish;

  List<Change> updates;
  int currentChange = 0;
  int updateIndex = 0;
  ChangeNotifier _repaint=ChangeNotifier();



  DataWidgetState({Key key, @required this.onFinish}) {
    generateNewData(_itemCount);
    startupMode = false;
    updates = new List<Change>();
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
        renewed = true;
        updates = new List<Change>();
      });
    }
  }


  Future<bool> showUpdates() async {
    int length = updates.length;
    for(int i = 0; i < length; i++) {
      if(stopped) {
        stopped = false;
        return false;
      }
      await Future.delayed(Duration(milliseconds: (_sleepTime*1000).round()));  
      setState(() {
        values = List.from(updates.elementAt(0).values);    
        updates.removeAt(0);    
      });   
    }
    updates = new List<Change>();
    return true;
  }



  void bubbleSort() async {
    if ( renewed || updates.length == 0 ) {
      List<double> list = List.from(values);
      for(int i = 0; i < list.length-1; i++) {
        for( int j = 0; j < list.length-i-1; j++) {
          if ( list.elementAt(j) > list.elementAt(j+1) ) {
            swap(list, j, j+1);
            updates.add(new Change(List.from(list)));
          }
        }
      }
    }
    bool hasFinished = await showUpdates();
    if ( hasFinished ) {
      setState(() {
        onFinish();      
      });
    }
  }

 
 
 void quickSort() async {
    List<double> list = List.from(values);

    if ( updates.length == 0 || renewed )
      _quickSort(list, 0, values.length-1);
    renewed = false;
    bool hasFinished = await showUpdates();
    if ( hasFinished ) {
      onFinish();
    }
  }


List<double> _quickSort(List<double> list, int low, int high) {
  if (low < high) {
    int pi = partition(list, low, high);
    _quickSort(list, low, pi - 1);
    _quickSort(list, pi + 1, high);
  }
  return list;
}

int partition(List<double> list, low, high) {
  if (list.isEmpty) {
    return 0;
  }
  double pivot = list[high];

  int i = low - 1;
  for (int j = low; j < high; j++) {
    if (list[j] < pivot) {
      i++;
      swap(list, i, j);
      List<double> l = List.from(list);
      updates.add(new Change(l));
    }
  }
  swap(list, i + 1, high);
  List<double> l = List.from(list);
  updates.add(new Change(l));
  return i + 1;
}

void swap(List list, int i, int j) {
  double temp = list[i];
  list[i] = list[j];
  list[j] = temp;
}




  
  void heapSort() async {
    if ( renewed || updates.length == 0 ) {
      List<double> list = List.from(values);
        int n = list.length;
 
        for (int i = (n / 2).floor() - 1; i >= 0; i--)
            heapify(list, n, i);
 
        for (int i = n - 1; i > 0; i--) {
            // Move current root to end
            swap(list,0,i);
            updates.add(new Change(List.from(list)));
 
            heapify(list, i, 0);
        }
    }
    bool hasFinished = await showUpdates();
    if ( hasFinished ) {
      setState(() {
        onFinish();
      });
    }
    }
    void heapify(List<double> list, int n, int i)
    {
        int largest = i; // Initialize largest as root
        int l = 2 * i + 1; // left = 2*i + 1
        int r = 2 * i + 2; // right = 2*i + 2
 
        // If left child is larger than root
        if (l < n && list.elementAt(l) > list.elementAt(largest))
            largest = l;
 
        // If right child is larger than largest so far
        if (r < n && list.elementAt(r) > list.elementAt(largest))
            largest = r;
 
        // If largest is not root
        if (largest != i) {
            swap(list,i,largest);
            updates.add(new Change(List.from(list)));
 
            // Recursively heapify the affected sub-tree
            heapify(list, n, largest);
        }
    }


  void merge(List<double> list, int l, int m, int r) {
    int n1 = m - l + 1;
    int n2 = r - m;

    List<double> L = new List<double>(n1);
    List<double> R = new List<double>(n2);
    int i, j;
    for (i = 0; i < n1; ++i) {
      L[i] = list[l + i];
    }
    for (j = 0; j < n2; ++j) {
      R[j] = list[m + 1 + j];
    }

    i = 0;
    j = 0;

    int k = l;
    while (i < n1 && j < n2) {
      if (L[i] <= R[j]) {
          list[k] = L[i];
          i++;
          updates.add(new Change(List.from(list)));
      }
      else {
          list[k] = R[j];
          j++;
          updates.add(new Change(List.from(list)));
      }
      k++;
    }

    while (i < n1) {
      list[k] = L[i];
      i++;
      k++;
      updates.add(new Change(List.from(list)));
    }
    while (j < n2) {
      list[k] = R[j];
      j++;
      k++;
      updates.add(new Change(List.from(list)));
    }
  }

    void _mergeSort(List<double> list, int l, int r) {
      if (l < r) {
          int m = ((l + r) / 2).floor();

          _mergeSort(list, l, m);
          _mergeSort(list, m + 1, r);

          merge(list, l, m, r);
      }
    }

    mergeSort() async {
      List<double> list = List.from(values);
      if ( renewed || updates.length == 0 ) {
        _mergeSort(list, 0, list.length-1);
      }
      bool finished = await showUpdates();
      if ( finished ) {
        onFinish();
      }
    }


  void insertionSort() async {
    if ( renewed || updates.length == 0 ) {
    List<double> valuesToInsert = List.from(values);
    List<double> list = new List<double>();
    updates.add(new Change(List.from(list)));
    int remainingValues = valuesToInsert.length;
    for(int i = 0; i < remainingValues; i++) {
      double value = valuesToInsert.elementAt(0);
      valuesToInsert.removeAt(0);
      int idx = 0;
      while(idx < list.length && list.elementAt(idx) < value) {
        idx++;
      }
      list.insert(idx, value);
      updates.add(new Change(List.from(list)));
    }
    }
    bool hasFinished = await showUpdates();
    if ( hasFinished ) {
      setState(() {
        onFinish();
      });
    }
    
  }
  
  void sort(int whichSortingAlgorithm) {
    if ( updates.length > 0 ) {
      setState(() {
        renewed = false;
      });
    }
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
    return Column(children: [
      Padding(
        padding: EdgeInsets.all(5),
        child: SizedBox(
          height: MediaQuery.of(context).size.height*0.37,
          child: CustomPaint(
            painter: ShapePainter(values,_itemCount, _repaint),
            child: Container(),
          )
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



class ShapePainter extends CustomPainter {
  List<double> values;
  int itemCount;
  ChangeNotifier repaint;
  ShapePainter(List<double> values, int itemCount, ChangeNotifier repaint) : super(repaint: repaint) {
    this.values = values;
    this.itemCount = itemCount;
  }


  @override
  void paint(Canvas canvas, Size size) {
    double marginRight = 5;
    double marginLeft = 5;
    double fullSize = (size.width)/itemCount;
    double _offset = fullSize/2;
    var paint = Paint()
      ..color = Colors.teal[600]
      ..strokeWidth = fullSize * 0.8
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;
    int index = 0;
    while ( index < values.length ) {
      double contHeight = values.elementAt(index)*1.5;
      Offset startingPoint = Offset(_offset, size.height);
      Offset endingPoint = Offset(_offset, size.height-contHeight);
      canvas.drawLine(startingPoint, endingPoint, paint);
      _offset += fullSize;
      index++;
    }
    
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}