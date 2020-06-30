import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:android_intent/android_intent.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firestore/BlocAll.dart';
import 'package:flutter_firestore/Bloc_finaceiro.dart';
import 'package:flutter_firestore/Produto.dart';
import 'package:flutter_firestore/autenticacao.dart';
import 'package:flutter_firestore/barBuscar.dart';
import 'package:flutter_firestore/barNavBottom.dart';
import 'package:flutter_firestore/barPedidoUser.dart';
import 'package:flutter_firestore/pop_returnPedido.dart';
import 'package:flutter_firestore/itemListProd.dart';
import 'package:flutter_firestore/listaLojas.dart';
import 'package:flutter_firestore/prePedido.dart';
import 'package:flutter_firestore/returnBarCestaVazia.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'Produto_cesta.dart';
import 'ScannerUtils.dart';
import 'TextDetectorPainter.dart';
import 'User.dart';
import 'barCesta.dart';
import 'distanciaLoja.dart';
import 'enderecoUser.dart';
import 'geoLocationWeb.dart';
import 'headCurve.dart';
import 'itemListLojas.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'listaLojas.dart';
import 'dart:ui' as ui;
import 'dart:io' as Io;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.orange[300],
      ),
      home: MyHomePage(title: 'Brejapp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  bool v_poplogin=false;

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool v_bg=false;
  bool v_bg_=false;
  bool v_bg_load=true;
  var modo="app";
  var view_listaPedidos=false;
  var cestaAtiva=false;
  var cestaAtivaBar=false;
  var btnfloat=true;
  var pedidoAtivo=false;
  var bottomBarPedido=45.0;
  var bottomBarcesta=105.0;
var show_cesta=false;
  static var listaCesta=[];
  int _counter = 0;
  var isLocationEnabled=false;
  var countProd=[];
  Text texto;
  var shrinkWrapCtrol=true;
  List<itemListProd> lp = new List<itemListProd>();
  var marcas = [
    "https://firebasestorage.googleapis.com/v0/b/brejapp-flutter.appspot.com/o/o-brahma.png?alt=media&token=a9c0362d-da89-4079-8bc4-f22079b6dbee",
    "https://firebasestorage.googleapis.com/v0/b/brejapp-flutter.appspot.com/o/o-budweiser.png?alt=media&token=547573e8-aa3f-4937-8c19-f9fa818c57d7",
    "https://firebasestorage.googleapis.com/v0/b/brejapp-flutter.appspot.com/o/o-corona.png?alt=media&token=5ede9836-f3e6-403d-9b9e-9e0cba81715e",
    "https://firebasestorage.googleapis.com/v0/b/brejapp-flutter.appspot.com/o/o-brahma.png?alt=media&token=a9c0362d-da89-4079-8bc4-f22079b6dbee",
    "https://firebasestorage.googleapis.com/v0/b/brejapp-flutter.appspot.com/o/o-budweiser.png?alt=media&token=547573e8-aa3f-4937-8c19-f9fa818c57d7",
    "https://firebasestorage.googleapis.com/v0/b/brejapp-flutter.appspot.com/o/o-corona.png?alt=media&token=5ede9836-f3e6-403d-9b9e-9e0cba81715e"
  ];
  Color corTextPadrao = Color.fromARGB(190, 100, 100, 100);
  Color corTextPadraoDesable = Color.fromARGB(0, 100, 100, 100);
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  var user_logado = false;
  var ruanometemp="...";
  var enable_barcesta = false;
  User Usuario;
  var firstLoad=false;
  var listViewProdutos  ;
  var completeLoad=false;
  var local_user;
  distanciaLoja distancias;
  var end_temp;
  List<distanciaLoja> listaDist = new List<distanciaLoja>();
  var barcesta;
  var local_end;
  var local_=null;
  var viewListProd=false;
  var listalojasview = listaLojas();
  var listaProdutos;
  final listv = GlobalKey<_MyHomePageState>();
  var bloc = BlocAll();
  var bloc_finance = Bloc_financeiro();
  var positionCesta=45.0;
  var view_barranav=true;
  double _sigmaX = 10.0; // from 0-10
  double _sigmaY = 10.0; // from 0-10
  double _opacity = 0.1; // from 0-1.0
  final bgkey = GlobalKey<RefreshIndicatorState>();
  var view_dialogGps=false;
  var local_user_cancel=false;
  var viewLoad_local=false;
  var scr= new GlobalKey();
  File img = new File('');
  var controller;
  var show_pop_final_pedido=false;
  var modo_teste=false;
  var selecPedido="";

  var hist_pedidoexist=false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent
    ));

    if (v_bg_==true){
        v_bg_=false;
        v_bg=false;
    }

   return
   Scaffold(
          resizeToAvoidBottomInset : false,
          body:
          Container(child:
          Stack(
          children: <Widget>[

        SingleChildScrollView(
          child:
      Column(
          children: <Widget>[
          GestureDetector(onTap: (){ additem(); },
              child:
          Container( margin: EdgeInsets.fromLTRB(15, 80, 0, 0),alignment: Alignment.bottomLeft,
                child:Text("Lojas",
                  style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.orange,fontSize: 16),))),
            Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                height: 128,
                child: listalojasview
               ),
            Container(margin: EdgeInsets.fromLTRB(15, 10, 0, 0),alignment: Alignment.bottomLeft,
                child:Text("Principais produtos",
                            style:
                            TextStyle(fontWeight: FontWeight.bold, color: Colors.orange,fontSize: 16),)),
            Visibility(visible: true,
                child:
                    Column(children: <Widget>[
                                            listaProdutos])),
        ])),

    ///////////
    Visibility(visible: view_barranav,
    child:
    Positioned(bottom: 0, child:
    Container(width: MediaQuery.of(context).size.width, alignment: Alignment.centerRight, child:
    GestureDetector(onTap: (){   },
      child: Container (
        padding:EdgeInsets.fromLTRB(0, 0, 5, 0),
        alignment: Alignment.centerRight,
          child:
        StreamBuilder<String>(
        stream: bloc.get_rua_end,
        builder: (context,value) {
        if (value.connectionState==ConnectionState.active){
          if (value.data!=null)
        return
          barNavBottom("Home",user_logado,""+value.data.toString(),null,(){ open_view_login();});
        else
        return
          Container(alignment: Alignment.centerRight, child:
             barNavBottom("Home",user_logado,ruanometemp,null,(){ open_view_login();}));
        }else{
          return
            Container(alignment: Alignment.centerRight, child:
            barNavBottom("Home",user_logado,ruanometemp,null,(){ open_view_login();}));
        }
    })
      ),
    )))),
//////////////////////////////////////
      Visibility(visible:show_pop_final_pedido,child:pop_returnPedido((){hide_pop_final();})),
//////////////////////////////////////
      Container(
          width: MediaQuery.of(context).size.width,
          height: 70,
          child:CustomPaint(
            painter: headCurve(Colors.orange),
          ),
      ),
       ///////////////////////////////
       Visibility( visible: v_bg_load , child:
              blur_background_load()
          ),
      ////////////////////////////////////
      StreamBuilder<List<Produto_cesta>>(
          stream: bloc.check,
          initialData: [],
          builder: (context,value) {
          if (value.data.length>0){
            if (v_bg==true)
              return blur_background();
            else return Container();
          }else return Container();
          }
          ),

       Visibility(visible:widget. v_poplogin, child:
       Positioned(
        child:
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,child:
            Container(
                width: double.infinity,height: MediaQuery.of(context).size.height,
    margin: EdgeInsets.fromLTRB(0, 0, 0,0.2),   child:
    ClipRect(
      child:  BackdropFilter(
      filter:  ImageFilter.blur(sigmaX:2, sigmaY:2),
      child:  Container(
      decoration:  BoxDecoration(color: Colors.orange[100].withOpacity(.50)),child:
      Container(alignment: Alignment.center, child: autenticacao("login",(value){return _hidepop_login(value);}),))))))),),
        Positioned(
              width: MediaQuery.of(context).size.width,
              bottom:45,
              child:
              StreamBuilder<Pedido>(
              stream: bloc.stream_Prepedido,
              builder: (context,value) {
              if (value.connectionState==ConnectionState.active) {
                print("STREM PRE PEDIDO "+value.data.status );
                if (value.data.status == "prepedido") {
                  view_listaPedidos=true;
                  return Container(height: MediaQuery
                      .of(context)
                      .size
                      .height,
                      child: blur_background_load());
                }else
                    return Container();
              }else
              return Container();

              })),

            Positioned(
                width: MediaQuery.of(context).size.width,
                bottom:bottomBarPedido,
                child:
                StreamBuilder<List<Pedido>>(
                    stream: bloc.stream_pedido,
                    builder: (context,value) {
                      if (value.connectionState==ConnectionState.active) {
                          if (value.data.length>0){
                            print("STREM PEDIDO "+value.data.toString());

                            return
                             Column(children: <Widget>[

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
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child:
                                Container(decoration: BoxDecoration(color: Colors.transparent,boxShadow: [
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
                                )
                            ),
                            Visibility(visible: view_listaPedidos,child:
                      LimitedBox(maxHeight: MediaQuery.of(context).size.height*.8,child:
                      Container(margin: EdgeInsets.fromLTRB(0, 0, 0, 0),child:
                            ListView.builder(
                                padding: EdgeInsets.all(0),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: value.data.length,
                                itemBuilder: (context, index) {
                                  print("STREM PEDIDO "+ selecPedido);
                                  v_bg_load=false;
                                  var ctrol = false;
                                  if (selecPedido==value.data[index].idPedido)
                                    ctrol=true;

                                  if (selecPedido=="" || ctrol){
                                    if ( Usuario != null ) {
                                      if ( value.data[index].status != "cancelado_user" &&
                                           value.data[index].status != "cancelado_user_reembolso" &&
                                           value.data[index].status != "nao_aceito_visto" &&
                                           value.data[index].status != "desativado_finalizado") {
                                        if (pedidoAtivo==false)
                                          pedidoAtivo=true;
                                        return
                                          barPedidoUser(
                                              Usuario, value.data[index], listaDist,ctrol,
                                                  (value) {
                                                return showhide_bg(value);
                                              }, () {
                                            return show_pop_final();
                                          }, (value){return selectPedidoView(value);}) ;
                                      }else
                                      if (value.data[index].status == "cancelado_user_reembolso") {
                                        return Container();
                                      } else{
                                        return Container();}
                                    } else{
                                      return Container();}
                                  }else {
                                    return Container();}
                                }))))
                          ]);}else
                            {
                              print("STREM PEDIDO null ");
//                              bloc.getCesta();
                              return Container();
                            }

                      }else
                        return Container();
                 })),
      Positioned(
        bottom: 45,
        width: MediaQuery.of(context).size.width,
        child:
      StreamBuilder<List<dynamic>>(
        stream: bloc.check,
        builder: (context,value) {
            listaCesta.clear();
            if (value.connectionState==ConnectionState.active) {
              if (value.data.length>0){
                distanciaLoja d;
                for (var i=0;i<listaDist.length;i++){
                  if (listaDist[i].idloja==value.data[0].idloja){
                    d = listaDist[i];
                  }
                }
                cestaAtiva=true;
                listaCesta.addAll(value.data);//adiciona lista de itens da CESTA
return
                Visibility(visible:show_cesta ,child:
                barCesta(false,Usuario, value.data, d,
                            (value) {return showhide_bg(value);},
                            (value){return show_btn_cesta_float();}));
              }else{
                cestaAtiva=false;
                v_bg=false;
                return Container();
              }
            } else {
              cestaAtiva=false;
              return Container();
            }
          })
        ),

            Positioned(
                  bottom: 45,
                  width: MediaQuery.of(context).size.width,
                  child:
                StreamBuilder<List<dynamic>>(
                    stream: bloc.check,
                    builder: (context,value) {
                      listaCesta.clear();
                      if (value.connectionState==ConnectionState.active) {
                        if (value.data.length>0){
                          distanciaLoja d;
                          for (var i=0;i<listaDist.length;i++){
                            if (listaDist[i].idloja==value.data[0].idloja){
                              d = listaDist[i];
                            }
                          }
                          cestaAtiva=true;
                          listaCesta.addAll(value.data);//adiciona lista de itens da CESTA
                          if (Usuario!=null) {

                            print("view barra bottom");
                            return
                            Visibility(visible:!bloc.getPedidoExist() ,child:
                              barCesta(true,Usuario, value.data, d, (value) {
                                return showhide_bg(value);
                              },null));
                          } else{
                            cestaAtiva=false;
                            return Container();}

                        }else{
                          cestaAtiva=false;
                          v_bg=false;
                          return Container();
                        }
                      } else {
                        cestaAtiva=false;
                        return Container();
                      }
                    })),
    Positioned(
    bottom: 45,
    width: MediaQuery.of(context).size.width,
    child:
    StreamBuilder<List<dynamic>>(
    stream: bloc.check,
    builder: (context,value) {
    listaCesta.clear();
    if (value.connectionState==ConnectionState.active) {
      return Visibility(
        visible: bloc.getPedidoExist() && btnfloat && bloc.getCestaExist()  ,child:
       Positioned(
         bottom: 110,
         right: 20,
         child:FloatingActionButton (
          onPressed: (){
            setState(() {
                      btnfloat=false;
              show_cesta=true;
            });
          },
          backgroundColor: Colors.orange,
          child:
          Icon(Icons.shopping_basket),
          )));}else return Container();})),


        Visibility( visible:view_dialogGps , child:

        Container(padding: EdgeInsets.fromLTRB(30, 0, 30,0), child:

        Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

          Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color:Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 3)]) , child:

             Column( mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(alignment: Alignment.center,margin: EdgeInsets.fromLTRB(0, 30, 0, 5),
                    child: Image.asset('isometric_localmap.png',width: 100,height: 100,)),

                Container(alignment: Alignment.center,margin: EdgeInsets.fromLTRB(0, 30, 0, 5), child:
                Text("ATIVAR LOCALIZAÇÃO", style: TextStyle(fontFamily: 'BreeSerif',fontSize: 19))),
                Container(padding: EdgeInsets.fromLTRB(30, 0, 30, 0), alignment: Alignment.center,margin: EdgeInsets.fromLTRB(0, 0, 0, 10), child:
                Text("Para calcular a distância e o frete é necessário ativar sua localização",textAlign: TextAlign.center, style: TextStyle(fontSize: 13,fontFamily: 'RobotoRegular'))),

                Visibility(visible:viewLoad_local,child:
                Container(child: _load_view())),
                Container(alignment: Alignment.center,margin: EdgeInsets.fromLTRB(0, 20, 0, 20), child:

                Visibility(visible:!viewLoad_local,child:
                Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                GestureDetector(onTap: (){ openLocationSetting();
                },child:
                    Container( padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        decoration:
                        BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [BoxShadow(blurRadius:1,color: Colors.grey[300])],color:Colors.white),
                        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),alignment: Alignment.center, child:
                    Text("Ativar", style: TextStyle(fontFamily: 'RobotoBold')))),
                GestureDetector(onTap: (){setState(() {
                  local_user_cancel=true;
                view_dialogGps=false;v_bg_load=false;});},child:
                Container(
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [BoxShadow(blurRadius:1,color: Colors.grey[300])],color:Colors.white),
                      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),alignment: Alignment.center, child:
                  Text("Agora não", style: TextStyle(fontFamily: 'RobotoLight')))),
                ],)))
              ],))
           ],)
        )),
    ])));


 }


 show_btn_cesta_float(){
    setState(() {
//      bloc.control_check.sink.add([]);
      show_cesta=false;
      btnfloat=true;
    });
 }

  barraView(){

    return
      GestureDetector(onTap: () {
        setState(() {
          if (view_listaPedidos) {
            btnfloat=true;
            view_listaPedidos = false;
          } else{
            view_listaPedidos=true;
            btnfloat=false;
          }
        });
      }, child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0,0),
          child:
          ClipRect(
              child:  BackdropFilter(
                filter:  ImageFilter.blur(sigmaX:3, sigmaY:3),
                child:  Container(
                  width: double.infinity,
                  height:  double.infinity,
                  decoration:  BoxDecoration(color: Colors.red[400].withOpacity(.7)),
                  child:
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child:Text("Pedido em andamento",
                          style: TextStyle(fontSize:18,letterSpacing: 0.5,color: Colors.white,fontFamily: 'BreeSerif'),)
                    ),

                    Container(child:Icon(Icons.list,size: 30,color: Colors.white,))
                  ],),
                ),
              ))),
      );
  }

 selectPedidoView(var pedido){
   setState(() {
     selecPedido = pedido;
   });
 }


  hide_pop_final(){

    setState(() {
      show_pop_final_pedido=false;
    });
  }
  show_pop_final(){

    setState(() {
      show_pop_final_pedido=true;
    });
  }



  showhide_bg_blur_pedidoreturn(){

    setState(() {
      v_bg_load=false;
    });

  }


 showhide_bg(var b){

   setState(() {
//      v_bg_load=!b;
      if (b)
        positionCesta=0.0;
      else
        positionCesta=45.0;
    });

 }

@override
void initState() {
  bloc.initBloc();

  listaProdutos = Container();
  checkPermission();
  super.initState();
}

  blur_background(){
    return  Container(
      child: ClipRect(
        child:  BackdropFilter(
          filter:  ImageFilter.blur(sigmaX:2, sigmaY:2),
          child:  Container(
            width: double.infinity,
            height:  MediaQuery.of(context).size.height,
            decoration:  BoxDecoration(color: Colors.transparent),
            child:  Container(
              ),
          ),
        ),
      ),
    );
  }




  @override
  void dispose() {
    super.dispose();
  }


  blur_background_load(){
  return  Container(
    child: ClipRect(
      child:  BackdropFilter(
        filter:  ImageFilter.blur(sigmaX:4, sigmaY:4),
        child:  Container(
          width: double.infinity,
          height:  double.infinity,
          decoration:  BoxDecoration(color: Colors.transparent),
          child:  Container(
              child: Container(alignment: Alignment.center, child:Image.asset('gif_load.gif',width: 50,height: 50,))),
        ),
      ),
    ),
  );
}


 open_view_login(){
   setState(() {
     widget. v_poplogin=true;
   });
 }
  _load_view(){
    return
      Container( alignment: Alignment.center, child:Loading(indicator: BallBeatIndicator() , size: 50.0,color: Colors.red),)
    ;
  }

checkStateUser() async {

 var user = null;
 user = await FirebaseAuth.instance.currentUser();
// isLocationEnabled = await Geolocator().isLocationServiceEnabled();
 setState(()  {
   if (user!=null) {

          print("checkstateuser user 0");
          user_logado = true;
          getDadosUser(user.uid);

   }else{
       completeLoad=true;
       if (local_user_cancel==true){
           viewListProd=true;
           listaProdutos = listaprod();
       }else
         if (modo=="web")
           _getCurrentLocation();
        else
            if (isLocationEnabled==true)
              _getLocation();//PEGA LOCAL CASAO GPS ATIVADO
            else {
              checkStateUser();
              if (!local_user_cancel)
                  view_dialogGps = true;
                  v_bg_load=true;
            }



        }

  });
   return user_logado;
}


 void getDadosUser(var uid) async {

   print("getdados user");
   var document = await Firestore.instance.collection('Usuarios').document(uid);
   document.snapshots()
       .listen((data) => {
         getUser(data,data.documentID)
    });

}

void getUser(var data,var documentID){

    setState(() {
      Usuario = new User(data['nome'],data['tell'],data['email'],data['uid'],data['localizacao']);
    });

    print("user recuperado "+Usuario.email);

    getEnderecoUser();
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
   getDistanciaLoja();

   setState(() {
      if (data.exists) {
          enderecoUser endereco =
          new enderecoUser(data['rua'], data['bairro'], data['numero'], data['complemento'],
                           data['localizacao'],data['temp']);
          local_end = LatLng(endereco.localizacao.latitude,endereco.localizacao.longitude);
          local_user=local_end;
          local_ = local_end;
          getDistanciaLoja();
      }else {
          print("ENDERECO NULL");
          v_bg_load=false;
          getEnderecoUser_temp();
      }
    });
  }

  void getEnderecoUser_temp() async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    var document = await Firestore.instance.collection('Usuarios').document(uid);
    document.collection("endereco").document("automatico").snapshots()
        .listen((data) => {
      setUiEndereco_Temp(data)
    });

  }

  void setUiEndereco_Temp(var data) {
//    getDistanciaLoja();
    setState(() {
      if (data.exists) {
        enderecoUser    endereco = new enderecoUser(
            data['rua'], data['bairro'], data['numero'], data['complemento'],
            data['localizacao'],data['temp']);
        local_end = LatLng(endereco.localizacao.latitude,endereco.localizacao.longitude);
        local_user=local_end;
        local_ = local_end;
        v_bg_load =false;
        getDistanciaLoja();

      }else {
        print("ENDERECO temp NULL");
        _getLocation();
      }
    });
  }

  startViewList(){
    v_bg_load=false;
    listaProdutos = listaprod();
  }


  _getLocation() async {

    if (isLocationEnabled==false)
        isLocationEnabled = await Geolocator().isLocationServiceEnabled();

    if (isLocationEnabled==true){
        var currentLocation = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
        if (local_==null)
        currentLocation = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

        if (currentLocation!=null){
        setState(() {
          local_user = currentLocation;
          local_ = local_user;
          view_dialogGps=false;
          listaProdutos = listaprod();
          viewLoad_local=false;
        });}
    }else{
      setState(() {
        local_user_cancel=false;
        view_dialogGps=true;
          v_bg_load=true;
          _getLocation();
      });
    }

  }

  void resultActiveGps()async{
    bool isLocationEnabled = await Geolocator().isLocationServiceEnabled();
    if (!isLocationEnabled){
      resultActiveGps();
    }else
    if (isLocationEnabled==true)
      _getLocation();
  }

  void openLocationSetting() async {

    if (await Permission.location.request().isGranted) {

      setState(() {
        viewLoad_local=true;
      });
         bool isLocationEnabled = await Geolocator().isLocationServiceEnabled();
         if (isLocationEnabled)
           _getLocation();
         else {
           final AndroidIntent intent = new AndroidIntent(
               action: 'android.settings.LOCATION_SOURCE_SETTINGS');
           await intent.launch();
           resultActiveGps();
         }

    }
  }


  listaprod()  {
    return Container(margin: EdgeInsets.fromLTRB(0, 0, 0, 0),child:
    StreamBuilder(
        stream: Firestore.instance
            .collection("Produtos_On").orderBy("preco",descending: false).orderBy("marca",descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new
              Container();
              break;
            case ConnectionState.none:
              return  Container();
              // TODO: Handle this case.
              break;
            case ConnectionState.active:
              return  listaProdutos =  listaviewProd(snapshot);
              // TODO: Handle this case.
              break;
            case ConnectionState.done:
              return  Container();
              break;
            default:
              break;
          }
        }
      )
    );
  }


  listaviewProd(snapshot){

    return new
    Container(margin: EdgeInsets.fromLTRB(0, 0, 0, 100),child:
    ListView.builder(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: snapshot.data.documents.length,
        itemBuilder: (context, index) {

        if (index == snapshot.data.documents.length-1)
            v_bg=false;

          print ("CRIAR LISTA -");
          Produto_cesta produto =  new Produto_cesta(snapshot.data.documents[index]);
          var ctrl=false;
          double di = 0.0;
          if (local_user==null){
            print ("CRIAR LISTA - LOCAL USER NULL");
            return  itemListProd(produto,null,[],null,(){return _showpop_gps();});
          }
          else {
            if (local_user_cancel == false)
              if (!listaDist.isEmpty) {
                print("CRIAR LISTA - USER OK - LISTADista");
                for (int i = 0; i < listaDist.length; i++) {
                  if (listaDist[i].distancia != null) {
                    di = double.parse(listaDist[i].distancia) / 1000.0;
                    print("distancia xxx " + (di).toString() + "-" +
                        (produto.distanciaMaxKm).toString());
                    if (listaDist[i].idloja== produto.idloja)
                      ctrl = true;
                  }
                }
                if (ctrl == false) {
                  print("CRIAR LISTA - USER OK - distancia off");
                  if (local_user_cancel == false)
                    checkDistanceAtual(produto);
                }else
                  {
                    if (di <= produto.distanciaMaxKm) {
                      print("CRIAR LISTA - USER OK - distancia ON - GET DISTANCE "+listaCesta.length.toString());
                      return itemListProd(produto, local_, listaDist,listaCesta, () {
                        return _showpop_login();
                      });
                    }else
                      return Container();
                  }
              } else {

                print("CRIAR LISTA - USER OK - distancia OFF - lista [] ");
                if (local_user_cancel == false) {
                  print("CRIAR LISTA - USER OK - distancia off - GET DISTANCE");
                  checkDistanceAtual(produto);
                }
                else {
                  print("itemProd -d -f");
                  return itemListProd(produto, null, null,[], () {
                    return _showpop_gps();
                  });
                }
              }
            if (local_user_cancel == false) {
              if (di <= produto.distanciaMaxKm) {
                print("CRIAR LISTA - USER OK - distancia ON - GET DISTANCE");
                return itemListProd(produto, local_, listaDist,null, () {
                  return _showpop_login();
                });
              }else
                return Container();
            } else {
              print("itemProd -d -f");
              return itemListProd(produto, null, [],null, () {
                return _showpop_gps();
              });
            }
          }
        }
    ));
  }


  additem()async{

    var refData = Firestore.instance;
      await refData.collection("Produtos_On")
          .add({"gelada":true,'descricao':'LongNeck',"nome": "Heineken", "preco": 2.5, "vol": "330ml", "loja": "loja brejapp",
        "img":"https://firebasestorage.googleapis.com/v0/b/brejapp-flutter.appspot.com/o/heineken_1.png?alt=media&token=820319cf-51a3-45ce-8d92-934d3bd31f91",
        "quantidade": 0, "id": "007", "cesta": null, "tags": ["cerveja", "skol","pilsen", "lata"],
        "marca": "Heineken", "gelada": true, "coefKm": 1.2, "idloja": "001", "distanciaMaxKm": 20, "distanciaGratisKm": 15,
        "localizacao":new GeoPoint(-1.433361, -48.472075),
        "cartaoApp": true,"maquinaCartao": true})
          .then((v){
      print("adtime");
      });

  }


  _showpop_gps(){

   setState(() {
      print("SHOW GPS POP");
      local_user_cancel=false;
      view_dialogGps=true;
      v_bg_load=true;

    });
  }

  criarProdutoLista(Produto_cesta produto){

    if (listaCesta.length>0){
    for (int i=0;i<listaCesta.length;i++){
      if (listaCesta[i].id==produto.id){
        print("item na cesta");
        produto.quantidade=listaCesta[i].quantidade;
        return produto;
      }
    }
    }else
    if (listaCesta.length==0){
      return null;
    }else
      return null;

  }
  _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  _showpop_login(){
    setState(() {
      if (!user_logado)
        widget.v_poplogin=true;
    });
  }


  _hidepop_login(bool result){
    setState(() {
      widget.v_poplogin=false;
      //returno cadastro realizado
      if (result==true)
        {
          print("checkstateuser x");
          if (end_temp!=null){
            enviarFormEndereco_temp(end_temp);
          }
          if (listaDist!=null){
            for(int i =0;i<listaDist.length;i++) {
              addDistance(listaDist[i],null);
            }
          }

          listaProdutos = listaprod();

        }
    });
 }


  _decrementQntd(val){
    if (val>0)val--;
    return 0.0;
  }

  _incrementQntd(val){
    if (val<100)val++;
    return 10.0;
  }

  checkPermission() async {

    if (modo=="web")
      checkStateUser();
    else
    if (await Permission.location
        .request()
        .isGranted) {

         checkStateUser();
    } else {
      setState(() {
      v_bg_load=false;
      v_bg=false;
      });
    }
  }


  success(pos) {
    try {
      print(pos.coords.latitude);
      print(pos.coords.longitude);
      if (pos.coords!=null){
        setState(() {
          local_user = new LatLng(pos.coords.latitude,pos.coords.longitude);
          local_ = local_user;
          view_dialogGps=false;
          v_bg_load=false;
          listaProdutos = listaprod();
          viewLoad_local=false;
        });}
    } catch (ex) {
      print("Exception thrown : " + ex.toString());
    }
  }
  _getCurrentLocation() {
    print("_getCurrentLocation");
     // getCurrentPosition(allowInterop((pos) => success(pos)));
    }

  getDistanciaLoja() async{
    print("LISTA DIST 1");

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user!=null){
      await Firestore.instance.collection("Usuarios")
          .document(user.uid).collection("distancias")
          .snapshots()
          .listen((data) => {
          setllocal  (data.documents)
      });
    }

    listaProdutos = listaprod();

  }


  setllocal(var data){
    print("set local update");
    distanciaLoja d;
    listaDist = new List<distanciaLoja>();
    if (!data.isEmpty){
        for(int i=0;i<data.length;i++){
         d = new distanciaLoja(data[i]['loja'],data[i]['distancia'],data[i]['duracao'],data[i]['idloja']);
            listaDist.add(d);
        }
        setState(() {
          viewListProd=true;
          v_bg_load=false;
          listaProdutos = listaprod();

          print("LISTA DIST 2");
        });
    }else
      {
        setState(() {
//          _getLocation();
//          v_bg_load=false;
          viewListProd=true;
        });
      }

  }


_getLocationUser(produto) async {

    if (isLocationEnabled==false)
      isLocationEnabled = await Geolocator().isLocationServiceEnabled();

    if (isLocationEnabled==true){
      var currentLocation = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      local_user = currentLocation;
      setState(() {
        local_ = local_user;
        print("GET LOCATIOON");
        checkDistanceAtual(produto);
      });
    }else{
//      openLocationSetting();
    print("getLoca");
    local_user_cancel=false;
        view_dialogGps=true;
      v_bg_load=true;
    }
  }

checkDistanceAtual(produto) async {

    if (local_user==null) {
      if (local_user_cancel==false)
        _getLocationUser(produto);
    } else
      if (local_user!=null) {
        var ctrol = false;
        for (int i=0;i<listaDist.length;i++){
            if (listaDist[i].idloja==produto.idloja)
                ctrol=true;
        }

      if (ctrol==false){
        distanciaLoja distancia = distanciaLoja(produto.loja, null,null,produto.idloja);
        listaDist.add(distancia);

        String lat2 = produto.localizacao.latitude.toString();
            String lng2 = produto.localizacao.longitude.toString();
            String lat1 = local_user.latitude.toString();
            String lng1 = local_user.longitude.toString();
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

        ruanometemp=rua;

        enderecoUser endUserTemp = new enderecoUser(rua, bairro, numero, "", GeoPoint(local_user.latitude,local_user.longitude),true);

        distancia = new distanciaLoja(produto.loja, d,duration,produto.idloja);

        for (int i=0;i<listaDist.length;i++){
          if (listaDist[i].idloja==produto.idloja)
            setState(() {
              listaDist[i].distancia=d;
              listaDist[i].duracao=duration;
              listaProdutos = listaprod();
            });
        }

        end_temp= endUserTemp;
        enviarFormEndereco_temp(endUserTemp);
        addDistance(distancia, produto);
        v_bg_load=false;

      }
    }
  }
  enviarFormEndereco_temp(enderecoUser endereco) async{
    var refData = Firestore.instance;

    print ("enviarFormEndereco_temp");
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user!=null) {
      var uid = user.uid;
      await refData.collection("Usuarios")
          .document(uid)
          .collection("endereco").document("automatico")
          .setData(endereco.getenderecoUser());
    }else
      {print("erro send end_temp");
      }
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
        viewListProd=false;
        viewListProd=true;

      });
    }else{
      print ("addDistance erro - user null");
    }


  }



  refresh(){
    setState(() {

    });
  }


  }


