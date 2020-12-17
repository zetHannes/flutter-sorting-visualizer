
import 'dart:math';

import 'package:flutter/material.dart';
class DataWidget extends StatefulWidget {
  DataWidget({Key key}) : super(key: key);

  @override
  _DataWidgetState createState() => _DataWidgetState();
}

class _DataWidgetState extends State<DataWidget> {


  @override
  Widget build(BuildContext context) {
    Random rand = new Random();
    return Column(children: [
      Padding(
        padding: EdgeInsets.all(5),
        child: SizedBox(
          height: MediaQuery.of(context).size.height*0.37,
          child: Row(
            children: [
            ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: 13,
              itemBuilder: (BuildContext ctxt, int index) {
                double fullSize = (MediaQuery.of(context).size.width-10)/13;
                double contHeight = rand.nextDouble()*200;
                print(fullSize.toString() + " , " + contHeight.toString());
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
    ],);
  }
}
