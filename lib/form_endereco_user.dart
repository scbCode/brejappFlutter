import 'dart:async';

import 'package:android_intent/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firestore/botao3dFormEnd.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'BlocAll.dart';
import 'ClickyButton.dart';
import 'distanciaLoja.dart';
import 'enderecoUser.dart';


typedef enderecoReturn =enderecoUser Function(enderecoUser);
typedef cancelReturn  = Function();


class form_endereco_user extends StatefulWidget {

  final enderecoReturn callback_return;
  final cancelReturn callback_return_cancel;
  Set<Marker> markers = Set();
  bool isLocationEnabled=false;
  var compareLocal;

  var idloja;
  var    countResetPosit = 0 ;
  enderecoUser enderecoExist;

  form_endereco_user (  this.enderecoExist,this.idloja,this.compareLocal ,@required this.callback_return, @required this.callback_return_cancel);


  @override
  form_endereco_userState createState() => form_endereco_userState();

}


class form_endereco_userState extends State<form_endereco_user>  with SingleTickerProviderStateMixin {

  AnimationController _controllerIcon;
  var show_googlemaps=true;
  enderecoUser enderecoChecado;

  var cor_map_load =  false;
  var frua = new FocusNode();
  var fbairro = new FocusNode();
  var fnumero = new FocusNode();
  var fcomplemento = new FocusNode();
  var angCamMap=0.0;
  var view_endereco_map=true;
  var view_form_endereco=false;
  GoogleMapController mapController;
  LatLng _center = const LatLng(-1.521563, -48.677433);
  LatLng localupdate = const LatLng(-1.521563, -48.677433);
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
          localupdate =_center;
        });
    }
    _controllerIcon = AnimationController(duration: Duration(milliseconds: 200),vsync: this);

  }


  @override
  Widget build(BuildContext context) {

    return
    LimitedBox(
        maxHeight: MediaQuery.of(context).size.height*.85,
        child:
      Scaffold(
        backgroundColor: Colors.transparent,
          resizeToAvoidBottomPadding: true,
          body:
          SingleChildScrollView(child:

          Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
      Container(
        margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
          decoration: BoxDecoration(
              borderRadius:BorderRadius.all(Radius.circular(5)),
              boxShadow: [BoxShadow(color: Colors.black54,blurRadius:0.3,offset: Offset(0,0))]),
          child:
                 Column(
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: <Widget>[
                   Row(children:[

                   GestureDetector(onTap: (){
                     setState(() {
                       if (view_form_endereco==false)
                       {
                          widget.callback_return_cancel();
                       }
                          else
                       {
                           view_form_endereco=false;
                           view_endereco_map=true;
                       }
                     });

                   },child:
                   Container(
                       margin:EdgeInsets.fromLTRB(5,0,0,0),
                       alignment: Alignment.centerLeft,
                       padding: EdgeInsets.all(8),
                       child:Icon(Icons.arrow_back,color:Colors.white)
                   )),
                        Container(
                          margin:EdgeInsets.fromLTRB(15,10,0,5),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8),
                        child:Text("ENDEREÇO DE DENTREGA",style: TextStyle(fontSize: 16,color:Colors.white,fontFamily: 'RobotoBold'),)),
                   ]),

                   Container(
                   width: MediaQuery.of(context).size.width,
                       decoration: BoxDecoration(color:Colors.transparent,),
                       padding: EdgeInsets.all(0),
                       child:
                     Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[

                    Visibility(
                             visible: view_form_endereco,
                             child:
                         Container(
                             padding: EdgeInsets.all(15),
                             decoration:BoxDecoration(color:Colors.white),
                             child:
                     Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                         Container(
                             padding: EdgeInsets.all(20),
                             child:Text("",style: TextStyle(color:Colors.orange,fontFamily: 'RobotoBold'))),
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
                              margin: EdgeInsets.fromLTRB(10,0, 10, 40), alignment: Alignment.centerLeft,
                             child:TextFormField(focusNode:fcomplemento,controller:c_complemento
                                 ,textInputAction:  TextInputAction.next,textCapitalization:
                                 TextCapitalization.words, decoration: InputDecoration(hintText: "Complemento",hintStyle: TextStyle(color: Colors.black26)),
                                 style:
                                 TextStyle(color:Colors.black54,fontFamily: 'RobotoRegular'))),

                       ]))),


                       Visibility(
                           visible: view_endereco_map,
                           child:
                         Container(
                           height: 300,
                             margin: EdgeInsets.fromLTRB(0, 0, 0, 0), alignment: Alignment.centerLeft,
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
                                zoom: 16.0
                              ),
                            ),
                           Visibility(visible: show_googlemaps, child:
                            Container(
                                height: 200,
                                  decoration: BoxDecoration(color: Colors.grey),
                                  alignment: Alignment.center)),

                              Visibility(visible: cor_map_load, child:
                              Container(
                                height: 300,
                                decoration: BoxDecoration(color:Colors.black54),
                                alignment: Alignment.center,)),
                             Visibility(visible: true, child:
                              Container(
                                  height: 300,
                                  alignment: Alignment.center,
                                  child:Icon(Icons.adjust,color: Colors.orange,))),
                              GestureDetector(
                                  onTap: (){ returnLocalInit();},
                                  child: Visibility(visible: true, child:
                                  Container(
                                      width: 50,
                                      height: 50,
                                      margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                                      decoration: BoxDecoration(
                                          boxShadow: [BoxShadow(color:Colors.black54,blurRadius: 5)],
                                          color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(50))),
                                      alignment: Alignment.center,
                                      child:
                                      RotationTransition(
                                          turns: Tween(begin: 0.0, end: 1.0).animate(_controllerIcon),
                                          child:Icon(Icons.pin_drop,color: Colors.blue,size: 25,))))),
                            ],))),


                       ],) ),



                 ],)
        ),
Container(
  width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
    child:
     Row (
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[

            Visibility(visible: view_endereco_map,child:
            GestureDetector(onTap: (){ _initSaveEndereco_check();},child:
            FlatButton (
              onPressed: () {

                  if (localupdate != widget.enderecoExist.localizacao )
                    getDirections();

              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color:Colors.orange
                ),
                padding: const EdgeInsets.all(15.0),
                child:
                const Text('CONFIRMAR', style: TextStyle(fontSize: 20)),
              ),
            ),
//                  color: Colors.amber,
//                  onPressed: () { _initSaveEndereco_check();},
            )),
            Visibility(visible: view_form_endereco,child:
            GestureDetector(onTap: (){ _initSaveEndereco_check();},child:
            FlatButton (
              onPressed: () {
                setState(() {
                  _initSaveEndereco_check();
                });
              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color:Colors.green
                ),
                padding: const EdgeInsets.all(15.0),
                child:
                const Text('SALVAR', style: TextStyle(fontSize: 20)),
              ),
            ),
//                  color: Colors.amber,
//                  onPressed: () { _initSaveEndereco_check();},
            )),
//            Visibility(visible:false,child:
//            GestureDetector(onTap: (){ _initSaveEndereco_check();},child:
//            Container(
//                decoration:BoxDecoration(color:Colors.green),
//                height: 50,
//                alignment: Alignment.center,
//                padding: EdgeInsets.all(5),
//                child:
////                Transform.scale(scale: 0.8,child:
////                botao3dFormEnd(
////                  colorFactor: 3,
////                  sizeW: MediaQuery.of(context).size.width*.5,
////                  child:
//                  Text(
//                    'SALVAR',
//                    style: TextStyle(
//                        fontFamily:'BreeSerif',
//                        color: Colors.white,
//                        letterSpacing: 3,
//                        fontSize: 20),
//                  ),
////                  color: Colors.amber,
////                  onPressed: () { _initSaveEndereco_check();},
//                ))),


            ],)),


        ])))    )
    ;
  }


  _fieldFocusChange (FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus ();
    FocusScope.of (context) .requestFocus (nextFocus);
  }

  getDirections(){
    print("getDirections");
    if (widget.compareLocal!=null){
      calcDistancia(widget.compareLocal);
    }

  }

  getLocal(){
    show_googlemaps=false;

    if (mapController!=null && _center!=null)
        mapController.moveCamera(CameraUpdate.newLatLngZoom(_center,14));

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

    print("POSICAO "+localupdate.latitude.toString());
    GeoPoint localizacao = new GeoPoint(localupdate.latitude, localupdate.longitude);
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

  calcDistancia(var produto)async{


    print("calcDistancia");

    String lat2 = produto.latitude.toString();
    String lng2 = produto.longitude.toString();
    String lat1 = localupdate.latitude.toString();
    String lng1 = localupdate.longitude.toString();
    Dio dio = new Dio();
    Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=" +
            lat1 + "," + lng1 + "&destinations=" + lat2 + "," + lng2 +
            "&key=AIzaSyAnQ3zt7IUwj3LnKBssY6s-rH-17PlmXDs");

    print("DISTANCE MATRIX "+ response.data.toString());
    var d =  response.data['rows'][0]['elements'][0]['distance']['value'].toString();
    var duration =  response.data['rows'][0]['elements'][0]['duration']['text'].toString();
    var endtemp =  response.data['origin_addresses'][0].toString();
    var endtempsplit =  endtemp.split(", ");
    var rua = endtempsplit[0];
    var cidade = endtempsplit[2];
    var pais = endtempsplit[4];
    var numeebairro = endtempsplit[1].split(" - ");
    var numero = numeebairro[0];
    var bairro = numeebairro[1];

    enderecoChecado = new enderecoUser(rua, bairro, numero, "", GeoPoint(localupdate.latitude,localupdate.longitude),true);

    setState(() {
        c_rua.text=rua;
        c_bairro.text =bairro;
        c_numero.text = numero;
        c_complemento.text = "";
        view_endereco_map=false;
        view_form_endereco=true;
    });
  }


  addDistance(distanciaLoja distancia,produto) async{

    print ("addDistance");

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user!=null) {

      await Firestore.instance.collection("Usuarios")
          .document(user.uid).collection("distancias")
          .document(distancia.idloja)
          .setData(distancia.getdistanciaLoja());

      setState(() {

      });
    }else{
      print ("addDistance erro - user null");
    }


  }

  enviarFormEndereco(enderecoUser endereco) async{
    var refData = Firestore.instance;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;

    if (widget.idloja==null) {

      await refData.collection("Usuarios")
          .document(uid)
          .collection("endereco").document("Entrega")
          .setData(endereco.getenderecoUser());

      await refData.collection("Usuarios")
          .document(uid)
          .collection("distancias").getDocuments().then((value) => value.documents.forEach((element) {element.reference.delete();}));


      _snackbar("Endereço salvo");


      widget.callback_return_cancel();
    }
    else {
      await refData.collection("Usuarios")
          .document(uid)
          .collection("Pedidos").document(widget.idloja)
          .setData({'enderecoEntrega':endereco.getenderecoUser()},merge: true);
      _snackbar("Endereço salvo");
      widget.callback_return_cancel();
    }
  }

  _snackbar(text){
//    final snackBar = SnackBar(content: Text(text));
//    Scaffold.of(context).showSnackBar(snackBar);
    var bloc = BlocAll();
    bloc.resetListProduto();
  }

  returnLocalInit(){

//    setState(() {
//      cor_map_load =true;
//    });

      _getLocation();


  }

  _getLocation() async {

    print("Get local");

    if ( widget.isLocationEnabled==false)
        widget.isLocationEnabled = await Geolocator().isLocationServiceEnabled();
    if ( widget.isLocationEnabled==true){

    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);


      if (mapController!=null){
        var zoom = await mapController.getZoomLevel();
        print("Get local zomm "+zoom.toString());

        mapController.moveCamera(CameraUpdate.newLatLngZoom(
            LatLng(currentLocation.latitude, currentLocation.longitude),zoom ));}
        setState(()  {
          show_googlemaps=false;
           _center_current   = LatLng(currentLocation.latitude, currentLocation.longitude);
           _center=_center_current;
          cor_map_load = false;

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

    localupdate = new LatLng(position.latitude,position.longitude);
    print("change local "+localupdate.latitude.toString());


  }


}