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

                  Container(margin: EdgeInsets.fromLTRB(10, 5, 0, 0), alignment: Alignment.centerRight , child:
                  Image.network(widget.snapshot["url"])),

                      Container(
                          margin: EdgeInsets.all(5),
                          child:
                          Stack(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(width: 170, margin:EdgeInsets.fromLTRB(10, 8, 0, 0),child:Text(widget.snapshot["nome"],textAlign: TextAlign.left, style: TextStyle(fontSize:16,fontFamily: 'BreeSerif'))),
                                  Row (mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(margin: EdgeInsets.fromLTRB(10, 5, 5, 0), decoration: BoxDecoration(color:Colors.orange,borderRadius: BorderRadius.all(Radius.circular(20))),width: 5,height: 5,),
                                      Container(margin: EdgeInsets.fromLTRB(0, 5, 0, 0), child:  Text("11.8km ",style: TextStyle(color: Colors.grey[500],fontSize: 13,fontFamily: 'RobotoLight'),)),
                                      Container(margin: EdgeInsets.fromLTRB(10, 5, 5, 0), decoration: BoxDecoration(color:Colors.orange,borderRadius: BorderRadius.all(Radius.circular(20))),width: 5,height: 5,),
                                      Container(margin: EdgeInsets.fromLTRB(0, 5, 0, 0), child:  Text("Frete: ",style: TextStyle(color: Colors.grey[500],fontSize: 13,fontFamily: 'RobotoLight'),)),

                                    ],),
                                  Row (mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                           ],),
                                    Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                            color: Colors.white, boxShadow: [
                                          BoxShadow(
                                            color: Colors.orange[200],
                                            blurRadius: 0.50,
                                            offset: Offset(
                                              0.0, // horizontal, move right 10
                                              0.5, // vertical, move down 10
                                            ),
                                          )
                                        ]),
                                        margin: EdgeInsets.fromLTRB(10, 8, 0, 0),height: 43,width: 170, child:
                                    ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: widget.listaMarcas.length,
                                          itemBuilder: (context, index) {

                                              return
                                                      Column(children: <Widget>[
                                                      Container(height: 25 , child:
                                                        Image.network(widget.listaMarcas[index])),
                                            Container( child:
                                                  Text("R\u00242,99", style: TextStyle(fontFamily: 'BreeSerif' ,fontSize: 8,color: Colors.orange,letterSpacing: 1),)
                                            )
                                              ],)
                                              ;
                                          }
                                  ,))

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

