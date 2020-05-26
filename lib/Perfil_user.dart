import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firestore/CardUser.dart';
import 'package:flutter_firestore/User.dart';
import 'package:flutter_firestore/barNavBottom.dart';
import 'package:flutter_firestore/form_endereco_user.dart';
import 'package:flutter_firestore/itemListProd.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'Produto_cesta.dart';
import 'enderecoUser.dart';
import 'headCurve.dart';
import 'itemCards.dart';
import 'itemListLojas.dart';



class Perfil_user extends StatefulWidget {

   Perfil_user();

   var enableEnd=false;
   var enableMap=false;
   var enableEndForm=false;
   var enablePag=false;
   var enableHistorico=false;
   var nome;
   var email;
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
  LatLng _center = const LatLng(-1.521563, -48.677433);
  var ctrl=false;
  var angCamMap=0.0;
  var angCamMap_=0.0;
  LatLng _center_start = const LatLng(-1.521563, -48.677433);
  TextStyle styleTxt = TextStyle(fontSize: 16,color:Colors.black54,fontFamily: 'RobotoLight');
  TextStyle styleTxt3 = TextStyle(fontSize: 16,color:Colors.orange,fontFamily: 'RobotoBold');
  TextStyle styleTxtred = TextStyle(fontSize: 16,color:Colors.red,fontFamily: 'RobotoLight', letterSpacing: 2);
  TextStyle styleTxt2 = TextStyle(fontSize: 16,color:Colors.orange,fontFamily: 'RobotoBold');
  enderecoUser endereco;
  Animation<double> animationCam;
  LatLng local_user;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));




    return Scaffold(
      resizeToAvoidBottomInset: false,  body:
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
                    Container( margin: EdgeInsets.fromLTRB(10, 10, 0, 0), alignment: Alignment.centerLeft ,
                      child: Text("Olá, "+ widget.nome, style:styleTxt,),),
                    Container( margin: EdgeInsets.fromLTRB(10, 10, 0, 10),alignment: Alignment.centerLeft ,
                      child: Text( widget.email,style:styleTxt,),),
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
                      });},
                          child:
                         Container(
                             padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                             decoration: BoxDecoration(color:Colors.white, boxShadow: [BoxShadow(color: Colors.grey[100], blurRadius: 2)]),
                             margin: EdgeInsets.fromLTRB(0, 10, 0, 0), child:
                          Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                          Text("Endereço para entrega",style:styleTxt2),
                          Container( alignment: Alignment.centerRight ,
                              child:Icon(widget.iconarrowend,color:Colors.orange))],)
                         )),
                       Divider(color:Colors.orange,height: 1,),
                     Container( margin: EdgeInsets.fromLTRB(10, 5, 0, 0),child:
                      Visibility(visible: widget.enableEnd, child:
                        Column(crossAxisAlignment: CrossAxisAlignment.start ,children: <Widget>[
                          Container(margin:EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child:   Text("Rua: "+endereco.rua,style:styleTxt,),),
                          Container(  child:   Text("Bairro: "+endereco.bairro,style:styleTxt,),),
                          Container(  child:   Text("Numero: "+endereco.numero,style:styleTxt,),),
                          Container(  child:   Text("Complemento: "+endereco.complemento,style:styleTxt,),),
                          Row( mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
//                            Text("Localização",style:TextStyle(color:Colors.orange[300],fontFamily: 'RobotoBold',fontSize: 16)),
                          Container(alignment: Alignment.centerLeft ,  child:Icon( Icons.map,color:Colors.orange[300],size: 17,))],),

                          Visibility(visible:widget.enableMap, child:
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            height: 120,child:
                          Stack(children: <Widget>[
                            GoogleMap(
                                onMapCreated:  (GoogleMapController controller) {
                                  mapController = controller;

                                },
                                zoomControlsEnabled: false,
                                mapType: MapType.normal,
                                buildingsEnabled: true,

                                zoomGesturesEnabled: false,
                                scrollGesturesEnabled: false,
                                compassEnabled: true,
                                rotateGesturesEnabled: true,
                                initialCameraPosition:  CameraPosition(
                                    target: _center,
                                    zoom: 18,
                                    tilt:0,
                                    bearing:angCamMap

                                )),
                              GestureDetector(onTap: ()
                              {
                                setState((){
                                  if (widget.anguloCamera==35)
                                     widget.anguloCamera=0;
                                  else
                                      widget.anguloCamera=35;


                                });},
                                  child:Container(
                                  height: 130,
                                  alignment: Alignment.center,
                                  child:Icon(Icons.adjust,color: Colors.orange,))),
                          ])
                          )),

                       GestureDetector(onTap: ()
                       {
                         setState((){
                           widget.enableEndForm=true;

                         });},
                         child:
                          Container(padding:EdgeInsets.fromLTRB(10, 5, 10, 5) , margin: EdgeInsets.fromLTRB(0, 10, 0, 10), decoration: BoxDecoration(border:Border.all(color: Colors.lightBlue),borderRadius: BorderRadius.all(Radius.circular(3))), child:
                            Text("Editar endereço",style:TextStyle(fontSize: 15,color:Colors.lightBlue),),)),

                        ],),
                      )),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 0,10) ,
                            decoration: BoxDecoration(color:Colors.white),
                            margin: EdgeInsets.fromLTRB(0,0, 0, 0), child:
                        Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                           Row( mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                             Text("Informações de pagamento",style:styleTxt2,),
                           ],),
                          GestureDetector(onTap: (){setState((){
                            if (widget.enablePag==false)
                            {widget.enablePag=true;widget.iconarrowpag=Icons.arrow_drop_up;}
                            else
                            { widget.enablePag=false;widget.iconarrowpag=Icons.arrow_drop_down;}
                          });},
                              child:
                              Container( alignment: Alignment.centerRight ,  child:Icon(widget.iconarrowpag,color:Colors.orange))),
                        ],)),
                      Divider(color:Colors.orange,height: 1,),
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
            Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              Text("Histórico de pedidos",style:styleTxt2,),
              Container( alignment: Alignment.centerLeft ,  child:Icon(widget.iconarrowhist,color:Colors.orange)),],))),
                  Divider(color:Colors.orange,height: 1,),
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

          Positioned( child: barNavBottom("User",true,"",null,null),bottom: 0,width: MediaQuery.of(context).size.width),

          Visibility(visible: widget.enableEndForm, child:
          Positioned( child: form_endereco_user(endereco,null,(){return _closePopEndereco();}),top: 0,
              width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height )),
      ]),
    );
  }



  @override
  void initState() {
    setState(() {
      widget.iconEnd = Icons.arrow_drop_down;
      widget.iconarrowend =  Icons.arrow_drop_down;
      widget.iconarrowpag =  Icons.arrow_drop_down;
      widget.iconarrowhist=  Icons.arrow_drop_down;
      endereco = new enderecoUser("","","","", GeoPoint(_center.latitude,_center.longitude),true);
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

          endereco = new enderecoUser(
                  data['rua'], data['bairro'], data['numero'], data['complemento'],
                  data['localizacao'],data['temp']);
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




