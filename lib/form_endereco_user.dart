import 'dart:async';

import 'package:android_intent/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_firestore/botao3dFormEnd.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'ClickyButton.dart';
import 'enderecoUser.dart';


typedef enderecoReturn =enderecoUser Function(enderecoUser);
typedef cancelReturn  = Function();


class form_endereco_user extends StatefulWidget {

  final enderecoReturn callback_return;
  final cancelReturn callback_return_cancel;
  Set<Marker> markers = Set();
  bool isLocationEnabled=false;

  var    countResetPosit = 0 ;
  enderecoUser enderecoExist;

  form_endereco_user (  this.enderecoExist, @required this.callback_return, @required this.callback_return_cancel);


  @override
  form_endereco_userState createState() => form_endereco_userState();

}


class form_endereco_userState extends State<form_endereco_user>  with SingleTickerProviderStateMixin {

  AnimationController _controllerIcon;
  var show_googlemaps=true;
  var frua = new FocusNode();
  var fbairro = new FocusNode();
  var fnumero = new FocusNode();
  var fcomplemento = new FocusNode();
  var angCamMap=0.0;
  GoogleMapController mapController;
  LatLng _center = const LatLng(-1.521563, -48.677433);
  LatLng _center_current = const LatLng(-1.521563, -48.677433);
  LatLng _center_start = const LatLng(-1.521563, -48.677433);

  TextEditingController c_rua = TextEditingController();
  TextEditingController c_bairro = TextEditingController();
  TextEditingController c_numero = TextEditingController();
  TextEditingController c_complemento = TextEditingController();
  TextEditingController c_cidade = TextEditingController();


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
   getLocal();
  }

  @override
  void initState() {
    super.initState();

    if (widget.enderecoExist!=null){
        setState(() {
          c_rua.text = widget.enderecoExist.rua ;
          c_bairro.text = widget.enderecoExist.bairro;
          c_numero.text = widget.enderecoExist.numero;
          c_complemento.text = widget.enderecoExist.complemento;
          _center = LatLng(widget.enderecoExist.localizacao.latitude,widget.enderecoExist.localizacao.longitude);
          _center_start =_center;
        });
    }
    _controllerIcon = AnimationController(duration: Duration(milliseconds: 200),vsync: this);

  }


  @override
  Widget build(BuildContext context) {

    return


        Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
      Container(

          decoration: BoxDecoration(
              color:Colors.white, borderRadius:BorderRadius.all(Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.black26,blurRadius:2,offset: Offset(0,0))]),
          child:

                 SingleChildScrollView(child:
                 Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   Container(
                   width: MediaQuery.of(context).size.width,
                       decoration: BoxDecoration(color:Colors.transparent,),
                       padding: EdgeInsets.all(0),
                       child:
                     Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                         Container(
                             padding: EdgeInsets.all(20),
                             child:Text("NOVO ENDEREÇO",style: TextStyle(color:Colors.orange,fontFamily: 'RobotoBold'))),
                         Container(
                             margin: EdgeInsets.fromLTRB(15, 0,15, 0), alignment: Alignment.centerLeft,
                             child:
                             TextField(controller:c_rua,
                                 onChanged: (value) {
                                   setState(() {
                                   });},textInputAction:  TextInputAction.next,
                                 textCapitalization: TextCapitalization.words,
                                 decoration: InputDecoration(hintText: "Rua",
                                     hintStyle: TextStyle(color: Colors.black26)),
                                 style: TextStyle(color:Colors.black54,fontFamily: 'RobotoRegular'))),

                         Container(
                             margin: EdgeInsets.fromLTRB(15, 0, 15, 0), alignment: Alignment.centerLeft,
                             child:TextFormField(focusNode:fbairro,
                                 onFieldSubmitted: (term) {
                               _fieldFocusChange ( fbairro , fnumero);
                             },
                                 controller:c_bairro,
                                 textInputAction:  TextInputAction.next
                                 ,textCapitalization: TextCapitalization.words, decoration: InputDecoration(hintText: "Bairro",hintStyle: TextStyle(color: Colors.black26)),
                                 style: TextStyle(color:Colors.black54,fontFamily: 'RobotoRegular'))),
                         Container(
                             margin: EdgeInsets.fromLTRB(15, 0, 15, 0), alignment: Alignment.centerLeft,
                             child:TextFormField(onFieldSubmitted: (term) {
                               _fieldFocusChange (fnumero , fcomplemento);
                               },focusNode:fnumero,controller:c_numero,textInputAction:
                             TextInputAction.next,textCapitalization: TextCapitalization.words,
                                 decoration: InputDecoration(hintText: "Numero",hintStyle: TextStyle(color: Colors.black26)),
                                 style: TextStyle(color:Colors.black54,fontFamily: 'RobotoRegular'))),
                         Container(                             padding: EdgeInsets.all(5),
                              margin: EdgeInsets.fromLTRB(10,0, 10, 0), alignment: Alignment.centerLeft,
                             child:TextFormField(focusNode:fcomplemento,controller:c_complemento
                                 ,textInputAction:  TextInputAction.next,textCapitalization:
                                 TextCapitalization.words, decoration: InputDecoration(hintText: "Complemento",hintStyle: TextStyle(color: Colors.black26)),
                                 style:
                                 TextStyle(color:Colors.black54,fontFamily: 'RobotoRegular'))),

                         Container(
                           height: 150, margin: EdgeInsets.fromLTRB(0, 20, 0, 0), alignment: Alignment.centerLeft,
                            child:
                            Stack(children: <Widget>[
                             GoogleMap(
                              onMapCreated:  _onMapCreated,
                              zoomControlsEnabled: true,
                              buildingsEnabled: true,
                              mapType: MapType.normal,
                              onCameraMove: (object) => {_moveMarkerCenter(object.target)},
                              initialCameraPosition:  CameraPosition(
                                target: getLocal(),
                                zoom: 12.0
                              ),
                            ),
                           Visibility(visible: show_googlemaps, child:
                            Container(
                                height: 150,
                                  decoration: BoxDecoration(color: Colors.grey),
                                  alignment: Alignment.center)),
                             Visibility(visible: true, child:
                              Container(
                                  height: 150,
                                  alignment: Alignment.center,
                                  child:Icon(Icons.adjust,color: Colors.orange,))),
                              GestureDetector(
                                  onTap: (){ returnLocalInit();},
                                  child: Visibility(visible: true, child:
                                  Container(
                                      height: 150,
                                      alignment: Alignment.bottomRight,
                                      child:
                                      RotationTransition(
                                          turns: Tween(begin: 0.0, end: 1.0).animate(_controllerIcon),
                                          child:Icon(Icons.refresh,color: Colors.blue,size: 25,))))),
                            ],)),


                       ],)),



                 ],)
        )
    ),
Container(
    margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
    child:
     Row (
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[

            Container(
                width: MediaQuery.of(context).size.width*0.4,
                margin: EdgeInsets.fromLTRB(0,0,0,0),
                child:
                Transform.scale(scale: 0.8,child:

                botao3dFormEnd(
                  colorFactor: 3,
                  sizeW: MediaQuery.of(context).size.width*.5,
                  child: Text(
                    'SALVAR',
                    style: TextStyle(
                        fontFamily:'BreeSerif',
                        color: Colors.white,
                        letterSpacing: 3,
                        fontSize: 20),
                  ),
                  color: Colors.amber,
                  onPressed: () { _initSaveEndereco_check();},
                ))),

            Container(
            width: MediaQuery.of(context).size.width*0.4,
             child:
              Transform.scale(scale: 0.8,child:
                  Container(
                  child:
                      botao3dFormEnd(
                        colorFactor: 3,
                        sizeW: MediaQuery.of(context).size.width*.5,
                        child: Text(
                          'CANCELAR',
                          style: TextStyle(
                              fontFamily:'BreeSerif',
                              color: Colors.white,
                              letterSpacing: 3,
                              fontSize: 18),
                        ),
                        color: Colors.grey,
                        onPressed: () { widget.callback_return_cancel();},
                      )))),


            ],)),


        ]);
  }


  _fieldFocusChange (FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus ();
    FocusScope.of (context) .requestFocus (nextFocus);
  }


  getLocal(){
    show_googlemaps=false;
    if (mapController!=null)
        mapController.moveCamera(CameraUpdate.newLatLngZoom(_center, 12));

   _center=new LatLng(widget.enderecoExist.localizacao.latitude,
       widget.enderecoExist.localizacao.longitude);

    return _center;
  }

  _initSaveEndereco_check(){

    var rua = c_rua.text;
    var bairro = c_bairro.text;
    var cidade = "Belém";
    var numero = c_numero.text;
    var complemento = c_complemento.text;

    print("POSICAO "+_center.latitude.toString());
    GeoPoint localizacao = new GeoPoint(_center.latitude, _center.longitude);
    bool check = false;

    if (rua.length==0) {
      _snackbar("Todos os campos são obrigatórios");
    }else
    if (bairro.length==0) {
      _snackbar("Todos os campos são obrigatórios");
    }else
    if (cidade.length==0) {
      _snackbar("Todos os campos são obrigatórios");
    }else
    if (numero.length==0) {
      _snackbar("Todos os campos são obrigatórios");
    }else
    if (complemento.length==0) {
      _snackbar("Todos os campos são obrigatórios");
    }else
    if (localizacao==null) {
      _snackbar(
          "Não foi possivel obter sua localização, ative o gps para continuar.");
    }else
      check=true;

    if (check==true){
      enderecoUser endereco = new enderecoUser(rua,bairro,numero,complemento,localizacao,false);
      enviarFormEndereco(endereco);
    }

  }


  enviarFormEndereco(enderecoUser endereco) async{
    var refData = Firestore.instance;

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;

    await refData.collection("Usuarios")
        .document(uid)
        .collection("endereco").document("Entrega")
        .setData(endereco.getenderecoUser());
     _snackbar("Endereço salvo");
     widget.callback_return_cancel();

  }

  _snackbar(text){
    final snackBar = SnackBar(content: Text(text));
    Scaffold.of(context).showSnackBar(snackBar);

  }

  returnLocalInit(){

    setState(() {

          _controllerIcon.reset();
          _controllerIcon.forward();
//          if (show_googlemaps==false)
//            mapController.moveCamera(CameraUpdate.newLatLngZoom(_center, 16));



//            if (_center.latitude==_center_start.latitude && _center.longitude==_center_start.longitude)
//             if (widget.enderecoExist==null)
//                 _getLocation();

            widget.countResetPosit++;

//            if (widget.countResetPosit>=3) {
//              widget.countResetPosit=0;
//              _getLocation();
//            }
    });

  }

  _getLocation() async {

    print("Get local");

    if ( widget.isLocationEnabled==false)
        widget.isLocationEnabled = await Geolocator().isLocationServiceEnabled();
    if ( widget.isLocationEnabled==true){

    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
        setState(() {
          show_googlemaps=false;

           _center_current   = LatLng(currentLocation.latitude, currentLocation.longitude);
           _center=_center_current;
          if (mapController!=null)
          mapController.moveCamera(CameraUpdate.newLatLngZoom(
                LatLng(currentLocation.latitude, currentLocation.longitude), 16));
        });
    }else{
      openLocationSetting();
    }
  }
  void openLocationSetting() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
    bool isLocationEnabled = await Geolocator().isLocationServiceEnabled();
    if (isLocationEnabled==true)
      _getLocation();

  }


  _moveMarkerCenter(var position){

    //_center = LatLng(position.latitude,position.longitude);


  }


}