

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_firestore/prePedido.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'LineAnim.dart';
import 'Produto_cesta.dart';
import 'User.dart';
import 'barCesta.dart';
import 'distanciaLoja.dart';
import 'dart:typed_data';

class barPedidoUser extends StatefulWidget  {

  List<Produto_cesta> pedidolista = new List<Produto_cesta>();
  Pedido pedido = new Pedido();
  List<distanciaLoja> listaDistancia_ ;
  show_blur_bg call_back_show_bg;
  User user;


  barPedidoUser (this.user,this.pedido,this.listaDistancia_,this.call_back_show_bg);

  @override
  barPedidoUserState createState() => barPedidoUserState();

}


class barPedidoUserState extends State<barPedidoUser>   with TickerProviderStateMixin{

  AnimationController _controllerIcon;
  AnimationController _controllerIcon_moto;
  BitmapDescriptor myIcon;
  var w_anim=false;
  var v_w_animi=200.0;
  var v_w_animtime=700;
  var status_entrega=false;
  var status_confirmacao=true;
  var statustext="";
  var line;
  GoogleMapController mapController;
  Animation<RelativeRect> rectAnimation;
  Animation<Offset> animation;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS



  @override
  Widget build(BuildContext context) {
    return barCestaCompleta();
  }

  barCestaCompleta(){


    if (widget.pedido.status=="aguardando") {
      setState(() {

      statustext = "Aguardando confirmação";
      status_confirmacao=false;
      status_entrega=false;
      });

    }

    if (widget.pedido.status=="confirmado") {
      setState(() {
        statustext = "Seu pedido está sendo preparado";
      status_confirmacao=true;
      status_entrega=false;
      });
    }
    if (widget.pedido.status=="entrega") {
      setState(() {
        statustext = "Seu pedido saiu para entrega";
        status_confirmacao=true;
        status_entrega=true;
     });
  }

    return
//Container(decoration: BoxDecoration(color: Colors.transparent),child:
      SingleChildScrollView(child:
        Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[

        Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[

//        Visibility(visible: view_resumo_cesta || pagSelect,
//        child:blur_bg),

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
                barra()
            ),
    Visibility(visible:true, child:
    LimitedBox(maxHeight:MediaQuery.of(context).size.height*.7,child:
    SingleChildScrollView(child:
    Container(
    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
    decoration: BoxDecoration(color: Colors.white,boxShadow: [
    BoxShadow( color: Colors.black12,blurRadius:4.0,
    offset: Offset(0.0,45.0,  ),)
    ],),
    child:
    Column(
    children: <Widget>[
          Container(

              width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color:Colors.white),
            child:Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround ,
                children: [
            Container(padding: EdgeInsets.all(5),
                  child:Text("Loja xxyy",style: TextStyle(fontFamily: 'RobotoBold',fontSize: 16,color: Colors.black),)),
            ]),


            Container(
                margin: EdgeInsets.fromLTRB(10, 0, 50,10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color:Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey[500],blurRadius: 4,offset: Offset(-2,10.0) ),
                    ]),
                child:
              Column(children: [
              Container(padding: EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child:
                  Text(statustext,
                    style: TextStyle(fontFamily: 'BreeSerif',fontSize: 14,color: Colors.orange[700]),)),

              //BARRA TIME PEDIDO STATUS
              Container(padding: EdgeInsets.fromLTRB(10, 0, 0, 0),child:
              Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    Container(
                      child:Icon(Icons.shopping_basket,size: 25,color: Colors.orange,)
                    ),
                      Stack(children: [
                        Container(
                          width: (MediaQuery.of(context).size.width)/4,
                          child: Container(height: 4,
                              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
                             ),
                        ),

                        Visibility(
                            visible:!status_entrega &&  !status_confirmacao,
                            child:
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                          width: (MediaQuery.of(context).size.width)/4,
                          child:line,
                        )),
                        Visibility(
                            visible:status_confirmacao ,
                            child:    Container(
                              width: (MediaQuery.of(context).size.width)/4,
                              child: Container(height: 4,
                                  decoration: BoxDecoration(color: Colors.orange),
                                  padding: EdgeInsets.all(0)),
                            )),
                      ]),
                      Visibility(
                        visible:status_confirmacao ,
                        child:
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child:Image.asset('online-shopping.png',width: 30,)),
                      ),

                      Visibility(
                        visible: !status_confirmacao,
                        child:
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child:Image.asset('lojaoff_.png',width:30 ,)),
                      ),

                      Stack(children: [
                        Container(
                          width: (MediaQuery.of(context).size.width)/4,
                          child: Container(height: 4,
                              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
                              padding: EdgeInsets.all(0)),
                        ),
                        Visibility(
                            visible:!status_entrega && status_confirmacao ,
                            child:
                        Container(
                          width: (MediaQuery.of(context).size.width)/4,
                          margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                          child: line,
                        )),
                        Visibility(
                            visible:status_entrega && status_confirmacao ,
                            child:    Container(
                          width: (MediaQuery.of(context).size.width)/4,
                          child: Container(height: 4,
                              decoration: BoxDecoration(color: Colors.orange),
                              padding: EdgeInsets.all(0)),
                        )),
                      ]),

                      Stack(children: [

                          Visibility(
                            visible:true ,
                            child:
                            Opacity(
                              opacity: 0.5,
                              child:
                            Container(
                                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child:Image.asset('delivery-man-off.png',width: 45,))),
                          ),

                        Visibility(
                          visible:status_entrega ,
                          child:
                          SlideTransition(
                              position: animation,
                              child:
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child:Image.asset('delivery-man.png',width: 45,))),
                        ),

                      ],),
           ],)),
              Visibility(
                  visible:status_entrega ,
                  child:
                Text( infoDistanciaTime())),

              ])),

              Divider(color:Colors.red)],)),


          Container(
              padding: EdgeInsets.fromLTRB(10, 0,10,0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color:Colors.white),
              child:Icon(Icons.keyboard_arrow_up,color: Colors.orange[700],) ),

          Visibility(
              visible: false,
              child:
          Container(
                      decoration:
                      BoxDecoration(color:Colors.white,borderRadius:BorderRadius.only(topRight: Radius.circular(20))),
                      height: 130,
                  alignment: Alignment.center, child:
                  GoogleMap(
                    onMapCreated:  _onMapCreated,
                    zoomControlsEnabled: false,
                    buildingsEnabled: true,
                    rotateGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    mapType: MapType.normal,
                    markers: Set<Marker>.of(markers.values),
                    initialCameraPosition:  CameraPosition(
                        target:new LatLng(widget.pedido.lista_produtos[0]['localizacao'].latitude,widget.pedido.lista_produtos[0]['localizacao'].longitude),
                        zoom: 16.0,
                        tilt: 45
                    ),
                  ))),


            Container(
              padding: EdgeInsets.fromLTRB(10, 10,10,20),
                width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color:Colors.white),
            child:
          Container(
              padding: EdgeInsets.fromLTRB(10, 10,10,20),
              decoration: BoxDecoration(color:Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey[500],blurRadius: 4,offset: Offset(-2,2.0) ),
                  ]),
              child: Column(children: [

                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(10, 10,10,0),
                  child:    Text("Endereço de entrega",
                    style: TextStyle(color:Colors.black,fontSize: 12,
                      fontFamily: 'BreeSerif'),)),

                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(10, 0,10,0),
                    child:    Text( getEnderecoText(),
                      style: TextStyle(color:Colors.black,fontSize: 14,
                          fontFamily: 'RobotoLight'),)),


                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(10, 10,10,0),
                    child:    Text("Forma de pagamento",
                      style: TextStyle(color:Colors.black,fontSize: 12,
                          fontFamily: 'BreeSerif'),)),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(10, 0,10,10),
                    child:    Text(getTipoPag(),
                      style: TextStyle(color:Colors.black,fontSize: 14,
                          fontFamily: 'RobotoLight'),)),


                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(10, 0,10,0),
                    child:    Text("Lista de produtos",
                      style: TextStyle(color:Colors.black,fontSize: 12,
                          fontFamily: 'BreeSerif'),)),

                  Container(

                    decoration:BoxDecoration(color:Colors.grey[200]),
                      padding: EdgeInsets.fromLTRB(10, 0,10,0),
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child:
                  ListView.builder(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.pedido.lista_produtos.length,
                      itemBuilder: (context, index) {
                                return  itemProd(index);
                      })),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(10, 5,10,20),

                    child:    Text(totalTxt(),textAlign: TextAlign.center,
                      style: TextStyle(color:Colors.black,fontSize: 16,
                          fontFamily: 'BreeSerif'),)),

                  Row(children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 5,10,10),
                        child:    Text("Chat",textAlign: TextAlign.left,
                          style: TextStyle(color:Colors.blue,fontSize: 16,
                              fontFamily: 'BreeSerif'),)),
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 5,10,10),
                        child: new FlatButton(
                        onPressed: () => UrlLauncher.launch("tel://5591989716453"),
                        child:   Text("Ligar",textAlign: TextAlign.left,
                                              style: TextStyle(color:Colors.green[400],fontSize: 16,
                              fontFamily: 'BreeSerif'),))),
                    Container(
                        alignment: Alignment.center ,
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.green)),
                        padding: EdgeInsets.fromLTRB(10, 2,10,5),
                        child:    Text("Já chegou!",textAlign: TextAlign.left,
                          style: TextStyle(color:Colors.green[400],fontSize: 16,
                              fontFamily: 'BreeSerif'),)),
                  ],)
          ],) )),

      Row(children: [
    Container(
      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
    padding: EdgeInsets.fromLTRB(10, 10,10,10),
    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.black)),
    child:   Text("AJUDA")),
    Container(
        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
        padding: EdgeInsets.fromLTRB(10, 10,10,10),
    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.black)),
    child:   Text("MEU PEDIDO NÃO CHEGOU")),
      ],),
    Container(
        alignment: Alignment.center ,
        margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
        padding: EdgeInsets.fromLTRB(10, 10,10,10),
    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.black)),
    child:  Text("OCORREU UM PROBLEMA")),

      Container(
          alignment: Alignment.center ,
          margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
          padding: EdgeInsets.fromLTRB(10, 10,10,10),
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.black)),
          child:    Text("FAZER DENÚNCIA")),
    ])))))])
  ]));
  }
  Future<void> _add() async {
    var markerIdVal = "122";
    final MarkerId markerId = MarkerId(markerIdVal);
    var pos = new LatLng(widget.pedido.lista_produtos[0]['localizacao'].latitude,widget.pedido.lista_produtos[0]['localizacao'].longitude);
    await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'tick.png')
        .then((onValue) {
          setState(() {
            myIcon = onValue;

          });
    });
    // creating a new MARKER
    final Marker marker = await Marker(
      markerId: markerId,
      icon:myIcon,
      position: LatLng(
    pos.latitude ,
    pos.longitude
      ),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {

      },
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  totalTxt(){
    var text="";
      text = "Total: R\u0024 "+getPrecoFormat(widget.pedido.total);
    return text;
  }
  getPrecoFormat(preco){
    preco = preco.toStringAsFixed(2).toString();
    preco=preco.replaceAll(".", ",");

    return preco;
  }

  getTipoPag(){

    var text="";
    var tipo= widget.pedido.tipoPagamento;
    if (tipo=="maquina")
      text = "Máquina de cartão";
    if (tipo=="dinheiro")
      text = "Dinheiro";
    if (tipo=="cartao")
      text = "Cartão de crédito - "+widget.pedido.statusPagamento;
    return text;

  }

  getEnderecoText(){
    var text="";
        text = widget.pedido.enderecoEntrega['rua']+", "+widget.pedido.enderecoEntrega['bairro']
            +", "+widget.pedido.enderecoEntrega['numero']
            +", "+widget.pedido.enderecoEntrega['complemento'];
    return text;

  }

  infoDistanciaTime(){
    var text="";
    for(int i = 0;i < widget.listaDistancia_.length;i++) {
        if (widget.listaDistancia_[i].loja=="loja brejapp"){
          text = formatDistancia(i)+" - previsão "+widget.listaDistancia_[i].duracao;
        }
    }
    return text;
  }

  formatDistancia(var index){

    var unidadeMedida="";
    double valeu = double.parse(widget.listaDistancia_[index].distancia);
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
);
  }
  barraView(){
    return
      GestureDetector(onTap: () {
        setState(() {

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

                    Container(child:Icon(Icons.arrow_drop_down,size: 35,color: Colors.white,))
                  ],),
                ),
              ))),
      );
  }
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _add();
  }
  itemProd(var index){

   print("total itens "+ widget.pedido.lista_produtos[index]['img'].toString());
   var text = widget.pedido.lista_produtos[index]['quantidade'].toString()
       +"x "+widget.pedido.lista_produtos[index]['nome'].toString()
    +"\n"+widget.pedido.lista_produtos[index]['vol'].toString();

    return   Row(children: [

      Text(text,textAlign: TextAlign.right,
      style: TextStyle(color:Colors.black,fontSize: 14,
          fontFamily: 'RobotoLight'),),
    Image.network(widget.pedido.lista_produtos[index]['img'].toString(),height: 50,)
    ],);
  }

  @override
  void initState() {
    super.initState();
    line=LineAnim();
    _controllerIcon_moto = AnimationController(duration: Duration(milliseconds:1500),vsync: this)..repeat();
    animation = Tween<Offset>(begin: Offset(.0, 0), end: Offset(2, 0)).animate(_controllerIcon_moto);
  }

  @override
  void dispose() {
    _controllerIcon_moto.dispose();
    super.dispose();

  }

}