import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class barBusca extends StatefulWidget {

  barBusca ();

  @override
  barBuscaState createState() => barBuscaState();

}


class barBuscaState extends State<barBusca> {

  var top=1.0;
  var right=0.0;
  var bottom=0.0;

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(color: Colors.white,boxShadow: [
      BoxShadow(color: Colors.black12,blurRadius: 3.0,offset: Offset(0.0,-2.0,),)
    ],),child:
    Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Expanded ( child:
        TextField(cursorColor: Colors.orange, style: TextStyle(color: Colors.orange),textAlign: TextAlign.end,)),
      Container (width: 40, padding:EdgeInsets.fromLTRB(0, 0, 0, 0), decoration: BoxDecoration( borderRadius: BorderRadius.all(Radius.circular(5))), alignment: Alignment.center, margin: EdgeInsets.fromLTRB(5, 5, 0, 5) ,child:
      Icon(Icons.search,color: Colors.orange)),
    ],)
   ,) ;
  }

}

