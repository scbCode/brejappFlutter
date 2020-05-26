import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firestore/Produto.dart';
import 'package:flutter_firestore/animator.dart';
import 'package:flutter_firestore/distanciaLoja.dart';
import 'package:flutter_firestore/enderecoUser.dart';
import 'package:flutter_firestore/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'Produto_cesta.dart';

typedef refresh = Function();
typedef selectItem = Function(Produto_cesta);

class item_cesta extends StatefulWidget {

  var data;
  refresh refresh_;
  selectItem selectItem_;
  item_cesta (this.data,this.refresh_,this.selectItem_);

  @override
  _itemListProdstate createState() => _itemListProdstate();

}


class _itemListProdstate extends State<item_cesta> with SingleTickerProviderStateMixin {

  AnimationController _controllerIcon;

  bool view_remove=false;
  bool view_remove_decrement=false;
  var color_=Colors.white;

  @override
  Widget build(BuildContext context) {
    return
    GestureDetector(
        onLongPress: (){setState(() {
//          if(view_remove==false){view_remove=true;color_=Colors.red[50];}else {view_remove=false;color_=Colors.white;}
        });},
        onTap: (){setState(() {
          if(view_remove==false){view_remove=true;if (widget.data['quantidade']>1)view_remove_decrement=true;color_=Colors.red[50];
          widget.selectItem_(new Produto_cesta(widget.data));
          }else {view_remove=false;color_=Colors.white;  widget.selectItem_(null);view_remove_decrement=false;}
          //      if(view_remove==true){view_remove=false;color_=Colors.white;}
        });},
        child:
    Row(
      children: <Widget>[

        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
         children: <Widget>[
            Visibility(visible: view_remove,child:
            GestureDetector(onTap: (){
            _removeItemCesta();
            },child:
            Container(
                margin:  EdgeInsets.fromLTRB(20, 0, 0,0),
                decoration: BoxDecoration(color: Colors.white),
                child:Icon(Icons.delete_forever,color: Colors.red,size: 35,)))),

            Visibility(visible: view_remove,child:
           GestureDetector(onTap: (){
              incrementItemCesta_on(widget.data);
           },child:
           Container(
               margin:  EdgeInsets.fromLTRB(20, 0, 0,0),
               child:Icon(Icons.add_box,size: 40,color: Colors.orange)))),
//
           Visibility(visible: view_remove_decrement,child:
           GestureDetector(onTap: (){
             if (widget.data['quantidade'] > 1)
              {setState(() {
                view_remove_decrement=false;
              });
              }
             else
             if (widget.data['quantidade'] == 1)
               setState(() {
                 view_remove_decrement=false;
               });
             decrementItemCesta_on(widget.data);
           },child:
           Container(
               margin:  EdgeInsets.fromLTRB(20, 0, 0,0),
               decoration: BoxDecoration(color: Colors.white),
               child:Icon(Icons.indeterminate_check_box,size: 40,color: Colors.orange)))),

         ]),
        Container(
            margin:  EdgeInsets.fromLTRB(5, 0, 5,0),
            decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.grey)],color:color_),
            padding: EdgeInsets.fromLTRB(10, 5, 10,0),child:
        Row(
          children: <Widget>[

            Column(
              children: <Widget>[

                Row(children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child:
                          RichText(
                              text: TextSpan(
                                  text: widget.data['quantidade'].toString(),
                                  style: TextStyle(fontSize:24,fontFamily: 'BreeSerif',color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(text:"  x  ",
                                        style: TextStyle(fontSize:16,fontFamily: 'BreeSerif'))]))),

                    ],),
                  Container(width: 30,height: 60, padding: EdgeInsets.fromLTRB(0, 0, 0, 0) ,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0), alignment: Alignment.center , child:
                      Image.network(widget.data['img'],
                          fit: BoxFit.cover,alignment: Alignment.center)),
                ],),


                Container(  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),child:
                Text(widget.data['nome'],textAlign: TextAlign.left, style: TextStyle(fontSize:16,fontFamily: 'BreeSerif'))),

                Container(  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),child:
                Text(widget.data['vol'],textAlign: TextAlign.left,
                    style: TextStyle(fontSize:12,fontFamily: 'RobotoLight'))),
                Container(height: 12, margin: EdgeInsets.fromLTRB(0, 5, 0, 0),child: Text(_FormatPreco(widget.data['preco'],widget.data['quantidade']), style: TextStyle(fontSize:12,fontFamily: 'RobotoLight'))),

              ],),

          ],)

        )],));


  }


  void incrementItemCesta_on(var item) async{

    Produto_cesta  p =Produto_cesta(item);
    p.quantidade+=1;
    print(p.quantidade);
    setState(() {
      if (p.quantidade>1)
        view_remove_decrement=true;
      else
        {
          print("INCREMENT "+p.quantidade.toString());
          view_remove_decrement=false;
        }
    });

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user!=null)
      await Firestore.instance.collection("Usuarios")
          .document(user.uid).collection("cesta").document(p.id).updateData(p.getproduto());
  }

  void decrementItemCesta_on(var item) async{

    Produto_cesta  p =Produto_cesta(item);
    p.quantidade-=1;

    setState(() {
        print("DEINCREMENT "+p.quantidade.toString());
        if (p.quantidade>1)
          view_remove_decrement=true;
          else{
          print("DEINCREMENT "+p.quantidade.toString());
          view_remove_decrement=false;}
      });

     FirebaseUser user = await FirebaseAuth.instance.currentUser();
        if (user!=null)
          await Firestore.instance.collection("Usuarios")
              .document(user.uid).collection("cesta").document(p.id).updateData(p.getproduto());
   }



  _FormatPreco(var preco,var quantidade){

    var totalPrecotxt=preco * quantidade;
    var p = totalPrecotxt.toString();

    if (p.length<=2)
      p = p+",00";
    if (p.contains("."))
      p="R\u0024 "+p.replaceAll(".", ",");
    if (p.length==3)
      p+="0";

    p= "R\u0024 "+ p;

    return p;
  }

  _removeItemCesta() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user!=null)
      await Firestore.instance.collection("Usuarios")
          .document(user.uid).collection("cesta").document(widget.data['id']).delete();
  }




  @override
  void initState() {

    super.initState();
  }


}

