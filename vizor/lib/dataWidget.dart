
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
  List<List<int>> swapMarkers;
  Change(List<double> vals, List<List<int>> markers) {
    this.values = vals;
    this.swapMarkers = markers;
  }
}

class DataWidgetState extends State<DataWidget> with TickerProviderStateMixin {
  int _itemCount = 10;

  Animation<int> 
  ation;
  AnimationController controller;
  
  double _sleepTime = 2;
  double _initialSleepTime = 2;

  List<double> values;
  List<double> previousValues;
  List<List<int>> swapMarkers;

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
    swapMarkers = new List<List<int>>(3);
    swapMarkers[0] = new List<int>();
    swapMarkers[1] = new List<int>();
  }

   @override
  void initState() {
    super.initState();
  }

  // changes the sleep timer in order to accelerate/slow down the sorting operations
  void changeSpeed(double percentage) {
    double factor = 1 - percentage;
    List<List<int>> markers = swapMarkers;
    setState(() {
      swapMarkers = markers;
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
        swapMarkers = new List<List<int>>(3);
        swapMarkers[0] = new List<int>();
        swapMarkers[1] = new List<int>();
      });
    }
  }

  Future<bool> showUpdates() async {
    int length = updates.length;
    updates.add(new Change(new List<double>(), new List<List<int>>(3)));
    for(int i = 0; i < length; i++) {
      if(stopped) {
        stopped = false;
        return false;
      }
      await Future.delayed(Duration(milliseconds: (_sleepTime*1000).round()));  
      setState(() {
        if ( updates.length > 0 ) {
          values = List.from(updates.elementAt(0).values);   
          swapMarkers = List.from(updates.elementAt(0).swapMarkers); 
          if ( i < length-1 ) // do not remove the last one at the end to be able to clear the swap markers
            updates.removeAt(0);    
        }
      });   
    }
    setState(() {
        values = List.from(updates.elementAt(0).values);   
        swapMarkers = List<List<int>>(3);
        swapMarkers[0] = new List<int>();
        swapMarkers[1] = new List<int>();
      });   
    updates = new List<Change>();
    return true;
  }

  void bubbleSort() async {
    if ( renewed || updates.length == 0 ) {
      List<double> list = List.from(values);
      List<int> endMarker = new List<int>();
      for(int i = 0; i < list.length-1; i++) {
        endMarker = new List<int>();
        endMarker.add(list.length-i);;
        for( int j = 0; j < list.length-i-1; j++) {
          if ( list.elementAt(j) > list.elementAt(j+1) ) {
            swap(list, j, j+1, endMarker);            
          }
          else {
            List<List<int>> mks = new List<List<int>>(3);
            mks[0] = new List<int>();
            mks[1] = new List<int>();
            mks[2] = List.from(endMarker);
            mks[0].add(j);
            updates.add(new Change(List.from(list), List.from(mks)));
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
  List<int> pivMarkers = new List<int>();
  pivMarkers.add(low);
  pivMarkers.add(high);
  int i = low - 1;
  for (int j = low; j < high; j++) {
    if (list[j] < pivot) {
      i++;
      swap(list, i, j, pivMarkers);
    }
  }
  pivMarkers.clear();
  pivMarkers.add(low);
  pivMarkers.add(i+1);
  swap(list, i + 1, high, pivMarkers);
  return i + 1;
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

  void heapify(List<double> list, int n, int i) {
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

          // Recursively heapify the affected sub-tree
          heapify(list, n, largest);
      }
  }


  void merge(List<double> list, int l, int m, int r) {
    int n1 = m - l + 1;
    int n2 = r - m;
    List<List<int>> mks = new List<List<int>>(3);

    List<double> L = new List<double>(n1);
    List<double> R = new List<double>(n2);
    int i, j;
    for (i = 0; i < n1; ++i) {
      mks[0] = new List<int>();
      mks[1] = new List<int>();
      mks[2] = new List<int>();
      mks[2].add(l+i);
      updates.add(new Change(List.from(list), List.from(mks)));
      L[i] = list[l + i];
    }
    for (j = 0; j < n2; ++j) {
      mks[0] = new List<int>();
      mks[1] = new List<int>();
      mks[2] = new List<int>();
      mks[2].add(m+1+j);
      updates.add(new Change(List.from(list), List.from(mks)));
      R[j] = list[m + 1 + j];
    }

    i = 0;
    j = 0;

    int k = l;
    while (i < n1 && j < n2) {
      if (L[i] <= R[j]) {
        mks[0] = new List<int>();
        mks[1] = new List<int>();
        mks[2] = new List<int>();
        mks[2].add(n1);
        mks[1].add(k);
        updates.add(new Change(List.from(list), List.from(mks)));
        list[k] = L[i];
        i++;
        mks[0] = new List<int>();
        mks[1] = new List<int>();
        mks[0].add(k);
        updates.add(new Change(List.from(list), List.from(mks)));
      }
      else {
        List<List<int>> mks = new List<List<int>>(3);
        mks[0] = new List<int>();
        mks[1] = new List<int>();
        mks[1].add(k);
        mks[2] = new List<int>();
        mks[2].add(n2);
        updates.add(new Change(List.from(list), List.from(mks)));
        list[k] = R[j];
        j++;
        mks[0] = new List<int>();
        mks[1] = new List<int>();
        mks[0].add(k);
        updates.add(new Change(List.from(list), List.from(mks))); 
      }
      k++;
    }

    while (i < n1) {
      List<List<int>> mks = new List<List<int>>(3);
      mks[0] = new List<int>();
      mks[1] = new List<int>();
      mks[2] = new List<int>();
      mks[1].add(k);
      mks[2].add(n1);
      updates.add(new Change(List.from(list), List.from(mks)));
      list[k] = L[i];
      i++;
      k++;
      mks[1].clear();
      mks[0].add(k);
      updates.add(new Change(List.from(list), List.from(mks)));
    }
    while (j < n2) {
      List<List<int>> mks = new List<List<int>>(3);
      mks[0] = new List<int>();
      mks[1] = new List<int>();
      mks[2] = new List<int>();
      mks[1].add(k);
      mks[2].add(n2);
      updates.add(new Change(List.from(list), List.from(mks)));
      list[k] = R[j];
      j++;
      k++;
      mks[1].clear();
      mks[0].add(k);
      updates.add(new Change(List.from(list), List.from(mks)));
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
      List<List<int>> mks = new List<List<int>>(3);
      mks[0] = new List<int>();
      mks[1] = new List<int>();
      updates.add(new Change(List.from(list), List.from(mks)));
      int remainingValues = valuesToInsert.length;
      for(int i = 0; i < remainingValues; i++) {
        double value = valuesToInsert.elementAt(0);
        valuesToInsert.removeAt(0);
        int idx = 0;
        while(idx < list.length && list.elementAt(idx) < value) {
          idx++;
        }
        mks[0] = new List<int>();
        mks[1] = new List<int>();
        mks[1].add(idx);
        updates.add(new Change(List.from(list), List.from(mks)));
        list.insert(idx, value);
        mks[0] = new List<int>();
        mks[1] = new List<int>();
        mks[0].add(idx);
        for(int i = idx+1; i < list.length;i++) {
          mks[1].add(i);
        }
        updates.add(new Change(List.from(list), List.from(mks)));
        mks[0] = new List<int>();
        mks[1] = new List<int>();
        updates.add(new Change(List.from(list), List.from(mks)));
      }
      mks[0] = new List<int>();
      mks[1] = new List<int>();
      updates.add(new Change(list, mks));
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

  
  void swap(List list, int i, int j, [List<int> additionalMarkers]) {
    List<List<int>> mk = new List<List<int>>(3);
    mk[0] = new List<int>();
    mk[1] = new List<int>();
    if ( list[i] > list[j] ) {
      mk[0].add(i);
      mk[1].add(j);
    }
    else {
      mk[1].add(i);
      mk[0].add(j);
    }
    if ( additionalMarkers != null ) {
      mk[2] = List.from(additionalMarkers);
    }
    updates.add(new Change(List.from(list), List.from(mk)));
    mk[0] = new List<int>();
    mk[1] = new List<int>();
    double temp = list[i];
    list[i] = list[j];
    list[j] = temp;
    mk[0].add(j);
    mk[0].add(i);
    updates.add(new Change(List.from(list), List.from(mk)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(top:0, left:5, right: 5, bottom: 5),
        child: SizedBox(
          height: MediaQuery.of(context).size.height*0.37,
          child: CustomPaint(
            painter: ShapePainter(values, swapMarkers, _itemCount, _repaint),
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
  List<List<int>> swapMarkers;
  int itemCount;
  ChangeNotifier repaint;

  ShapePainter(List<double> values, List<List<int>> swapMarkers, int itemCount, ChangeNotifier repaint) : super(repaint: repaint) {
    this.values = values;
    this.swapMarkers = swapMarkers;
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
    var swapMarkerPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = fullSize * 0.8
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;
    var swapMarkerSwappedPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = fullSize * 0.8
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;
    var swapMarkerInfoPaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = fullSize * 0.8
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;
    int index = 0;
    while ( index < values.length ) {
      double contHeight = values.elementAt(index)*1.5;
      Offset startingPoint = Offset(_offset, size.height);
      Offset endingPoint = Offset(_offset, size.height-contHeight);
      if ( swapMarkers[0].contains(index) ) {       // green
        canvas.drawLine(startingPoint, endingPoint, swapMarkerPaint);
      }
      else if ( swapMarkers[1].contains(index) ) {  // red
        canvas.drawLine(startingPoint, endingPoint, swapMarkerSwappedPaint);
      }
      else if ( swapMarkers[2] != null && swapMarkers[2].contains(index) ) {  // orange
        canvas.drawLine(startingPoint, endingPoint, swapMarkerInfoPaint);
      }
      else {
        canvas.drawLine(startingPoint, endingPoint, paint);
      }
      _offset += fullSize;
      index++;
    }
    
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}