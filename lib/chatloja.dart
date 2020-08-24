
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firestore/barNavBottom.dart';
import 'package:flutter_firestore/itemListProd.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'BlocAll.dart';
import 'Bloc_finaceiro.dart';
import 'Produto_cesta.dart';
import 'enderecoUser.dart';
import 'headCurve.dart';
import 'itemListLojas.dart';


typedef closePerfil =  Function();
typedef sendItemCesta = Produto_cesta Function(Produto_cesta);

class chatloja extends StatefulWidget {

  var idloja;
  var idPedido;
  var nome;
  var email;
  var uid;
  closePerfil close;
  chatloja(this.uid,this.nome,this.email,this.idloja,this.idPedido,this.close );

  Stream<QuerySnapshot> ref = Firestore.instance
      .collection("Perfil_lojas").where("nome", isEqualTo :"")
      .snapshots();

  @override
  chatlojaState createState() => chatlojaState();

}

class chatlojaState extends State<chatloja> {
  TextEditingController control_chattext = new TextEditingController();
  var bloc_financeiro = Bloc_financeiro();


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return
      Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body:

            LimitedBox(maxHeight: MediaQuery.of(context).size.height,child:
            SingleChildScrollView(child:
                Container(decoration: BoxDecoration(color: Colors.transparent), child:
            Stack(children: <Widget>[

                SingleChildScrollView(
                child:
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[


                      LimitedBox(maxHeight: MediaQuery.of(context).size.height-50, child:
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          decoration:BoxDecoration(
                              boxShadow: [BoxShadow(color:Colors.black45)],
                              borderRadius: BorderRadius.all(Radius.circular(2))),
                          child:
                          Container(
                              height: MediaQuery.of(context).size.height,
                              margin: EdgeInsets.fromLTRB(0, 0, 0,0),
                              child:
                              ClipRect(
                                  child:  BackdropFilter(
                                      filter:  ImageFilter.blur(sigmaX:2, sigmaY:2),
                                      child:
                                      Container(
                                          width: double.infinity,
                                          decoration:  BoxDecoration(color: Colors.transparent),
                                          child:
                                          SingleChildScrollView(
                                              child:
                                              Column (
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children:[

                                                    Row (
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children:[

                                                          GestureDetector(
                                                              onTap:(){
                                                                widget.close();
                                                              },
                                                              child:
                                                          Container (
                                                              margin: EdgeInsets.fromLTRB(20, 30, 0, 10),
                                                              child:Icon(Icons.arrow_back
                                                                  ,size: 30,color:Colors.white))),
                                                          Container (
                                                              margin: EdgeInsets.fromLTRB(25, 30, 0, 10),
                                                              child:
                                                              Text("Chat",style: TextStyle(
                                                                  fontSize:35,fontFamily: 'BreeSerif',color:Colors.white),)),
                                                        ]),

                                                    Container (
                                                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                        height: MediaQuery.of(context).size.height-150,
                                                        child:
                                                        listaChat_(widget.idPedido)
                                                    ),
                                                  ]))
                                      ))))),
                      ),

                      Container(
                          decoration:BoxDecoration(color:Colors.orange,
                              borderRadius: BorderRadius.all(Radius.circular(2))),
                          child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                              children:[
                                Container(
                                    margin:EdgeInsets.fromLTRB(5,0,0,0),
                                    width: MediaQuery.of(context).size.width-75
                                    ,child:
                                TextField (
                                  controller: control_chattext,
                                  cursorColor: Colors.white,cursorRadius: Radius.circular(20),
                                  style: TextStyle(color:Colors.white,fontFamily: 'BreeSerif'),
                                  decoration: InputDecoration(hintText: "Digite uma menssagem...",
                                      focusColor: Colors.white,
                                      hintStyle: TextStyle(color:Colors.white) ),)),

                                GestureDetector(
                                    onTap:(){
                                      bloc_financeiro.enviarMsgChat(control_chattext.text,widget.email, widget.uid, "user", widget.idloja,  widget.idPedido,"" ,widget.nome);
                                      control_chattext.text="";
                                    },child:
                                Icon(Icons.send,color:Colors.white,size: 35,)),
                              ]),
                      ),



                    ]))





                    ]))),)

    );
  }

  _barTop(){
    return Column(children: <Widget>[
      Container( height: 24,decoration: BoxDecoration(color: Colors.orange[300]),),
    ],);
  }

  listaChat_(var idPedido){

      return

        StreamBuilder(
            stream: Firestore.instance.collection('Usuarios').document(widget.uid)
                .collection("Pedidos").document(widget.idPedido)
                .collection("chat").orderBy("time",descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState==ConnectionState.active){
                return
                  ListView.builder(
                    padding: EdgeInsets.all(0.0),
                      reverse:true,
                      shrinkWrap: true,
                      primary: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data.documents[index]['remetente']!="user" && snapshot.data.documents[index]['remetente']!="user-auto-pedidoErrado")
                          return
                            Container(
                                margin:EdgeInsets.fromLTRB(50, 0,0, 10),
                                alignment: Alignment.centerRight,
                                child:
                                Container(
                                    decoration:BoxDecoration(color:Colors.red,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      boxShadow: [BoxShadow(color:Colors.white,blurRadius: 4,offset: Offset(0,1))],),
                                    padding:EdgeInsets.fromLTRB(20,15, 20, 15),
                                    margin:EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child:
                                    Text(snapshot.data.documents[index]['msg'],
                                      style: TextStyle(color:Colors.white,fontFamily: 'BreeSerif'),)));
                        else
                        if (snapshot.data.documents[index]['remetente']=="user-auto-pedidoErrado")
                          return
                            LimitedBox(maxWidth:MediaQuery.of(context).size.width,child:
                            IntrinsicWidth(child:
                            Container(
                                margin:EdgeInsets.fromLTRB(5, 0, 0, 10),
                                alignment: Alignment.center,
                                child:  Container(
                                    decoration:BoxDecoration(color:Colors.yellow,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),),
                                    padding:EdgeInsets.fromLTRB(20,15, 20, 15),
                                    margin:EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child:
                                    Text(""+
                                        snapshot.data.documents[index]['msg'],style: TextStyle(fontFamily: 'BreeSerif',fontSize: 16),))
                            )));
                        else
                          return
                            LimitedBox(maxWidth:MediaQuery.of(context).size.width*.8,child:
                            Container(
                                margin:EdgeInsets.fromLTRB(0, 0, 50, 10),
                                alignment: Alignment.centerLeft,
                                child:  Container(
                                    decoration:BoxDecoration(color:Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      boxShadow: [BoxShadow(color:Colors.grey[200],blurRadius: 1,offset: Offset(0,1))],),
                                    padding:EdgeInsets.fromLTRB(20,15, 20, 15),
                                    margin:EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child:
                                    Text(snapshot.data.documents[index]['msg'],style: TextStyle(fontFamily: 'BreeSerif'),))));
                      });

              }else
                return Container();
            });
  }




  @override
  void initState() {
    super.initState();
  }



}




