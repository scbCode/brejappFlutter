import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firestore/Bloc_finaceiro.dart';
import 'package:flutter_firestore/CardUser.dart';
import 'package:flutter_firestore/User.dart';
import 'package:flutter_firestore/barNavBottom.dart';
import 'package:flutter_firestore/enderecoUserSnapShot.dart';
import 'package:flutter_firestore/form_endereco_user.dart';
import 'package:flutter_firestore/itemListProd.dart';
import 'package:flutter_firestore/pop_returnPedido.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';

import 'Produto_cesta.dart';
import 'cartao_form.dart';
import 'enderecoUser.dart';
import 'headCurve.dart';
import 'itemCards.dart';
import 'itemCarduser.dart';
import 'itemListLojas.dart';



class Perfil_user extends StatefulWidget {

   Perfil_user();

   var enableEnd=false;
   var enableMap=false;
   var enableEndForm=false;
   var enablePag=false;
   var enableHistorico=false;
   var nome="";
   var email="";
   var iconEnd;
   var iconarrowend;
   var iconarrowpag;
   var iconarrowhist;
   double anguloCamera=35;
   AnimationController _controllerrotate;


  @override
  perfil_userState createState() => perfil_userState();
}

class perfil_userState extends State<Perfil_user>  with SingleTickerProviderStateMixin {

  var t="x";
  var enablePag=false;
  GoogleMapController mapController;
  var end_user_= new enderecoUser("","","","",new GeoPoint(0.0, 0.0),"");
  var view_form_end=false;
  var formEnd;
  var enderecoview;
  LatLng _center = const LatLng(-1.521563, -48.677433);
  var ctrl=false;
  var angCamMap=0.0;
  var angCamMap_=0.0;
  LatLng _center_start = const LatLng(-1.521563, -48.677433);
  TextStyle styleTxt = TextStyle(fontSize: 16,color:Colors.black54,fontFamily: 'RobotoBold');
  TextStyle styleTxt3 = TextStyle(fontSize: 16,color:Colors.orange,fontFamily: 'RobotoBold');
  TextStyle styleTxtred = TextStyle(fontSize: 16,color:Colors.red,fontFamily: 'RobotoLight', letterSpacing: 2);
  TextStyle styleTxt2 = TextStyle(fontSize: 16,color:Colors.orange,fontFamily: 'RobotoBold');
  enderecoUserSnapShot endereco;
  enderecoUser  endereco_;
  Animation<double> animationCam;
  LatLng local_user;
  var uid;
  var show_pop_final_pedido=false;
  var view_card_form=false;
  var idcardExlui="";

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  getUseruid() async {
    var userx = await FirebaseAuth.instance.currentUser();
    uid=userx.uid;
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));




    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:

     Stack(
        children: <Widget>[

         Container(
         padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
         height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: Colors.white),
            child:
        SingleChildScrollView ( child:
        Column(
          mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                    _barTop(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 70,
                      color: Colors.white,
                      child:CustomPaint(
                        painter: headCurve(Colors.orange),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      alignment: Alignment.center ,
                      child: Text("Bem vindo\n "+ widget.nome, style:styleTxt,
                        textAlign: TextAlign.center,),),
                    Container( margin: EdgeInsets.fromLTRB(10, 15, 0, 10),alignment: Alignment.centerLeft ,
                      child: Text( widget.email,style:TextStyle(fontFamily: 'RobotoLight',fontSize: 16),),),
                    Container(alignment: Alignment.centerLeft ,
                         margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                         child:Container(
                             child: Text("sair", style:styleTxtred ,),
                             decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)),border:  Border.all(color: Colors.red)))),
                    GestureDetector(onTap: ()
                       {
                          setState((){
                            if (widget.enableEnd==false) {
                                widget.enableEnd = true;
                                widget.iconarrowend=Icons.arrow_drop_up;
                              } else{
                                widget.enableEnd=false;
                                widget.iconarrowend=Icons.arrow_drop_down;
                              }
                          });
                        },
                          child:
                         Container(
                             padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                             decoration: BoxDecoration(color:Colors.white,
                                 ),
                             margin: EdgeInsets.fromLTRB(0, 10, 0, 0), child:
                          Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                             Text("Endereço para entrega",
                                 style:TextStyle(color:Colors.black,fontFamily:'BreeSerif')),
                          ],)
                         )),
            Visibility(
                visible: end_user_!=null, child:
                  enderecoview),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 0,15) ,
                            decoration: BoxDecoration(color:Colors.white),
                            margin: EdgeInsets.fromLTRB(0,0, 0, 0), child:
                        Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                             Text("Informações de pagamento",
                            style:TextStyle(color:Colors.black,fontFamily:'BreeSerif')),
                         ],)),
                  Container(
                      child:
                      StreamBuilder(
                          stream: Firestore.instance.collection('Usuarios').document(uid)
                              .collection("cartoes").snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState== ConnectionState.active){
                              print("get cartoes");
                               if (snapshot.data.documents.length>0)
                                  return itemCarduser(snapshot, (cartaoselect, data, idcard){selectRemoveCartao(idcard);},"perfil");
                                else
                                  return Container(
                                     margin: EdgeInsets.fromLTRB(20, 0, 0,10),
                                      width: MediaQuery.of(context).size.width,
                                      child:Text("NENHUM CARTÃO SALVO",
                                      style:TextStyle(color: Colors.grey[500],fontFamily: 'RobotoLight')));
                            } else
                              return Container(child:Text("NENHUM CARTÃO SALVO",
                                  style:TextStyle()));

                          })
                  ),

                  pagamentoCartaoVazio(),

                  Visibility(
                            visible: widget.enablePag, child:
                              listacards()),
                      Visibility(
                          visible: widget.enablePag, child: _btnaddCard()),
                GestureDetector(
                    onTap: (){},
                    child:
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10) ,
                decoration: BoxDecoration(color:Colors.white, boxShadow: [BoxShadow(color: Colors.grey[100], blurRadius: 2)]),
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0), child:
            Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
//              Text("Histórico de pedidos",
//                  style:TextStyle(color:Colors.black,fontFamily:'BreeSerif'))
                  ]),
                )),
               Visibility(
                visible: widget.enableHistorico, child:
                Expanded(child:
                StreamBuilder(
                    stream: Firestore.instance
                        .collection("Produtos_On").orderBy("preco",descending: false).orderBy("marca")
                        .snapshots(),
                    builder: (context, snapshot) {
                      return new ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            Produto_cesta p = new Produto_cesta(snapshot.data.documents[index]);
                            return Container();
                          }
                      );
                    }
                ))),
              ]))),

          Visibility(visible: view_form_end && end_user_!=null,child:
              formEnd=formularioEndereco()
          ),

          Positioned( child: barNavBottom("User",true,"",null,null),bottom: 0,width: MediaQuery.of(context).size.width),

          Visibility(visible: widget.enableEndForm, child:
          Positioned( child: form_endereco_user(endereco_,null,null,null,(){return _closePopEndereco();}),top: 0,
              width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height )),

          Container(child:
            Column(children: <Widget>[
                Visibility(visible:show_pop_final_pedido,child: pop_excluirCard()),

              Positioned(
                child:
                Visibility( child:
                formularioCartao(),visible: view_card_form,)),


          ],)),


      ]),
    );
  }
  formularioCartao(){

    return
      Container( width: double.infinity,height: MediaQuery.of(context).size.height,
          child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0,0.2),   child:
          ClipRect(
              child:  BackdropFilter(
                  filter:  ImageFilter.blur(sigmaX:1, sigmaY:1),
                  child:  Container(
                    decoration:  BoxDecoration(color: Colors.grey[200].withOpacity(.60)),
                    child:
                    Container(
                        padding: EdgeInsets.fromLTRB(30, 0, 30,0),
                        child:Column(mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            cartao_form(uid,(){hide_pop_cardform();})
                          ],)
                    ),
                  )))));
  }

  hide_pop_cardform(){
    setState(() {
      view_card_form=false;
    });
  }

  pagamentoCartaoVazio()
  {
    return
      GestureDetector(onTap:(){setState(() {
        view_card_form=true;
      });} ,child:
      Column(children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                    Text("Novo cartão de crédito",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                      TextStyle(color: Colors.black,fontFamily: 'RobotoLight',fontSize: 14),)),
                  ],),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child:Icon(Icons.playlist_add,color: Colors.grey,),),
                ],)),

          ],),

      ],));
  }

  pop_excluirCard(){
    return
      Container(
        height: MediaQuery.of(context).size.height-50 ,
        child: ClipRect(
            child:  BackdropFilter(
                filter:  ImageFilter.blur(sigmaX:4, sigmaY:4),
                child:  Container(
                    padding: EdgeInsets.all(30),
                    height: MediaQuery.of(context).size.height-50 ,
                    decoration:  BoxDecoration(color: Colors.transparent),
                    child:

                    Column(
                        mainAxisAlignment: MainAxisAlignment.center ,
                        children:[
                          Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                              decoration:
                              BoxDecoration(
                                boxShadow: [BoxShadow(color:Colors.grey[500],blurRadius: 3,offset: Offset(0,2) )],
                                borderRadius: BorderRadius.all(Radius.circular(70)),color: Colors.white,) ,
                              child:
                              Container(child:
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center ,
                                  children:[
                                  GestureDetector(onTap:(){
                                          setState(() {
                                            show_pop_final_pedido=false;
                                          });
                              ;},child:
                                    Container(
                                      alignment: Alignment.centerRight,
                                        margin: EdgeInsets.fromLTRB(0, 10, 20, 0),
                                        child:
                                        Text("X",style: TextStyle(fontFamily: 'RobotoBold'
                                            ,fontSize: 18), ))),

                                    Container(
                                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                        child:
                                        Text("EXCLUIR CARTAO",style: TextStyle(fontFamily: 'BreeSerif',fontSize: 16), )),
                                    Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.fromLTRB(10, 15, 10, 30),
                                        child:
                                        Text("DESEJA EXCLUIR O CARTÃO SELECIONADO?",textAlign: TextAlign.center ,style: TextStyle(fontSize: 16,fontFamily: 'RobotoLight',color: Colors.black))),

                                    GestureDetector(onTap:(){


                                          deletecard(idcardExlui);
                                      ;},child:
                                    Container(
                                        decoration:   BoxDecoration(
                                            borderRadius:BorderRadius.all(Radius.circular(30))),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.fromLTRB(10, 15, 10, 30),
                                        child:
                                        Text("CONFIRMAR",textAlign: TextAlign.center ,
                                            style: TextStyle(fontSize: 16,fontFamily: 'RobotoBold',color: Colors.orange)))),

                                  ]))),
//               Container(
//              height: 200,
//                 alignment: Alignment.center,
//                 padding: EdgeInsets.all(10),
//                 decoration:
//                 BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)),color: Colors.white,
//                 ) ,
//                 child:
//
                        ])))));

  }

  selectRemoveCartao(var idcard) {

    setState(() {
      show_pop_final_pedido=true;
      idcardExlui=idcard;
    });

  }

  deletecard(var idcard)async{
    var bloc_financeiro = new Bloc_financeiro();
    var result= await bloc_financeiro.deleteCartao(uid, idcard);
    setState(() {

    show_pop_final_pedido=false;
    });

  }

  enderecoUserView(var data){
    return
      Container(
          margin: EdgeInsets.fromLTRB(15, 10, 15, 20),
          decoration:
          BoxDecoration(color:Colors.white,borderRadius:BorderRadius.only( topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20),)
              ,boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)]),
          child:
          Column(
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width*.54,
                          margin: EdgeInsets.fromLTRB(20, 25,0, 0),
                          alignment: Alignment.centerLeft, child:
                      Text(data['rua']+", "+data['bairro'], maxLines: 4,
                        overflow: TextOverflow.ellipsis,style:
                        TextStyle(color: Colors.black87,fontFamily: 'RobotoLight'),)),
                      Container(
                          width: MediaQuery.of(context).size.width*.54,
                          margin: EdgeInsets.fromLTRB(20, 0,0, 5),
                          alignment: Alignment.centerLeft, child:
                      Text("Nº "+data['numero']+", "+data['complemento'], maxLines: 6,
                        overflow: TextOverflow.ellipsis,style:
                        TextStyle(color: Colors.black45,fontFamily: 'RobotoLight'),)),

                    ],),
                  Container(
                      height: 130,
                      width:MediaQuery.of(context).size.width*.32,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0), alignment: Alignment.centerLeft,
                      child:
                      Stack(children: <Widget>[
                        GoogleMap(
                            onMapCreated:  _onMapCreated,
                            zoomControlsEnabled: false,
                            buildingsEnabled: true,
                            rotateGesturesEnabled: false,
                            zoomGesturesEnabled: false,
                            scrollGesturesEnabled: false,
                            mapType: MapType.normal,
                            initialCameraPosition:  CameraPosition(
                                target:getLocal(data),
                                zoom: 17.0
                            )),
                        Visibility(visible: true, child:
                        Container(
                            height: 150,
                            alignment: Alignment.center,
                            child:Icon(Icons.radio_button_checked,color: Colors.red,size: 25,))),
                      ],)),

                ],),
              Divider(color:Colors.red,height: 1,),
              Visibility(visible:true,child:
              GestureDetector(onTap: (){
                setState(() {
                  view_form_end=true;

                }); },child:
              Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  alignment: Alignment.center, child:
              Text("Atualizar",style:
              TextStyle(color: Colors.red,fontFamily: 'RobotoBold'),)))),




            ],));
  }


  formularioEndereco(){

    return
      Container( width: double.infinity,height: MediaQuery.of(context).size.height,
          child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0,0.2),   child:
          ClipRect(
              child:  BackdropFilter(
                  filter:  ImageFilter.blur(sigmaX:2, sigmaY:2),
                  child:  Container(
                    decoration:  BoxDecoration(color: Colors.white.withOpacity(.20)),
                    child:
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 30, 20,0),
                        child:Column(mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            form_endereco_user(end_user_ ,null,end_user_.localizacao,null,(){desativarFormEndereco();})
                          ],)
                    ),


                  )))));
  }

  desativarFormEndereco(){
    setState(() {
      print("desativaformend");

      view_form_end=false;
    });
  }


  getLocal(var data){
    var   _center;

    print(data['localizacao']);
    print(data['localizacao'].longitude);

    _center=new LatLng(data['localizacao'].latitude,
        data['localizacao'].longitude);
    if (_center!=null)
    if (mapController!=null)
      mapController.moveCamera(CameraUpdate.newLatLngZoom(_center, 15));

    return _center;
  }

  enderecoView_(){
    return StreamBuilder(
        stream: Firestore.instance.collection('Usuarios').document(uid)
            .collection("endereco").where("temp",isEqualTo: false).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState==ConnectionState.active){
            if (snapshot.data.documents.length > 0) {

              return
                enderecoUserView(snapshot.data.documents[0]);
            }
            else{
              return
                StreamBuilder(
                    stream: Firestore.instance.collection('Usuarios').document(uid)
                        .collection("endereco").where("temp",isEqualTo: true).snapshots(),
                    builder: (context, snapshot1) {
                      if (snapshot1.connectionState==ConnectionState.active){
                        if (snapshot1.data.documents.length > 0) {
                          print("****");

//                          end_user_ = new enderecoUserSnapShot(snapshot.data);
                          return
                            enderecoUserView(snapshot1.data.documents[0]);
                        }else
                          return Container();
                      }else
                        return Container();
                    });
            }
          }else
            return Container();
        });
  }


  @override
  void initState() {
    getUseruid();
    enderecoview = enderecoView_();
    setState(() {
      widget.iconEnd = Icons.arrow_drop_down;
      widget.iconarrowend =  Icons.arrow_drop_down;
      widget.iconarrowpag =  Icons.arrow_drop_down;
      widget.iconarrowhist=  Icons.arrow_drop_down;
      endereco = new enderecoUserSnapShot(null);
//      endereco.localizacao = GeoPoint(_center.latitude,_center.longitude);
      getDadosUser();
     // _rotatemap();
    });
  }

  _rotatemap() async {

//    Timer.periodic(new Duration(milliseconds: 100), (timer) {
//      _loopAnimMap();
//    });
//      widget._controllerrotate = AnimationController(duration: Duration(milliseconds: 1000),vsync: this);
//      animationCam =  Tween(begin: 0.0, end: 360.0).animate(widget._controllerrotate)..addListener((){
//          if (widget._controllerrotate.isCompleted){
//            widget. _controllerrotate.repeat();
//            widget. _controllerrotate.forward();
//            ctrl=false;
////            if (angCamMap==180.0)
////              angCamMap=0.0;
////            else
////              angCamMap=180.0;
//          }
//          setState(() {
////            if (angCamMap<359)
////            angCamMap+=1;
//          });
//
//      });
//      widget. _controllerrotate.repeat();
//      widget. _controllerrotate.forward();

  }

  _loopAnimMap(){
//    setState(() {
//      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(bearing: angCamMap,target: _center,zoom: 18,tilt: 35)));
//    });
//    angCamMap_++;
//    angCamMap+=2.10;
//    if (angCamMap>=359.0){
//      angCamMap=0.0;
//    }
//

  }

  Future<dynamic>_XX(){
    print("FINAL");
    ctrl=true;
  }

  _closePopEndereco(){
    setState(() {
      widget.enableEndForm=false;
    });
  }




  _btnaddCard(){
    return
    GestureDetector(
        onTap: (){},
        child:
        Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10) ,
    decoration: BoxDecoration(color:Colors.white,border:Border.all(color:Colors.orange),borderRadius: BorderRadius.all(Radius.circular(10)) , boxShadow: [BoxShadow(color: Colors.grey[100], blurRadius: 2)]),
    margin: EdgeInsets.fromLTRB(10, 0, 0, 10), child: Text("ADICIONAR CARTÃO",style: styleTxt,)));

  }
  _barTop(){
    return Column(children: <Widget>[

      Container( height: 1,decoration: BoxDecoration(color: Colors.orange[300]),),
    ],);
  }

  void getDadosUser() async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    var document = await Firestore.instance.collection('Usuarios').document(uid);
    document.snapshots()
        .listen((data) => {
      setUser(data,data.documentID)
    });
  }

  void setUser(var data,var documentID){
    if (data!=null){
      User a = new User(data['nome'],data['tell'],data['email'],data['uid'],null);
      widget.nome = data['nome'];
      widget.email = data['email'];
      getEnderecoUser();
    }
  }


  void getEnderecoUser() async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    var document = await Firestore.instance.collection('Usuarios').document(uid);
    document.collection("endereco").document("Entrega").snapshots()
        .listen((data) => {
             setUiEndereco(data)

    });
  }

  void setUiEndereco(var data){

      setState(() {
         if (data.exists) {
              widget.iconEnd = Icons.arrow_drop_down;
              if (data!=null)
                  widget.enableMap=true;
              endereco = new enderecoUserSnapShot(
                      data);
              end_user_ = new enderecoUser(endereco.rua,endereco.bairro,endereco.numero,endereco.complemento,endereco.localizacao,false);
              _center = LatLng(endereco.localizacao.latitude,endereco.localizacao.longitude);
         }else {
            print("ENDERECO NULL");
            widget.iconEnd = Icons.add_box;
         }
      });
  }

  listacards()  {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      height: 180,
        child:

    StreamBuilder(
        stream: Firestore.instance
            .collection("Usuarios").document("Ewl0J68Us9cTHiF7bOBsCEIT5Up1").collection("cards")
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
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    CardUser card =  new CardUser(snapshot.data.documents[index]);
                    return itemCards(card,(){return selectCard();});
                  });
              // TODO: Handle this case.
              break;
            case ConnectionState.done:
              return new Text("sem item");
              // TODO: Handle this case.
              break;
         }
        }
    )
    );
  }

  selectCard(){}



}




