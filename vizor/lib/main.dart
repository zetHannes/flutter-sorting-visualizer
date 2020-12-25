import 'package:flutter/material.dart';
import 'package:vizor/arraySizeWidget.dart';
import 'package:vizor/dataWidget.dart';
import 'package:vizor/optionsWidget.dart';
void main() {
  runApp(VizorApp());
}

class VizorApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vizor',
      home: SortingPage(title: 'Vizor'),
    );
  }
}

class SortingPage extends StatefulWidget {
  SortingPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SortingPageState createState() => _SortingPageState();
}

class _SortingPageState extends State<SortingPage> {

  void finish() {
    setState(() {
      buttonText = "Reset Data";
      started = false;
      finished = true;
      _optionsWidgetKey.currentState.finish();
    });
  }

  void changeSelection(int value) {
    _dataWidgetKey.currentState.generateNewData(value);    
  }

  void sort() {
      _optionsWidgetKey.currentState.prepareSortingVisualization();
      _dataWidgetKey.currentState.sort(_dataWidgetKey.currentState.modeBubbleSort);
  }
  GlobalKey<OptionsWidgetState> _optionsWidgetKey = GlobalKey();
  GlobalKey<DataWidgetState> _dataWidgetKey = GlobalKey();
  bool started = false;
  bool finished = false;
  String buttonText = "Start";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255,4,30,75),
        title: Text(widget.title, style: TextStyle(fontFamily: "SegoeUI", fontStyle: FontStyle.italic, fontSize:45)),
        centerTitle: true,
      ),
        body: Container(
          color:Color.fromARGB(255,7,47,92),
          child:Column(children: [
          DataWidget(key: _dataWidgetKey, onFinish: finish,),
          OptionsWidget(key: _optionsWidgetKey, onSelectionChanged: changeSelection,),
          ( !finished ) ? 
            Padding(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    // user clicks on "Stop"
                    if ( buttonText == "Stop" ) {
                        _dataWidgetKey.currentState.stop();     
                        buttonText = "Resume"; 
                    }
                    // user clicks on "Start"
                    else if ( buttonText == "Start" ) {
                      finished = false;
                      sort();
                      buttonText = "Stop";
                    }
                    // user clicks on "Resume"
                    else {
                      sort();
                      buttonText = "Stop";
                    }
                  });
                },
                textColor: Colors.white,
                color: 
                  ( buttonText == "Start" || buttonText == "Resume" ) ? Color.fromARGB(255,0,167,40) : Color.fromARGB(255,255,0,0),            
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  width: MediaQuery.of(context).size.width-20,
                  child: Center(
                    child: Text(
                      buttonText, style: TextStyle(fontFamily: "SegoeUI", fontSize:30)
                    )
                  ),
                )
              )
            )
          : 
            Container(),

          ( buttonText == "Resume" || finished ) ? 
            // Reset Data Button
            Padding(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                onPressed: () {
                  // resets the data and the state goes back to startup(user can start the visualization).
                  setState(() {
                      _dataWidgetKey.currentState.generateNewData(_optionsWidgetKey.currentState.getArraySize());      
                      buttonText = "Start";   // top button shall become the "Start" button again
                      finished = false;   // button shall disappear after click
                      _optionsWidgetKey.currentState.finish();
                  });
                },
                textColor: Colors.white,
                color: Color.fromARGB(255,0,104,124),            
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0)
                    ),
                    width: MediaQuery.of(context).size.width-20,
                    child: Center(
                      child: Text(
                        "Reset Data", style: TextStyle(fontFamily: "SegoeUI", fontSize:30)
                      )
                    ),
                  )
                )
              ) 
            : 
              Container(),

          ],
        )
      )
    );
  }

}
