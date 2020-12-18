import 'package:flutter/material.dart';
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255,4,30,75),
        title: Text(widget.title, style: TextStyle(fontFamily: "Segoe UI", fontWeight: FontWeight.bold, fontSize:45)),
        centerTitle: true,
      ),
        body: Container(
          color:Color.fromARGB(255,7,47,92),
          child:Column(children: [
          DataWidget(),
          OptionsWidget(),
        ],)
      )
    );
  }
}
