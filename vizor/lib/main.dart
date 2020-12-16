import 'package:flutter/material.dart';

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
        title: Text(widget.title),
      ),
      body: Column(children: [],)
    );
  }
}
