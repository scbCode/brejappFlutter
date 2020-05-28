import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firestore/User.dart';
import 'package:flutter_firestore/barCurve.dart';
import 'package:flutter_firestore/distanciaLoja.dart';
import 'package:flutter_firestore/enderecoUser.dart';
import 'package:flutter_firestore/enderecoUserSnapShot.dart';
import 'package:flutter_firestore/form_endereco_user.dart';
import 'package:flutter_firestore/headCurve.dart';
import 'package:flutter_firestore/itemListLojas.dart';
import 'BlocAll.dart';
import 'dart:ui';
import 'dart:async';

import 'Loja.dart';
import 'Produto_cesta.dart';
import 'item_cesta.dart';


typedef show_blur_bg =  Function(bool);

class barCesta extends StatefulWidget  {

  List<Produto_cesta> listaCesta = new List<Produto_cesta>();
  distanciaLoja listaDistancia_ ;
  show_blur_bg call_back_show_bg;
  var user;
  barCesta (this.user,this.listaCesta,this.listaDistancia_,this.call_back_show_bg);

  @override
  barCestaState createState() => barCestaState();

}


class barCestaState extends State<barCesta> with SingleTickerProviderStateMixin {

  var top=1.0;
  var right=0.0;
  var bottom=0.0;
  var qntdItens=0.0;
  var qntdItenstxt="";
  var view_remove=false;
  var totaltxt="";
  var total=0.0;
  double initial=0.0;
  var bloc = BlocAll();
  var view_resumo_cesta=false;
  var view_cestadetalhes=false;
  var view_form_end=false;
  Produto_cesta selecionado;
  var listaCesta_;
  var ctrolControls=false;
  var alturaBarra=0.0;
  var barra_;
  var cor_endereco=Colors.white;
  var ctrol_view_btnEnd=true;
  var confirmarEndereco=false;
  var confirmarEnderecoviewbtn=false;
  var bttmResumo=0.0;
  var iconCheckPagamento=Icons.radio_button_unchecked;
  var tipoPagSelectItem;
  enderecoUserSnapShot end_user;
  enderecoUser end_user_;
  var view=false;
  var user;
  var cartao = false;
  var maquina = false;
  double distance=0.0;

  var enderecoTemp_=false;

  @override
  Widget build(BuildContext context) {
    _checkreresult();
    if (widget.listaCesta!=null)
    if (widget.listaCesta.length==0)
      widget.call_back_show_bg(false);


    if (confirmarEndereco==false){
      cor_endereco=Colors.white;
    }else
      {
        cor_endereco=Colors.amber[100];
      }

    if (widget.listaCesta[0].cartaoApp!=null)
      setState(() {
        cartao = widget.listaCesta[0].cartaoApp;
      });
    if (widget.listaCesta[0].maquinaCartao!=null)
     setState(() {
       maquina = widget.listaCesta[0].maquinaCartao;
     });

    return
        Visibility(visible: view,child:
            barCompleta());

  }

  barCompleta(){
return
//Container(decoration: BoxDecoration(color: Colors.transparent),child:
    SingleChildScrollView(child:
    Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[

          Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container( decoration: BoxDecoration(color: Colors.transparent,boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 0.0,
                    offset: Offset(
                      0.0, // horizontal, move right 10
                      0.0, // vertical, move down 10
                    ),
                  )
                ]),height: 45,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, alturaBarra),
                    child:
                    barra()
                ),
                //////////////////////////////////////////////////////////
                LimitedBox(maxHeight:MediaQuery.of(context).size.height*.7,child:
                SingleChildScrollView(child:

                Visibility(visible:view_resumo_cesta, child:
                Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, bttmResumo),
                    decoration: BoxDecoration(color: Colors.white,boxShadow: [
                      BoxShadow( color: Colors.black12,blurRadius:4.0,
                        offset: Offset(0.0,45.0,  ),)
                    ],),
                    child:
                    Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(color: Colors.white),
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child:
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Container(margin: EdgeInsets.fromLTRB(0, 0, 5, 0), decoration: BoxDecoration(color:Colors.orange,borderRadius: BorderRadius.all(Radius.circular(20))),width: 5,height: 5,),
                                Container(alignment: Alignment.centerLeft,margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child:Text(widget.listaCesta[0].loja.toString().toUpperCase()+" ",textAlign: TextAlign.right, style: TextStyle(color: Colors.black ,fontSize:14,fontFamily: 'BreeSerif'))),
                                Container(margin: EdgeInsets.fromLTRB(5, 0, 0, 0), decoration: BoxDecoration(color:Colors.orange,borderRadius: BorderRadius.all(Radius.circular(20))),width: 5,height: 5,),
//                       Container(margin: EdgeInsets.fromLTRB(10, 5, 0, 0), child:  Text("Frete: R\u0024 3,00 ",style: TextStyle(color: Colors.black54,fontSize: 14,fontFamily: 'BreeSerif')),),
//                       Container(margin: EdgeInsets.fromLTRB(5, 5, 5, 0), decoration: BoxDecoration(color:Colors.orange,borderRadius: BorderRadius.all(Radius.circular(20))),width: 5,height: 5,),
                                //   Container(alignment: Alignment.centerLeft,margin: EdgeInsets.fromLTRB(0, 4, 5, 0), child:Text( formatDistancia(),textAlign: TextAlign.right, style: TextStyle(color: Colors.black54,fontSize:14,fontFamily: 'BreeSerif'))),
                              ],),
                          ),

                          Divider(color: Colors.black45,height: 2,),

                          Container(
                              margin: EdgeInsets.fromLTRB(0, 10,0, 5),
                              alignment: Alignment.topCenter, child: listaCesta_),

                          Visibility(visible: !view_cestadetalhes,child:
                          GestureDetector(onTap: (){
                            setState(() {

                              if (view_cestadetalhes)
                                view_cestadetalhes=false;
                              else
                                view_cestadetalhes=true;
                            });
                          },
                            child:
                            Container(
                                width: MediaQuery.of(context).size.width*0.5,
                                decoration: BoxDecoration(border: Border.all(color: Colors.orange[200]), borderRadius: BorderRadius.all(Radius.circular(5))),
                                margin: EdgeInsets.fromLTRB(0, 10,0, 10),
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                alignment: Alignment.topCenter, child:
                            Text("Fazer pedido",style:
                            TextStyle(color: Colors.orange,fontFamily: 'RobotoLight'),)),)),
//
                          Visibility(visible: view_cestadetalhes,child:
                          GestureDetector(onTap: (){
                            setState(() {
                              if (view_cestadetalhes)
                                view_cestadetalhes=false;
                              else
                                view_cestadetalhes=true;
                            });
                          },
                            child:
                            Container(
                                width: 100,
                                margin: EdgeInsets.fromLTRB(0, 5,0, 0),
                                alignment: Alignment.topCenter, child:
                            Icon(Icons.keyboard_arrow_up,color:Colors.orange)),)),

                          Visibility(visible:view_cestadetalhes, child:
                          Column(
                              children: <Widget>[
                                Divider(color: Colors.orange,height: 2,),

                                //END ENTREGA TEXT
                                Container(
                                    padding: EdgeInsets.fromLTRB(10,10,0,0),
                                    alignment: Alignment.centerLeft,
                                    child: Text("TOTAL + FRETE: "+totalComFrete()
                                      ,textAlign: TextAlign.center,style: TextStyle(fontSize: 19,fontFamily: 'BreeSerif',color: Colors.orange),)),

                                Container(
                                    padding: EdgeInsets.fromLTRB(13,5,0,10),
                                    alignment: Alignment.centerLeft,
                                    child: Text("FRETE: "+formatFrete() ,style:
                                    TextStyle(fontStyle: FontStyle.italic,fontSize: 14,fontFamily:'RobotoRegular',color: Colors.black54),)),

                                Divider(color:Colors.grey),

                                Container(
                                    margin: EdgeInsets.fromLTRB(10, 0,0,10),
                                    alignment: Alignment.center, child:
                                Text("ENDEREÇO DE ENTREGA ",style:
                                TextStyle(color: Colors.black87,fontSize: 14,fontFamily: 'RobotoLight'),)),

                              Container(
                                  margin: EdgeInsets.fromLTRB(10, 0,0,10),
                                  alignment: Alignment.center, child:
                                StreamBuilder(
                                    stream: Firestore.instance.collection('Usuarios').document(widget.user.uid)
                                        .collection("endereco").where("temp",isEqualTo: false).snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState==ConnectionState.active){
                                        if (snapshot.data.documents.length > 0) {
                                          enderecoTemp_=false;
                                          return
                                            enderecoUserView(snapshot.data.documents[0]);
                                        }
                                        else{
                                          return
                                            StreamBuilder(
                                                stream: Firestore.instance.collection('Usuarios').document(widget.user.uid)
                                                    .collection("endereco").where("temp",isEqualTo: true).snapshots(),
                                                builder: (context, snapshot1) {
                                                  if (snapshot1.connectionState==ConnectionState.active){
                                                    if (snapshot1.data.documents.length > 0) {
                                                      enderecoTemp_=true;
                                                      return
                                                        enderecoTemp(snapshot1.data.documents[0]);
                                                    }else
                                                      return Container();
                                                  }else
                                                    return Container();
                                                });
                                        }
                                      }else
                                        return Container();
                                    })),

                                Visibility(
                                    visible: ctrol_view_btnEnd,
                                    child:

                                    GestureDetector(onTap: (){
                                      setState(() {
                                        confirmarEndereco=true;
                                        ctrol_view_btnEnd=false;
                                      });
                                    },
                                      child:
                                      Container(
                                          decoration: BoxDecoration(border: Border.all(color: Colors.orange[200]), borderRadius: BorderRadius.all(Radius.circular(5))),
                                          margin: EdgeInsets.fromLTRB(40, 5, 40, 30),
                                          padding: EdgeInsets.fromLTRB(0, 10, 0,10),
                                          alignment: Alignment.topCenter, child:
                                      Text("CONFIRMAR ENDEREÇO",textAlign: TextAlign.center,style:
                                      TextStyle(color: Colors.orange,fontFamily: 'RobotoBold'),)),)),

                              ])),

                          Visibility(visible: confirmarEndereco,child:
                          Column(children: <Widget>[
                            Container(
                                margin: EdgeInsets.fromLTRB(10, 10,0,10),
                                alignment: Alignment.center, child:
                            Text("PAGAMENTO",style:
                            TextStyle(color: Colors.black87,fontSize: 14,fontFamily: 'RobotoLight'),)),
                                pagamentoDinheiro(),
                            Visibility(visible: maquina,
                                child:formaPagMaquina()),
                            Visibility(visible:cartao,
                                child:pagamentoCartaoItem()
                               ),
                                pagamentoCartaoVazio(),
                          ]))
                        ])
                )
                )),),

              ]),


          Visibility(child:
            formularioEndereco(),visible: view_form_end,),

        ]));
  }


  @override
  void initState() {

    getUseruid();
    bloc.getEnderecoUser();
    listaCesta_=listaCesta();
    if (widget.listaCesta.length==0)
    widget.call_back_show_bg(false);

    super.initState();
  }


  void getDadosUser(var uid) async {

    var user = await FirebaseAuth.instance.currentUser();

    var document = await Firestore.instance.collection('Usuarios').document(user.uid);
    document.snapshots()
        .listen((data) => {
      getUser(data,data.documentID)
    });

  }


  void getUser(var data,var documentID){
    user = new User(data['nome'],data['tell'],data['email'],data['uid'],data['localizacao']);
   setState(() {
     view=true;
     print("USER X "+data['uid'].toString());

   });
  }



  getUseruid() async {
    var userx = await FirebaseAuth.instance.currentUser();
    getDadosUser(userx.uid);
  }


  enderecoUserView(var data){
    end_user = new enderecoUserSnapShot(data);
    end_user_ =  new enderecoUser(data['rua'],data['bairro'],data['numero'],data['complemento'],data['localizacao'],data['temp']);
    print("ENDERECO COMP "+end_user_.localizacao.latitude.toString());
      return
                       Container(
                           margin: EdgeInsets.fromLTRB(15, 10, 15, 20),
                           decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)],color:cor_endereco),
                           child:

                           Column(

                             children: <Widget>[


                           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max, children: <Widget>[

                             Container(
                               margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                               child:
                               Icon(Icons.location_searching,size: 20,),),

                             Column(
                               mainAxisSize: MainAxisSize.max,
                               children: <Widget>[

                                 Container(
                                     width: MediaQuery.of(context).size.width*.54,
                                     margin: EdgeInsets.fromLTRB(10, 5,0, 0),
                                     alignment: Alignment.center, child:
                                 Text(data['rua']+", "+data['bairro'], maxLines: 1,
                                  overflow: TextOverflow.ellipsis,style:
                                 TextStyle(color: Colors.black87,fontFamily: 'RobotoLight'),)),

                                 Container(
                                     margin: EdgeInsets.fromLTRB(0, 0,0, 5),
                                     alignment: Alignment.centerLeft, child:
                                 Text("Nº "+data['numero']+", "+data['complemento'],style:
                                 TextStyle(color: Colors.black45,fontFamily: 'RobotoLight'),)),

                             ],),

                              Visibility(visible:true,child:
                              GestureDetector(onTap: (){
                                setState(() {
                                view_form_end=true;
                                ctrol_view_btnEnd=true;
                                confirmarEndereco=false;
                                }); },child:
                             Container(
                                 margin: EdgeInsets.fromLTRB(0, 5,10, 5),
                                 alignment: Alignment.center, child:
                             Text("Atualizar",style:
                             TextStyle(color: Colors.red,fontFamily: 'RobotoLight'),)))),
                           ],),

                    ],));
  }


  enderecoTemp(var data)
  {
    end_user = new enderecoUserSnapShot(data);
    end_user_ =  new enderecoUser(data['rua'],data['bairro'],data['numero'],data['complemento'],data['localizacao'],data['temp']);
    print("ENDERECO COMP "+end_user_.complemento);
    return
    Column(children: <Widget>[
      Container(
          margin: EdgeInsets.fromLTRB(15, 10,0, 0),
          alignment: Alignment.centerLeft, child:
      Text("Endereço automatico",style:
      TextStyle(color: Colors.grey,fontFamily: 'RobotoLight'),)),

      Column(

        children: <Widget>[

          Container(
              margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)],color:Colors.white),
              child:


              Row(mainAxisAlignment: MainAxisAlignment.start,mainAxisSize: MainAxisSize.max, children: <Widget>[

                Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child:
                  Icon(Icons.location_searching,size: 20,),),


                Column(

                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width*0.7,
                        margin: EdgeInsets.fromLTRB(20, 10,0, 10),
                          alignment: Alignment.centerLeft, child:
                            Text(data['rua']+", "+data['bairro'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                          TextStyle(color: Colors.black87,fontFamily: 'RobotoLight'),)),


                  ],),

              ],)),
          Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
              margin: EdgeInsets.fromLTRB(15, 15, 15, 10),
              decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)],color:Colors.white),
              child:
              Row(mainAxisAlignment: MainAxisAlignment.center,mainAxisSize: MainAxisSize.max, children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    GestureDetector(onTap: (){setState(() {
                      view_form_end=true;
                    }); },child:
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 5,0, 0),
                        alignment: Alignment.center, child:
                    Text("COMPLETAR ENDEREÇO",style:
                    TextStyle(color: Colors.orange,fontFamily: 'RobotoLight'),))),
                  ],),
              ],)),
        ],),

    ],);
  }



  formaPagMaquina()
  {
    return
      GestureDetector(
          onTap: (){setState(() {
            iconCheckPagamento=Icons.radio_button_checked;
          });},
          child:
          Column(children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)],color:Colors.white),
                    child:
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max, children: <Widget>[
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max, children: <Widget>[
                        Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Image.asset("card_machine.png",width: 40,height: 40)),
                        Container(
                            margin: EdgeInsets.fromLTRB(25, 10,0, 10),
                            alignment: Alignment.center, child:
                        Text("Máquina de cartão",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                          TextStyle(color: Colors.black87,fontFamily: 'RobotoLight'),)),
                      ],),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child:Icon(iconCheckPagamento,color: Colors.orange,),),
                    ],)),

              ],),

          ],));
  }


  pagamentoDinheiro()
  {
    return
    GestureDetector(
        onTap: (){setState(() {
          iconCheckPagamento=Icons.radio_button_checked;
        });},
        child:
      Column(children: <Widget>[
        Column(
      mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)],color:Colors.white),
                child:
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max, children: <Widget>[
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max, children: <Widget>[

                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Image.asset("money.png",width: 50,height: 50)),
                      Container(
                          margin: EdgeInsets.fromLTRB(25, 10,0, 10),
                          alignment: Alignment.center, child:
                      Text("Dinheiro",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                        TextStyle(color: Colors.black87,fontFamily: 'RobotoLight'),)),


                      Container(
                          width: 80,
                          margin: EdgeInsets.fromLTRB(10, 0,0, 0),
                          alignment: Alignment.center, child:
                      TextFormField(
                        decoration: InputDecoration.collapsed(
                          hintText: 'Troco:'
                          ),
                        keyboardType:  TextInputType.number,
                        style:
                        TextStyle(color: Colors.black87,fontFamily: 'RobotoLight'),)),
                  ],),
                  Container(
                     margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                     child:Icon(iconCheckPagamento,color: Colors.orange,),),
                ],)),

          ],),

      ],));
  }

  callTokenrizarCartao() async {
    print("callTokenrizarCartao");
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'criarToken',
    );
    dynamic resp = await callable.call(<String, dynamic>{
      'YOUR_PARAMETER_NAME': 'YOUR_PARAMETER_VALUE',
    });
    print("callTokenrizarCartaofinal");

  }


  pagamentoCartaoVazio()
  {
    return
    GestureDetector(onTap:(){callTokenrizarCartao();} ,child:
      Column(children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 30),
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)],color:Colors.white),
                child:
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max, children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child:
                      Icon(Icons.credit_card,size: 30,color: Colors.grey,),),

                    Container(
                        margin: EdgeInsets.fromLTRB(25, 10,0, 10),
                        alignment: Alignment.center, child:
                    Text("Adicionar cartão",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                      TextStyle(color: Colors.black87,fontFamily: 'RobotoLight'),)),
                  ],),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child:Icon(Icons.playlist_add,color: Colors.grey,),),
                ],)),

          ],),

      ],));
  }


  pagamentoCartaoItem()
  {
    return
      Column(children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)],color:Colors.white),
                child:

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max, children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child:
                      Image.asset("cardcredit.png",width: 40,height: 60,)),

                    Container(
                        margin: EdgeInsets.fromLTRB(25, 10,0, 10),
                        alignment: Alignment.center, child:
                    Text("Master **** 4444",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                      TextStyle(color: Colors.black87,fontFamily: 'RobotoLight'),)),
                  ],),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child:Icon(iconCheckPagamento,color: Colors.orange,),),
                ],)),

          ],),

      ],);
  }


  formularioEndereco(){

    return
      Container( width: double.infinity,height: MediaQuery.of(context).size.height*0.7,
          child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0,0.2),   child:
      ClipRect(
        child:  BackdropFilter(
        filter:  ImageFilter.blur(sigmaX:2, sigmaY:2),
        child:  Container(
          decoration:  BoxDecoration(color: Colors.white.withOpacity(.20)),
          child:
          Container(
            padding: EdgeInsets.fromLTRB(30, 0, 30,10),
            child:Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[

              form_endereco_user(end_user_,null,(){desativarFormEndereco();})
//              Container(padding: EdgeInsets.fromLTRB(20, 10, 20, 10), margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
//                  decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.all(Radius.circular(5)),boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 3,offset: Offset(0,3))]), child:
//              Text("ENDEREÇO DE ENTREGA",style: TextStyle(color: Colors.orange,fontSize: 14,fontFamily: 'RobotoBold'),)),
//              Container(
//                height: 50,
//                padding: EdgeInsets.all(5),
//                  decoration: BoxDecoration(color:Colors.white
//                      ,borderRadius: BorderRadius.all(Radius.circular(5)),
//                      boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 3,offset: Offset(0,3))]),
//                  child:
//              TextFormField())

            ],)
          ),


     )))));
  }


  desativarFormEndereco(){
    setState(() {
      view_form_end=false;
    });
  }


  formatDistancia(){
    var unidadeMedida="";
    double valeu = double.parse(widget.listaDistancia_.distancia);
    if (valeu<1000)
      unidadeMedida="m";
    else {
      valeu=valeu/1000;
      unidadeMedida = "km";
    }
    var distTxt="";
  return  distTxt= valeu.toStringAsFixed(1)+""+unidadeMedida;
  }


  barra(){
  return  Container(decoration: BoxDecoration(color: Colors.transparent,boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 2.0,
        offset: Offset(
          0.0, // horizontal, move right 10
          -2.0, // vertical, move down 10
        ),
      )
    ],),height: 45,child:

      barraView()

    ,);
  }


  barraView(){
 return
   GestureDetector(onTap: () {
   setState(() {
     if (view_resumo_cesta == false) {
       widget.call_back_show_bg(true);
       view_resumo_cesta=true;
     }
     else{
       confirmarEndereco=false;
       widget.call_back_show_bg(false);
       view_resumo_cesta=false;
     }
   });
 }, child: Container(
     margin: EdgeInsets.fromLTRB(0, 0, 0,0),   child: ClipRect(
       child:  BackdropFilter(
         filter:  ImageFilter.blur(sigmaX:3, sigmaY:3),
         child:  Container(
           width: double.infinity,
           height:  double.infinity,
           decoration:  BoxDecoration(color: Colors.orange[400].withOpacity(.7)),
           child:
   Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[


   Container(margin: EdgeInsets.fromLTRB(10, 0, 0, 0), child:
    Text("R\u0024 " + totaltxt.toString(), style: TextStyle(
        color: Colors.white,
        fontFamily: 'RobotoBold',
        fontWeight: FontWeight.bold,
        fontSize: 14),)),

    Container(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
        child: Image.asset("basket_.png",width:25,height:25,)),
//        Icon(Icons.shopping_basket, color: Colors.white)),
    Container(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.fromLTRB(5, 5, 15, 5),
        child:
        Text(qntdItenstxt, style: TextStyle(color: Colors.white,
            fontFamily: 'RobotoBold',
            fontWeight: FontWeight.bold,
            fontSize: 16),)),
  ],),
//           Container(margin: EdgeInsets.fromLTRB(0,10.5, 0, 0),
//                  child:
//                 Divider(color:Colors.white,height: 0,thickness: 2,)),

         ),
       ),
     ),
   ));
}


  formatFrete(){

    var coef = widget.listaCesta[0].coefKm;
    var distKm=0.0;

    for(int i = 0; i < widget.listaCesta.length;i++) {
//      if (widget.listaCesta[i].loja == widget.listaDistancia_.loja) {}
//      }
      if (widget.listaDistancia_ != null) {
        distKm = double.parse(widget.listaDistancia_.distancia) / 1000;

        if (widget.listaCesta[0].distanciaGratisKm >= distKm) {
          return "Entrega gratis";
        } else {
          if (distKm != 0.0) {
            var frete = (coef * distKm).round();
            var fretef = frete.toStringAsFixed(2).toString();
            return "R\u0024 " + fretef;
          } else
            return "";
        }
      }else
        return "";
    }
  }


  totalComFrete(){

    var coef = widget.listaCesta[0].coefKm;
    var distKm=0.0;

    for (int i = 0; i < widget.listaCesta.length;i++) {
      if (widget.listaDistancia_ != null) {
        if (widget.listaCesta[i].loja == widget.listaDistancia_.loja) {
          distKm = double.parse(widget.listaDistancia_.distancia) / 1000;
          if (widget.listaCesta[0].distanciaGratisKm >= distKm) {
            return "R\u0024 " + total.toStringAsFixed(2).replaceAll(".", ",");
          }
          else {
            if (distKm != 0.0) {
              var frete = (coef * distKm).round();
              var fretef = (total + frete).toStringAsFixed(2).toString();
              return fretef;
            } else
              return "...";
          }
        } else
          return "...";
      }else
        return "...";
    }
  }


  listaCesta()  {
  return
    Container(
        height: 125,
        child:
     StreamBuilder(
        stream: Firestore.instance
          .collection("Usuarios").document(widget.user.uid).collection("cesta")
          .snapshots(),
         builder: (context, snapshot) {
         switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text("AGUARDE....");
          case ConnectionState.none:
            return new Text("sem item");
            // TODO: Handle this case.
            break;
          case ConnectionState.active:
            return new ListView.builder(
                padding: EdgeInsets.all(0.0),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  print("ITEM CESTA LISTA"+index .toString());
                  return item_cesta(snapshot.data.documents[index],null,(value){return selectItemCestaList(value);});
                }
            );
            // TODO: Handle this case.
            break;
          case ConnectionState.done:
            return new Text("sem item");
            // TODO: Handle this case.
            break;
        }
      }
  ));
}


  listaCards()  {
    return
      Container(
          height: 125,
          child:
          StreamBuilder(
              stream: Firestore.instance
                  .collection("Usuarios").document(widget.user.uid).collection("cartoes")
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text("AGUARDE....");
                  case ConnectionState.none:
                    return new Text("sem item");
                    // TODO: Handle this case.
                    break;
                  case ConnectionState.active:
                    return new ListView.builder(
                        padding: EdgeInsets.all(0.0),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          print("ITEM CESTA LISTA"+index .toString());
                          return item_cesta(snapshot.data.documents[index],null,(value){return selectItemCestaList(value);});
                        }
                    );
                    // TODO: Handle this case.
                    break;
                  case ConnectionState.done:
                    return new Text("sem item");
                    // TODO: Handle this case.
                    break;
                }
              }
          ));
  }



  selectItemCestaList(var prod){
    setState(() {
      if (prod==null)
        ctrolControls=false;
      else
        ctrolControls=true;
    });

    selecionado=prod;
}


  getPrecoFormat(preco,quantidade){
    double p = (quantidade*preco)*1.0;
    preco = p.toStringAsFixed(2).toString();
    preco=preco.replaceAll(".", ",");
    return preco;
}


  _checkreresult() {
        total=0.0;
        qntdItens=0.0;
        if (widget.listaCesta.length==0)
          widget.call_back_show_bg(false);
        print("data "+widget.listaCesta.length.toString());
        for (int i = 0; i <  widget.listaCesta.length; i++) {

          Produto_cesta produto = widget.listaCesta[i];
          var preco = produto.preco;
          var quantidade = produto.quantidade;
          var t = (preco * quantidade);

            total += t;
            qntdItens += quantidade;
            qntdItenstxt = qntdItens.toStringAsFixed(0).toString() + " itens";
            totaltxt = getPrecoFormat(preco,qntdItens);

        }

  }


}

