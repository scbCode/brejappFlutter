
import 'package:android_intent/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore/BlocAll.dart';
import 'package:flutter_firestore/Bloc_finaceiro.dart';
import 'package:flutter_firestore/Produto_cesta.dart';
import 'package:flutter_firestore/User.dart';
import 'package:flutter_firestore/distanciaLoja.dart';
import 'package:flutter_firestore/enderecoUser.dart';
import 'package:flutter_firestore/itemListProd.dart';
import 'package:flutter_firestore/listaLojas.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';
import 'package:permission_handler/permission_handler.dart';


class listaProdutos extends StatefulWidget {
  var view_resumo_cesta=false;

  listaProdutos ();


  @override
  listaProdutoState createState() => listaProdutoState ();

}


class listaProdutoState  extends State<listaProdutos> {

  bool v_bg=false;
  bool v_bg_=false;
  bool v_bg_load=true;

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

  @override
  Widget build(BuildContext context) {



    return listaprod();
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
              return   listaviewProd(snapshot);
              // TODO: Handle this case.
              break;
            case ConnectionState.done:
              return  Container();
              break;
          }
        }
    )
    );
  }


  listaviewProd(snapshot){

    return

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
          Produto_cesta produto = new Produto_cesta(snapshot.data.documents[index]);
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
                    if (listaDist[i].loja == produto.loja)
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


//  open_view_login(){
//    setState(() {
//      widget. v_poplogin=true;
//    });
//  }
  _load_view(){
    return
      Container( alignment: Alignment.center, child:Loading(indicator: BallBeatIndicator() , size: 50.0,color: Colors.red),)
    ;
  }

  checkStateUser() async {

    var user = await FirebaseAuth.instance.currentUser();
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
    document.collection("endereco").document("Entrega_temp").snapshots()
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



  additem()async{

    var refData = Firestore.instance;
    await refData.collection("Produtos_On")
        .add({"gelada":true,'descricao':'LongNeck',"nome": "Heineken", "preco": 2.5, "vol": "330ml", "loja": "Lojay",
      "img":"https://firebasestorage.googleapis.com/v0/b/brejapp-flutter.appspot.com/o/heineken_1.png?alt=media&token=820319cf-51a3-45ce-8d92-934d3bd31f91",
      "quantidade": 0, "id": "007", "cesta": null, "tags": ["cerveja", "skol","pilsen", "lata"],
      "marca": "Heineken", "gelada": true, "coefKm": 1.2, "distanciaMaxKm": 20, "distanciaGratisKm": 15,
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
//      if (!user_logado)
//        widget.v_poplogin=true;
    });
  }


  _hidepop_login(bool result){
    setState(() {
//      widget.v_poplogin=false;
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
    distanciaLoja d;
    if (!data.isEmpty){
      listaDist = new List<distanciaLoja>();
      for(int i=0;i<data.length;i++){
        d = new distanciaLoja(data[i]['loja'],data[i]['distancia'],data[i]['duracao']);
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
        if (listaDist[i].loja==produto.loja)
          ctrol=true;
      }

      if (ctrol==false){
        distanciaLoja distancia = distanciaLoja(produto.loja, null,null);
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

        distancia = new distanciaLoja(produto.loja, d,duration);

        for (int i=0;i<listaDist.length;i++){
          if (listaDist[i].loja==produto.loja)
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
          .collection("endereco").document("Entrega_temp")
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
          .document(distancia.loja)
          .setData(distancia.getdistanciaLoja());

      setState(() {
        viewListProd=false;
        viewListProd=true;

      });
    }else{
      print ("addDistance erro - user null");
    }


  }
  @override
  void initState() {
    bloc.initBloc();

    listaProdutos = Container();
    checkPermission();
    super.initState();
  }

}