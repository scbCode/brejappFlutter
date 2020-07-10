import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firestore/animMarcasHome.dart';
import 'package:flutter_firestore/perfil_loja.dart';
import 'package:page_transition/page_transition.dart';

import 'animator.dart';

class itemListLojas extends StatefulWidget {

  DocumentSnapshot snapshot;
  var listaMarcas= [];

  itemListLojas (this.snapshot, this.listaMarcas);


  @override
  itemListLojasState createState() => itemListLojasState();

}


class itemListLojasState extends State<itemListLojas> {

  AnimationController c;
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    return
      GestureDetector(
          onTap: (){
            setState((){
              _perfil(context);
            });
          },
          child:
          Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      blurRadius: 3.0,
                      offset: Offset(
                        0.0, // horizontal, move right 10
                        0.25, // vertical, move down 10
                      ),
                    )
                  ],
                  color: Colors.white
              ),
              child:

              Column(children: <Widget>[
                Row(children: <Widget>[

                      Container(
                          margin: EdgeInsets.all(5),
                          child:
                          Stack(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container( margin:EdgeInsets.fromLTRB(10, 5, 0, 0),child:Text(widget.snapshot["nome"],textAlign: TextAlign.left, style: TextStyle(fontSize:16,fontFamily: 'BreeSerif'))),
                                  Container( margin:EdgeInsets.fromLTRB(10, 5, 0, 0),child:
                                  Image.network(widget.snapshot["url"],width: 30,height: 30,)),
                                ],),
                            ],)),
                ],),
              ],)
          ));

  }

  _perfil(context){
    Navigator.push(
      context,
      PageTransition(
        curve: Curves.bounceIn,
        duration: Duration(milliseconds:500),
        alignment: Alignment.center,
        type: PageTransitionType.leftToRight,
        child: perfil_loja(widget.snapshot["idloja"]),
      ),
    );
  }

}

