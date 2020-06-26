

import 'dart:io';
import 'dart:ui';

import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_firestore/Bloc_finaceiro.dart';
import 'package:flutter_firestore/prePedido.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher.dart';
import 'BlocAll.dart';
import 'LineAnim.dart';
import 'Loja.dart';
import 'Produto_cesta.dart';
import 'User.dart';
import 'barCesta.dart';
import 'distanciaLoja.dart';
import 'dart:typed_data';
import 'package:flutter_firestore/pop_returnPedido.dart';

import 'enderecoUser.dart';
import 'enderecoUserSnapShot.dart';
import 'form_endereco_user.dart';

typedef show_pop_final =  Function();
typedef select_pedido = String Function(String);

class barPedidoUser extends StatefulWidget  {

  List<Produto_cesta> pedidolista = new List<Produto_cesta>();
  Pedido pedido = new Pedido();
  List<distanciaLoja> listaDistancia_ ;
  show_blur_bg call_back_show_bg;
  select_pedido call_back_selectPedido;
  show_pop_final call_show_pop_final;
  User user;
  bool openResumo=false;


  barPedidoUser (this.user,this.pedido,this.listaDistancia_,this.openResumo,this.call_back_show_bg,this.call_show_pop_final,this.call_back_selectPedido);

  @override
  barPedidoUserState createState() => barPedidoUserState();

}


class barPedidoUserState extends State<barPedidoUser>   with TickerProviderStateMixin{

  AnimationController _controllerIcon;
  AnimationController _controllerIcon_moto;
  BitmapDescriptor myIcon;
  enderecoUser end_user_ ;
  var w_anim=false;
  var v_w_animi=200.0;
  var v_w_animtime=700;
  var status_entrega=false;
  var status_nao_aceito=false;
  var status_confirmacao=true;
  var txt_time_pedido="";
  var txt_time_confirmacao="";
  var txt_time_entrega="";
  var scale=3.9;
  var scaleentrega=3.95;
  var statustext="";
  var view_statusbar_pedido=true;
  var line;
  var view_ajuda=false;
  var view_ajuda_pedido=false;
  var view_ocorreu_um_problema=false;
  var view_botoes_fazer_denuncia=false;
  var bottompop=0.0;
  var bottompopchat=0.0;
  TextEditingController control_chattext = new TextEditingController();
  var view_field_pedidoerrado=false;
  var view_field_denuncia=false;
  var view_denunc_btn_prodeng=false;
  var view_denunc_btn_preceeng=false;
  var view_denunc_btn_outro=false;
  ScrollController _scrollController = new ScrollController();
  ScrollController _scrollController_pop = new ScrollController();
  ScrollController _scrollController_listchar = new ScrollController();

  var testAjudamsn="";
  var msgDenuncia="";
  var origemDenuncia="";
  var veiw_voltar_2=false;
  var veiw_voltar_enviar_pedidoerrado=false;
  var bg_pop_pedido=false;
  var pop_pedido_view=false;
  var bg_pop_end=false;
  var bg_pop_end_view=false;
  var pop_precess_cancel=false;
  var bloc = BlocAll();
  var bloc_financeiro = Bloc_financeiro();
  var view_chat=false;
  var pop_chat_;
  var diff_hora;
  var view_btn_confirm_cancel=false;
  var view_btn_reebolso=true;
  var view_btn_reebolso_confirma=false;
  var tellloja;
  GoogleMapController mapController;
  Animation<RelativeRect> rectAnimation;
  Animation<Offset> animation;
  var pop_final=false;
  var pedido_nao_aceito=true;
  var view_resumo_pedido=true;
  var listachat;
  var pedidoOpenView;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS



  @override
  Widget build(BuildContext context) {
    print(widget.pedido.idloja);

    return    barCestaCompleta();

  }
  
  

  barCestaCompleta(){
    print(widget.pedido);
    DateTime now = DateTime.now();
    DateTime data_pedido = widget.pedido.time.toDate();
    diff_hora = now.difference(data_pedido).inHours;
    print(MediaQuery.of(context).viewInsets.bottom);
    
    if (txt_time_pedido=="")
        txt_time_pedido  = data_pedido.hour.toString()+":"+ data_pedido.hour.toString();


    if (MediaQuery.of(context).viewInsets.bottom!=0){
        bottompopchat=120.0;
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _scrollController_pop.animateTo(
            _scrollController_pop.position.maxScrollExtent,
            duration: const Duration(milliseconds: 10),
            curve: Curves.easeOut,);
        });
    }
    else
      {
        bottompopchat=0.0;

      }
    
    if (diff_hora>=2){

    }
    if (widget.pedido.status=="aguardando") {
        setState(() {
          scale=3.5;
          statustext = "Aguardando confirmação";
          status_confirmacao=false;
          status_entrega=false;
          pedido_nao_aceito=true;
          status_nao_aceito=false;
        });
    }

    if (widget.pedido.status=="confirmado") {
      setState(() {
        DateTime data_pedido_confirma =widget.pedido.timeConfirmado.toDate();
        txt_time_confirmacao =  "" +data_pedido_confirma.hour.toString()+" "+data_pedido_confirma.minute.toString();
        scale=3.5;
        statustext = "Seu pedido está sendo preparado";
      status_confirmacao=true;
      status_entrega=false;
      });
    }
    if (widget.pedido.status=="nao_aceito") {
      pedido_nao_aceito=false;
      status_nao_aceito=true;
    }
    if (widget.pedido.status=="entrega") {
      setState(() {
        scale=12;
        DateTime data_pedido_confirma_ =widget.pedido.timeConfirmado.toDate();
        txt_time_confirmacao =  "" +data_pedido_confirma_.hour.toString()+" "+data_pedido_confirma_.minute.toString();

//        DateTime data_pedido_entrega =widget.pedido.timeEntrega.toDate();
   //     txt_time_entrega =  "" +data_pedido_entrega.hour.toString();
//
        scaleentrega=12;
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
        Visibility(visible:true, child:
        LimitedBox(maxHeight:MediaQuery.of(context).size.height*.720,child:
        SingleChildScrollView(
            controller:_scrollController_pop,
            child:
        Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          decoration: BoxDecoration(color: Colors.grey[200],
            boxShadow: [
          BoxShadow( color: Colors.grey,
          offset: Offset(0.0,0.0,  ),)
        ],),
        child:
        Stack(
            children: <Widget>[
          Visibility(
              visible:true,
              child:
          Column(
           children: <Widget>[
           Container(
              decoration: BoxDecoration(
              ),
              child:
            Column(children: [
            Visibility(
                    visible:pedido_nao_aceito,
                    child:
        GestureDetector(onTap:(){
          setState((){
            if (!widget.openResumo) {
            //view_resumo_pedido=true;
              widget.call_back_selectPedido(widget.pedido.idPedido);
            }else{
              widget.call_back_selectPedido("");
              // widget.openResumo=false;
            }
//          if (view_resumo_pedido)view_resumo_pedido=false;else view_resumo_pedido=true;});
            });} ,child:
            Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0,10),
                decoration: BoxDecoration(color:Colors.white,
                    borderRadius:BorderRadius.all(Radius.circular(20)),
                    boxShadow: [BoxShadow(color: Colors.grey[500],offset: Offset(0,0.0) ),
                    ]),
                child:
                    
              Column(children: [

                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround ,
                      children: [
                        Container(padding: EdgeInsets.all(5),
                            child:Text("Loja xxyy",style: TextStyle(fontFamily: 'RobotoBold',fontSize: 16,color: Colors.black),)),

                  Container(padding: EdgeInsets.all(5),
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child:
                    Text(statustext,
                      style: TextStyle(fontFamily: 'BreeSerif',fontSize: 14,color: Colors.orange[700]),)),
                ]),

              Container(padding: EdgeInsets.fromLTRB(10, 0, 0, 0),child:
              Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      
                    Column( children: [
                        Container(
                            margin: EdgeInsets.fromLTRB(0,15,0,0),
                            padding: EdgeInsets.all(5),
                            decoration:   BoxDecoration(color:Colors.orange,
                                borderRadius:BorderRadius.all(Radius.circular(30))),
                            child:Icon(Icons.shopping_basket,size: 22,color: Colors.white,)
                        ),
                       Text(txt_time_pedido,style:TextStyle(color:Colors.grey,fontSize:10))
                      ]),

                      Stack(children: [
                        Container(
                          width: (MediaQuery.of(context).size.width)/scale,
                          child: Container(height:2,
                              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
                             ),
                        ),

                        Visibility(
                            visible:!status_entrega &&  !status_confirmacao,
                            child:
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                          width: (MediaQuery.of(context).size.width)/scale,
                          child:line,
                        )),
                        Visibility(
                            visible:status_confirmacao ,
                            child:    Container(
                              width: (MediaQuery.of(context).size.width)/scale,
                              child: Container(height: 2,
                                  decoration: BoxDecoration(color: Colors.orange),
                                  padding: EdgeInsets.all(0)),
                            )),
                      ]),
                      Visibility(
                        visible:status_confirmacao  ,
                        child:
                    Column( children: [
                    Container(
                            margin: EdgeInsets.fromLTRB(0,15,0,0),
                            padding: EdgeInsets.fromLTRB(10,10,10,10),
                            decoration:   BoxDecoration(color:Colors.orange,
                                borderRadius:BorderRadius.all(Radius.circular(50))),
                            child:Image.asset('online-shopping.png',width: 15,)),
                      Text(txt_time_confirmacao,style:TextStyle(color:Colors.grey,fontSize:10))
                     ] ),
),
                      Visibility(
                        visible: !status_confirmacao,
                        child:
                        Container(
                            margin: EdgeInsets.fromLTRB(0,0,0,0),
                            padding: EdgeInsets.fromLTRB(5,10,5,10),
                            decoration:   BoxDecoration(color:Colors.grey[200],
                                borderRadius:BorderRadius.all(Radius.circular(50))),

                            child:Image.asset('lojaoff_.png',width:30 ,)),
                      ),

                      Stack(children: [
                        Container(
                          width: (MediaQuery.of(context).size.width)/scale,
                          child: Container(height: 2,
                              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
                              padding: EdgeInsets.all(0)),
                        ),
                        Visibility(
                            visible:status_confirmacao ,
                            child:
                        Container(
                          width: (MediaQuery.of(context).size.width)/scale,
                          margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                          child: line,
                        )),
                        Visibility(
                            visible:status_entrega && status_confirmacao ,
                            child:    Container(
                          width: (MediaQuery.of(context).size.width)/scaleentrega,
                          child: Container(height: 2,
                              decoration: BoxDecoration(color: Colors.orange),
                              padding: EdgeInsets.all(0)),
                        )),
                      ]),
              Visibility(
                   visible:  !status_entrega ,
                   child:   Container(
                   margin: EdgeInsets.fromLTRB(0,5,0,2),
                   padding: EdgeInsets.fromLTRB(2,10,10,10),
                   decoration:   BoxDecoration(color:Colors.grey[200],
                   borderRadius:BorderRadius.all(Radius.circular(100))),
                   child: Image.asset('delivery-man-off.png',width: 30)
            )),

          Stack(children: [
                Visibility(
                          visible:status_entrega ,
                          child:
                      Column( children: [

                            Container(
                                margin: EdgeInsets.fromLTRB(0,15,0,2),
                                padding: EdgeInsets.fromLTRB(2,10,10,10),
                                decoration:   BoxDecoration(color:Colors.orange,
                                    borderRadius:BorderRadius.all(Radius.circular(100))),
                                child:               Opacity(
                                    opacity: 1,
                                    child:Image.asset('delivery-man-off.png',width: 45
                                      ,))),
                          Text(txt_time_entrega ,style: TextStyle(fontSize: 10,color:Colors.grey)),])
                      ),



                      ],),

                      Visibility(
                          visible:status_entrega ,
                          child:
                          Container(
                            width: (MediaQuery.of(context).size.width)/3.5,
                            margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                            child: line,
                          )),
                      Visibility(
                        visible:status_entrega ,
                        child:

                        Container(
                            margin: EdgeInsets.fromLTRB(0,0,0,0),
                            padding: EdgeInsets.fromLTRB(5,5,5,5),
                            decoration:   BoxDecoration(color:Colors.orange,
                                borderRadius:BorderRadius.all(Radius.circular(50))),
                          child: Icon(Icons.home,color:Colors.white)
                       ),
                      ),
           ],)),
           Visibility(
                  visible:status_entrega ,
                  child:
                Container(
                margin: EdgeInsets.fromLTRB(0,15,0,0),
                    child:
                Text( infoDistanciaTime(),style:TextStyle(fontFamily: 'BreeSerif')))),
              ])))),
            ],)),

           Visibility(
               visible:!pedido_nao_aceito,
               child:
               Container(
                   margin: EdgeInsets.fromLTRB(0, 0, 0,10),
                   decoration: BoxDecoration(color:Colors.white,
                       boxShadow: [BoxShadow(color: Colors.grey[500],offset: Offset(0,0.0) ),
                       ]),
                   child:
                   Column(children: [
                     Container(padding: EdgeInsets.all(5),
                         margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                         child:
                         Text("PEDIDO RECUSADO PELA LOJA",
                           style: TextStyle(fontFamily: 'BreeSerif',fontSize: 14,color: Colors.red),)),

                   Container(padding: EdgeInsets.fromLTRB(10, 0, 0, 0),child:
                     Row(mainAxisAlignment: MainAxisAlignment.start,
                       children: [

                         Column( children: [
                           Container(
                               margin: EdgeInsets.fromLTRB(0,15,0,0),
                               padding: EdgeInsets.all(5),
                               decoration:   BoxDecoration(color:Colors.grey[200],
                                   borderRadius:BorderRadius.all(Radius.circular(30))),
                               child:Icon(Icons.shopping_basket,size: 22,color: Colors.white,)
                           ),
                           Text(txt_time_pedido,style:TextStyle(color:Colors.grey,fontSize:10))
                         ]),

                         Stack(children: [
                           Container(
                             width: (MediaQuery.of(context).size.width)/scale,
                             child: Container(height:2,
                               decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
                             ),
                           ),

                           Visibility(
                               visible:status_confirmacao ,
                               child:    Container(
                                 width: (MediaQuery.of(context).size.width)/scale,
                                 child: Container(height: 2,
                                     decoration: BoxDecoration(color: Colors.orange),
                                     padding: EdgeInsets.all(0)),
                               )),
                         ]),
         
                         Visibility(
                           visible: status_nao_aceito ,
                           child:
                           Container(
                               margin: EdgeInsets.fromLTRB(0,0,0,0),
                               padding: EdgeInsets.fromLTRB(10,10,10,10),
                               decoration:   BoxDecoration(color:Colors.grey[200],
                                   borderRadius:BorderRadius.all(Radius.circular(50))),

                               child:Icon(Icons.clear,color:Colors.red ,size:30)),
                         ),

                         Stack(children: [
                           Container(
                             width: (MediaQuery.of(context).size.width)/scale,
                             child: Container(height: 2,
                                 decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
                                 padding: EdgeInsets.all(0)),
                           ),
                  
//                           Visibility(
//                               visible:status_entrega && status_confirmacao ,
//                               child:    Container(
//                                 width: (MediaQuery.of(context).size.width)/scaleentrega,
//                                 child: Container(height: 2,
//                                     decoration: BoxDecoration(color: Colors.orange),
//                                     padding: EdgeInsets.all(0)),
//                               )),
                         ]),
                         Visibility(
                             visible:  !status_entrega ,
                             child:   Container(
                                 margin: EdgeInsets.fromLTRB(0,5,0,2),
                                 padding: EdgeInsets.fromLTRB(2,10,10,10),
                                 decoration:   BoxDecoration(color:Colors.grey[200],
                                     borderRadius:BorderRadius.all(Radius.circular(100))),
                                 child: Image.asset('delivery-man-off.png',width: 30)
                             )),


                         Stack(children: [

                           Visibility(
                               visible:status_entrega ,
                               child:
                               Column( children: [

                                 Container(
                                     margin: EdgeInsets.fromLTRB(0,15,0,2),
                                     padding: EdgeInsets.fromLTRB(2,10,10,10),
                                     decoration:   BoxDecoration(color:Colors.orange,
                                         borderRadius:BorderRadius.all(Radius.circular(100))),
                                     child:               Opacity(
                                         opacity: 1,
                                         child:Image.asset('delivery-man-off.png',width: 45
                                           ,))),
                                 Text(txt_time_entrega ,style: TextStyle(fontSize: 10,color:Colors.grey)),])
                           ),



                         ],),

                       
               
                       ],)),
                     Visibility(
                         visible: !pedido_nao_aceito ,
                         child:
                         Container(
                             margin: EdgeInsets.fromLTRB(0,15,0,20),
                             child:
                             Text("motivo: "+ widget.pedido.motivoRecusa.toString(),style:TextStyle(fontFamily: 'BreeSerif')))),
                     Visibility(
                         visible: !pedido_nao_aceito ,
                         child:
                             GestureDetector(
                               onTap:(){
                                 setFecharPedido_cancelado(widget.user.uid,widget. pedido.idPedido);
                               },
    
                          child:
                          Container(
                             margin: EdgeInsets.fromLTRB(0,15,0,20),
                             child:
                             Text("FECHAR",style:TextStyle(fontFamily: 'BreeSerif',color:Colors.orange))))),

                   ]))),


//           Container(
//              padding: EdgeInsets.fromLTRB(10, 0,10,0),
//              width: MediaQuery.of(context).size.width,
//              decoration: BoxDecoration(color:Colors.white),
//              child:Icon(Icons.keyboard_arrow_up,color: Colors.orange[700],) ),
//            nContainer(
//              padding: EdgeInsets.fromLTRB(10, 0,10,0),
//              width: MediaQuery.of(context).size.width,
//              decoration: BoxDecoration(color:Colors.white),
//              child:Icon(Icons.keyboard_arrow_up,color: Colors.orange[700],) ),

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

          //content pendido
          Visibility(
               visible:pedido_nao_aceito &&  widget.openResumo,
               child:

            Container(
              padding: EdgeInsets.fromLTRB(0, 0,0,20),
                width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color:Colors.white),
            child:
          Container(
              padding: EdgeInsets.fromLTRB(0, 0,0,20),
              decoration: BoxDecoration(color:Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey[100],offset: Offset(0,0.0) ),
                  ]),
              child: 
              
              
              Column(children: [

              Stack(children: [
               Column(children: [

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
                    listChat()),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(10, 15,10,15),

                    child:    Text(totalTxt(),textAlign: TextAlign.center,
                      style: TextStyle(color:Colors.black,fontSize: 18,
                          fontFamily: 'BreeSerif'),)),
                          ]),
                    Visibility(visible:view_chat,
                        child:
                        popChat()),
              ]),
                  Row(children: [

                Visibility(visible: !view_chat,child:
                GestureDetector(onTap:(){
                      setState(() {
                        view_chat=true;
                        view_ajuda=false;
                      });
                    },child:
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 5,10,10),
                        child:    Text("Chat",textAlign: TextAlign.left,
                          style: TextStyle(color:Colors.blue,fontSize: 16,
                              fontFamily: 'BreeSerif'),)))),

                    Visibility(visible: view_chat,child:
                    GestureDetector(onTap:(){
                      setState(() {
                          view_chat=false;
                          view_ajuda=false;

                      });
                    },child:
                    Container(
                        decoration:BoxDecoration(color:Colors.blue,borderRadius: BorderRadius.all(Radius.circular(20))),
                        padding: EdgeInsets.fromLTRB(10, 5,10,10),
                        child:    Text("Chat",textAlign: TextAlign.left,
                          style: TextStyle(color:Colors.white,fontSize: 16,
                              fontFamily: 'BreeSerif'),)))),

                    Container(
                        padding: EdgeInsets.fromLTRB(10, 5,10,10),
                        child: new FlatButton(
                        onPressed: () => UrlLauncher.launch("tel://"+tellloja),
                        child:   Text("Ligar",textAlign: TextAlign.left,
                                              style: TextStyle(color:Colors.green[400],fontSize: 16,
                              fontFamily: 'BreeSerif'),))),

                   GestureDetector(

                       onTap:(){

                         bloc.jachego(widget.user.uid,widget.pedido.idPedido);
                       },
                       child:
                    Container(
                        alignment: Alignment.center ,
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.green)),
                        padding: EdgeInsets.fromLTRB(10, 2,10,5),
                        child:    Text("Já chegou!",textAlign: TextAlign.left,
                          style: TextStyle(color:Colors.green[400],fontSize: 16,
                              fontFamily: 'BreeSerif'),))),
                  ],),

                Container(
                    height: bottompopchat ,
                ),

          Divider(),
                Row(children: [
    Visibility(visible:!view_chat,child:

                  GestureDetector(
                      onTap:(){

                        setState((){
                          if(!view_ajuda) {
                            view_ajuda = true;
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              _scrollController_pop.animateTo(
                                _scrollController_pop.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 10),
                                curve: Curves.easeOut,);
                            });
                          }  else
                            view_ajuda=false;



                        });
                      },
                      child:Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      padding: EdgeInsets.fromLTRB(10, 10,10,10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.black)),
                      child:   Text("AJUDA")))
    )
                  ,
//
                ],),
                  Visibility(visible:view_ajuda,child:
                      GestureDetector(
                      onTap:(){

                      setState((){
                      if(!view_ocorreu_um_problema) {
                        view_ocorreu_um_problema = true;
                        view_statusbar_pedido=false;
                        bg_pop_pedido=true;

                      }  else{
                        view_statusbar_pedido=true;
                        bg_pop_pedido=false;

                        view_ocorreu_um_problema=false;}

                      });
                      },
                      child:
                  Container(
                    alignment: Alignment.center ,
                    margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    padding: EdgeInsets.fromLTRB(10, 10,10,10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.black)),
                    child:  Text("OCORREU UM PROBLEMA")))),

            Visibility(visible:view_ajuda,child:
    GestureDetector(
    onTap:(){

    setState((){
    if(!view_botoes_fazer_denuncia) {
      bg_pop_pedido=true;
      view_botoes_fazer_denuncia = true;
      view_statusbar_pedido=false;
      view_denunc_btn_preceeng=true;
      view_denunc_btn_prodeng=true;
      view_denunc_btn_outro=true;
    }else{
      view_statusbar_pedido=true;
      bg_pop_pedido=false;

      view_botoes_fazer_denuncia=false;}

    });
    },
    child:
                Container(
                    alignment: Alignment.center ,
                    margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    padding: EdgeInsets.fromLTRB(10, 10,10,10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.black)),
                    child:    Text("FAZER DENÚNCIA")))),
          ])))),

    ])),
          Visibility(visible:bg_pop_pedido ,child:

          Container(

            child: ClipRect(
              child:  BackdropFilter(
                filter:  ImageFilter.blur(sigmaX:1, sigmaY:1),
                child:  Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  decoration:  BoxDecoration(color: Colors.transparent),

                ),
              ),
            ),
          )),

      Visibility(visible:view_botoes_fazer_denuncia,child:
          Positioned(
            bottom:20,
            child:
          Container(
              padding: EdgeInsets.fromLTRB(10, 10,0,0),
              child:
          Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                padding: EdgeInsets.fromLTRB(0, 10,10,20),
                width:  MediaQuery.of(context).size.width-20,
                decoration: BoxDecoration(
                color:Colors.white,boxShadow: [BoxShadow(color:Colors.grey,blurRadius: 3)]),
                child:

                btnsFazerDenuncia())))),


          Visibility(visible:view_ocorreu_um_problema,child:
      pop_ocorreu_um_problema()),

          Visibility(visible: bg_pop_end,child:
          formularioEndereco() ),

    Visibility(visible:pop_pedido_view,child:
      Positioned(
          bottom:20,
          child:
        Container(
          padding: EdgeInsets.fromLTRB(10, 10,0,20),
          child:
        Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  padding: EdgeInsets.fromLTRB(0, 10,10,20),
                  width:  MediaQuery.of(context).size.width-20,
                  decoration:
                    BoxDecoration(color:Colors.white,
                        boxShadow: [BoxShadow(color:Colors.grey,blurRadius: 3)]),
                child:
              Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:[
                    Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 10, 20),
                          padding: EdgeInsets.fromLTRB(20, 15,10,0),
                          decoration:BoxDecoration(color:Colors.white),
                          child:  Text("Problema com seu pedido?",
                              style:TextStyle(fontSize: 18,fontFamily: 'BreeSerif'))),
                   Visibility(visible: !view_btn_confirm_cancel || !view_btn_reebolso_confirma,child:
                      GestureDetector(
                      onTap:(){
                          setState((){
                            if (view_btn_confirm_cancel)
                                view_btn_confirm_cancel=false;
                            else
                                view_btn_confirm_cancel=true;
                          });
                      },
                      child:
                    Container(
                        alignment: Alignment.center ,
                        margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        padding: EdgeInsets.fromLTRB(10, 15,10,15),
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.black)),
                        child:    Text("CANCELAR PEDIDO",
                        style:TextStyle())))),
                        Visibility(visible: view_btn_confirm_cancel,child:
                        GestureDetector(
                            onTap:(){

                              setCancelPedido(widget.user.uid,widget. pedido.idPedido);

                            },
                            child:
                            Container(
                                alignment: Alignment.center ,
                                margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                padding: EdgeInsets.fromLTRB(10, 15,10,15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.red)),
                                child:    Text("CONFIRMAR CANCELAMENTO",
                                    style:TextStyle(color:Colors.red))))),

                  Visibility(visible:true,child:
                    GestureDetector(
                      onTap:(){
                          setState(() {
                            view_btn_reebolso=false;
                            view_btn_reebolso_confirma=true;
                          });
                      },
                    child:
                        Container(
                            alignment: Alignment.center ,
                            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                            padding: EdgeInsets.fromLTRB(10, 15,10,15),
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.black)),
                            child:    Text("Solicitar reembolso e cancelar".toUpperCase())))),

                        Visibility(visible: view_btn_reebolso_confirma,child:
                          GestureDetector(
                              onTap:(){
                                setState(() {
                                 widget.call_show_pop_final();
                                  setCancelPedidoreembolso(widget.user.uid,widget. pedido.idPedido);
                                });
                              },
                              child:
                          Container(
                                alignment: Alignment.center ,
                                margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                padding: EdgeInsets.fromLTRB(10, 10,10,10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.red)),
                             child:    Text("CONFIRMAR",
                                    style:TextStyle(color:Colors.red))))),

           GestureDetector(
              onTap:(){
                setState((){
                    view_btn_confirm_cancel=false;
                    bg_pop_pedido=false;

                    if(!bg_pop_pedido) {
                      bg_pop_pedido = true;
                    } else
                      bg_pop_pedido=false;
                    pop_pedido_view=false;
                  });
              },
                child:
              Container(
                      alignment: Alignment.center ,
                      margin: EdgeInsets.fromLTRB(10, 30, 0, 20),
                      padding: EdgeInsets.fromLTRB(10, 15,10,15),
                      width: 100,
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),
                          border:Border.all(color:Colors.grey)),
                      child: Text("VOLTAR".toUpperCase(),style:TextStyle(color:Colors.grey[700])))),
             ])
            ),
          ))),


            Visibility(visible: pop_precess_cancel,child:
            Positioned(
            bottom:20,
              child:
              Container(
              padding: EdgeInsets.fromLTRB(10, 10,0,0),
              child:
              aguardarrespcancel()))),


        ]),

    ))))])
  ]));
  }

  listChat(){
    return
      ListView.builder(
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.pedido.lista_produtos.length,
          itemBuilder: (context, index) {
            return  itemProd(index);
          });
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


  pop_ocorreu_um_problema(){
    return

    Positioned(
    bottom:20,
    child:
    Container(
    padding: EdgeInsets.fromLTRB(10, 10,0,0),
    child:
    Container(
    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
    padding: EdgeInsets.fromLTRB(0, 10,10,20),
    width:  MediaQuery.of(context).size.width-20,
    decoration: BoxDecoration(
    color:Colors.white,boxShadow: [BoxShadow(color:Colors.grey,blurRadius: 3)]),
    child:Column(

    mainAxisAlignment: MainAxisAlignment.end,
    children:[

    Container(
    margin: EdgeInsets.fromLTRB(20, 0, 10, 20),
    padding: EdgeInsets.fromLTRB(20, 10,10,0),
    decoration:BoxDecoration(color:Colors.white),
    child:  Text("Problema com seu pedido?",
    style:TextStyle(fontSize: 18,fontFamily: 'BreeSerif'))),


    //ENDEREÇO ERRADO
    Visibility(visible: !status_entrega,child:
    GestureDetector(
        onTap:(){
          setState((){
            if (!bg_pop_end_view)
               bg_pop_end_view=true;
            else
              bg_pop_end_view=false;
          });
        },
        child:
    Container(
        alignment: Alignment.center ,
        margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
        padding: EdgeInsets.fromLTRB(10, 15,10,15),
        decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.black)),
        child:    Text("ENDEREÇO ERRADO",
        style:TextStyle())))),


     Visibility(visible: bg_pop_end_view,child:
        enderecoView_()),

//TROCAR FORMA DE PAGAMENTO
      Visibility(visible: checkPagCartao(),child:
      GestureDetector(
          onTap:(){

         //   setCancelPedido(widget.user.uid,widget. pedido.idloja);

          },
          child:
          Container(
              alignment: Alignment.center ,
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              padding: EdgeInsets.fromLTRB(10, 15,10,15),
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.black)),
              child:    Text("TROCAR FORMA DE PAGAMENTO",
                  style:TextStyle())))),

//MEU PEDIDO VEIO ERRADO
      Visibility(visible: true,child:
      GestureDetector(
          onTap:(){

            setState(() {
              bg_pop_pedido=false;

              if (!view_field_pedidoerrado) {
              view_field_pedidoerrado = true;
              veiw_voltar_2 = false;
            }else
              {
                bottompop=0.0;
                view_field_pedidoerrado = false;
                veiw_voltar_2 = true;
              }
            });

          },
          child:
          Container(
              alignment: Alignment.center ,
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              padding: EdgeInsets.fromLTRB(10, 15,10,15),
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.black)),
              child:    Text("MEU PEDIDO VEIO ERRADO",
                  style:TextStyle())))),
        Visibility(visible: view_field_pedidoerrado,child:
        Container(
            alignment: Alignment.center ,
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),child:
           Text("Fale no chat ou ligue para loja",style: TextStyle(fontFamily: 'RobotoBold'),))),

      Visibility(visible: view_field_pedidoerrado,child:
      GestureDetector(
          onTap:(){

          },
          child:
          Container(
              alignment: Alignment.center ,
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              padding: EdgeInsets.fromLTRB(10, 10,10,10),
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
                  border:Border.all(color:Colors.grey)),
              child:
              TextField(
                  onTap: (){
                    setState(() {
                      bottompop=100.0;
                    });
                  },
                    onChanged: (value) {
                    setState(() {
                      testAjudamsn=value;
                    });},textInputAction:  TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 250,
                  decoration: InputDecoration(hintText: "Descreva",
                      hintStyle: TextStyle(color: Colors.black26)),
                  style: TextStyle(color:Colors.black54,fontFamily: 'RobotoRegular')),
          ))),

      Visibility(visible: view_field_pedidoerrado,child:

          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[

      GestureDetector(
          onTap:(){
            if(testAjudamsn!="")
            sendMsgAjuda(widget.user.uid,widget.pedido.idPedido,testAjudamsn);

          },
          child:
          Container(
              alignment: Alignment.center ,
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              padding: EdgeInsets.fromLTRB(20, 15,20,15),
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),
                  border:Border.all(color:Colors.blue)),
              child:    Text("ENVIAR MSG",
                  style:TextStyle(color:Colors.blue,fontFamily: 'RobotoBold')))),
         GestureDetector(
                onTap:(){
                  UrlLauncher.launch("tel://"+tellloja);
                },
                child:
                Container(
                    alignment: Alignment.center ,
                    margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    padding: EdgeInsets.fromLTRB(20, 15,20,15),
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),
                        border:Border.all(color:Colors.green)),
                    child:    Text("LIGAR",
                        style:TextStyle(color:Colors.green,fontFamily: 'RobotoBold')))),
        ])),

      Visibility(visible:  diff_hora>=1 ,child:
      GestureDetector(
        onTap:(){

          setState((){
            if(!pop_pedido_view
            ) {
              bg_pop_pedido = true;
              view_statusbar_pedido=false;
              pop_pedido_view=true;
            }else {
              bg_pop_pedido = false;
              view_statusbar_pedido=true;
              pop_pedido_view=false;
            }
          });
        },
        child:
        Container(
            alignment: Alignment.center ,
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            padding: EdgeInsets.fromLTRB(10, 15,10,15),
            decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.black)),
            child:   Text("MEU PEDIDO NÃO CHEGOU")),)),

      Visibility(visible: true,child:
      GestureDetector(
          onTap:() {
            setState(() {
              FlutterOpenWhatsapp.sendSingleMessage("+559189950036", "Olá, preciso de ajuda.\n Meu nome: "+widget.user.nome+"\nMeu email: "+widget.user.email );
            });
          },
          child:
          Container(
              alignment: Alignment.center ,
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              padding: EdgeInsets.fromLTRB(10, 5,10,5),
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.black)),
              child: Row(children:[

              Container(
                  alignment: Alignment.center ,
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),child:
                  Image.asset('iconwhats.png',width: 35,height: 35,) ),
              Container(
                  alignment: Alignment.center ,
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),child:Text("FALAR COM SUPORTE",
                  style:TextStyle()))])   ))),

//      Visibility(visible: true,child:
//      GestureDetector(
//          onTap:(){
//
//            setState(() {
//              if (!view_field_pedidoerrado) {
//                view_field_pedidoerrado = true;
//                veiw_voltar_2 = false;
//              }else
//              {
//                bottompop=0.0;
//                view_field_pedidoerrado = false;
//                veiw_voltar_2 = true;
//              }
//            });
//
//          },
//          child:
//          Container(
//              alignment: Alignment.center ,
//              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
//              padding: EdgeInsets.fromLTRB(10, 10,10,10),
//              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.black)),
//              child:  Text("FALAR COM SUPORTE",
//                  style:TextStyle())))),
        Visibility(visible: true,child:

        GestureDetector(
          onTap:(){

            setState((){
              bg_pop_pedido=false;
              if(!view_ocorreu_um_problema) {
                view_ocorreu_um_problema = true;
              } else{
                bottompop=0.0;
                view_field_pedidoerrado=false;
                view_ocorreu_um_problema=false;
              }
            });
          },
          child:
          Container(
              alignment: Alignment.center ,
              margin: EdgeInsets.fromLTRB(10, 30, 0, bottompop),
              padding: EdgeInsets.fromLTRB(10, 15,10,15),
              width: 100,
              decoration:
              BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),
                  border:Border.all(color:Colors.grey)),
              child:    Text("VOLTAR".toUpperCase(),style:TextStyle(color:Colors.grey[700]))))),
    ])

    )));

  }

  btnsFazerDenuncia(){

    return Column(children: [
      Container(
          margin: EdgeInsets.fromLTRB(20, 0, 10, 20),
          padding: EdgeInsets.fromLTRB(20, 10,10,0),
          decoration:BoxDecoration(color:Colors.white),
          child:  Text("Fazer Denúncia",
              style:TextStyle(fontSize: 18,fontFamily: 'BreeSerif'))),

      Visibility(visible: view_denunc_btn_prodeng,child:
      GestureDetector(
          onTap:(){

            setState(() {
              if (!view_field_denuncia) {
                view_field_denuncia = true;
                view_denunc_btn_preceeng=false;
                view_denunc_btn_outro=false;
                origemDenuncia="preduto_enganoso";

              }else
              {
                bottompop=0.0;
                origemDenuncia="";
                view_denunc_btn_preceeng=true;
                view_denunc_btn_outro=true;
                view_field_denuncia = false;
              }
            });

          },
          child:
          Container(
              alignment: Alignment.center ,
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              padding: EdgeInsets.fromLTRB(10, 15,10,15),
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.black)),
              child:    Text("PRODUTO ENGANOSO",
                  style:TextStyle())))),

      Visibility(visible: view_denunc_btn_preceeng,child:
      GestureDetector(
          onTap:(){

            setState(() {
              if (!view_field_denuncia) {
                view_field_denuncia = true;
                view_denunc_btn_prodeng =false;
                view_denunc_btn_outro=false;
                origemDenuncia="preco_enganoso";

              }else
              {
                bottompop=0.0;
                origemDenuncia="";
                view_denunc_btn_prodeng =true;
                view_denunc_btn_outro=true;
                view_field_denuncia = false;
              }
            });

          },
          child:
          Container(
              alignment: Alignment.center ,
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              padding: EdgeInsets.fromLTRB(10, 15,10,15),
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.black)),
              child:    Text("PREÇO ENGANOSO",
                  style:TextStyle())))),

      Visibility(visible: view_denunc_btn_outro,child:
      GestureDetector(
          onTap:(){

            setState(() {
              if (!view_field_denuncia) {
                view_field_denuncia = true;
                view_denunc_btn_prodeng =false;
                view_denunc_btn_preceeng=false;
                origemDenuncia="outro";

              }else
              {
                view_denunc_btn_prodeng =true;
                view_denunc_btn_preceeng=true;
                bottompop=0.0;
                origemDenuncia="";
                view_field_denuncia = false;
              }
            });

          },
          child:
          Container(
              alignment: Alignment.center ,
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              padding: EdgeInsets.fromLTRB(10, 15,10,15),
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),border:Border.all(color:Colors.black)),
              child:    Text("OUTRO",
                  style:TextStyle())))),

      Visibility(visible: view_denunc_btn_outro && view_denunc_btn_prodeng && view_denunc_btn_preceeng,child:
      GestureDetector(
          onTap:(){

            setState(() {
              view_botoes_fazer_denuncia=false;
              bg_pop_pedido=false;
            });

          },
          child:
          Container(
              alignment: Alignment.center ,
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              padding: EdgeInsets.fromLTRB(10, 15,10,15),
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),
                  border:Border.all(color:Colors.grey)),
              child:    Text("VOLTAR",
                  style:TextStyle())))),

      Visibility(visible: view_field_denuncia,child:
      GestureDetector(
          onTap:(){

          },
          child:
          Container(
            alignment: Alignment.center ,
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            padding: EdgeInsets.fromLTRB(10, 10,10,10),
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
                border:Border.all(color:Colors.grey)),
            child:
            TextField(
                onTap: (){
                  setState(() {
                    bottompop=100.0;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    msgDenuncia=value;
                  });},textInputAction:  TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 250,
                decoration: InputDecoration(hintText: "Descreva",
                    hintStyle: TextStyle(color: Colors.black26)),
                style: TextStyle(color:Colors.black54,fontFamily: 'RobotoRegular')),
          ))),
    Visibility(visible: view_field_denuncia,child:
    GestureDetector(
          onTap:(){
            if( msgDenuncia!=""){
              enviarDenuncia();
            }
          },
          child:
          Container(
              alignment: Alignment.center ,
              margin: EdgeInsets.fromLTRB(10, 10, 0, bottompop),
              padding: EdgeInsets.fromLTRB(20, 15,20,15),
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),
                  border:Border.all(color:Colors.blue)),
              child:    Text("ENVIAR",
                  style:TextStyle(color:Colors.blue,fontFamily: 'RobotoBold'))))),
    ]);
  }
  
  popChat(){
   return

     Column(children:[

     Container(
       padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
         decoration:BoxDecoration(
              boxShadow: [BoxShadow(color:Colors.black45)],
              borderRadius: BorderRadius.all(Radius.circular(2))),
          height: 280,
          child:
          Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0,0),
    child:
    ClipRect(
    child:  BackdropFilter(
    filter:  ImageFilter.blur(sigmaX:2, sigmaY:2),
    child:  Container(
    width: double.infinity,
    height:  double.infinity,
    decoration:  BoxDecoration(color: Colors.transparent),
    child:
          SingleChildScrollView(
              controller: _scrollController,
              child:

    Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children:[
      Container(

          child:
        Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children:[

      listachat


          ])
    ),


    ])))))),



   ),

       Container(
//         width: MediaQuery.of(context).size.width,

           decoration:BoxDecoration(color:Colors.orange,
               borderRadius: BorderRadius.all(Radius.circular(2))),
           child:Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween ,
               children:[

                 Container(
                     margin:EdgeInsets.fromLTRB(5,0,0,0),
                     width: MediaQuery.of(context).size.width-75
                     ,child:   TextField(cursorColor: Colors.white,cursorRadius: Radius.circular(20),
                       style: TextStyle(color:Colors.white,fontFamily: 'BreeSerif'),
                       controller: control_chattext,

                        decoration: InputDecoration(hintText: "MSG",focusColor: Colors.white,hintStyle: TextStyle(color:Colors.white) ),)),
                 
                          GestureDetector(onTap:(){             
                            bloc_financeiro.enviarMsgChat(control_chattext.text,widget.user.email, widget.user.uid, "user", widget.pedido.idloja, widget.pedido.idPedido,"" );
                            control_chattext.text="";
                          },child:
                          Icon(Icons.send,color:Colors.white,size: 35,)),
        ])
       )
   ])
    ;
    
  }

   Future<bool> _onBackPressed() {
    setState(() {
      bottompopchat=0.0;
    });
  }

  listaChat_(){
    return
      StreamBuilder(
          stream: Firestore.instance.collection('Usuarios').document(widget.user.uid)
              .collection("Pedidos").document(widget.pedido.idPedido)
              .collection("chat").orderBy("time").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState==ConnectionState.active){
              print("GET MSG");

              return

      ListView.builder(
          controller: _scrollController_listchar,
          primary: false,
          shrinkWrap: true,
          reverse: true,
          scrollDirection: Axis.vertical,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 10),
                curve: Curves.easeOut,);
            });

            if (snapshot.data.documents[index]['remetente']!="user" && snapshot.data.documents[index]['remetente']!="user-auto-pedidoErrado")
              return
                Container(
                    margin:EdgeInsets.fromLTRB(5, 0, 0, 0),
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
                      margin:EdgeInsets.fromLTRB(5, 0, 0, 0),
                      alignment: Alignment.center,
                      child:  Container(
                          decoration:BoxDecoration(color:Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(20)),),
                          padding:EdgeInsets.fromLTRB(20,15, 20, 15),
                          margin:EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child:
                          Text("Aviso! Meu pedido veio errado: "+
                              snapshot.data.documents[index]['msg'],style: TextStyle(fontFamily: 'BreeSerif'),))
                  )));
             else
              return
                LimitedBox(maxWidth:MediaQuery.of(context).size.width*.8,child:
            IntrinsicWidth(child:
               Container(
                    margin:EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                    child:  Container(
                        decoration:BoxDecoration(color:Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [BoxShadow(color:Colors.grey[200],blurRadius: 1,offset: Offset(0,1))],),
                        padding:EdgeInsets.fromLTRB(20,15, 20, 15),
                        margin:EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child:
                        Text(snapshot.data.documents[index]['msg'],style: TextStyle(fontFamily: 'BreeSerif'),)))));
          });

            }else
              return Container();
     });
  }

  enviarDenuncia()async{
    if (msgDenuncia!=""){
   var b = await bloc.enviarDenuncia(widget.pedido,origemDenuncia,msgDenuncia);
    setState(() {
    if (b==true)  _snackbarcor("Denúncia enviada",Colors.green);
      view_denunc_btn_prodeng =true;
      view_denunc_btn_preceeng=true;
      view_denunc_btn_outro=true;
      view_field_denuncia=false;
    });}else _snackbarcor("Escreve um comentário",Colors.grey);
    msgDenuncia="";
  }
  _snackbarcor(text,cor){
    final snackBar = SnackBar(backgroundColor: cor, content: Text(text));
    Scaffold.of(context).showSnackBar(snackBar);
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

  void launchWhatsApp(
      {@required String phone,
        @required String message,
      }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?   phone=$phone&text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  formularioEndereco(){
    return
      Container(
            width: double.infinity,
          padding: EdgeInsets.fromLTRB(0, 0, 0,80),
          decoration:  BoxDecoration(color: Colors.white),
            child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0,0),   child:
          Container(
                    decoration:  BoxDecoration(color: Colors.white.withOpacity(.20)),
                    child:
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20,20),
                        child:Column(mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            form_endereco_user(end_user_,widget.pedido.idPedido,null,(){  hidepop_end();})
                          ],)
                    ),


                  )));
  }

  hidepop_end(){
    setState((){bg_pop_end=false;});
  }
  checkPagCartao(){
    var ctrl=false;
    var tipo= widget.pedido.tipoPagamento;
    if (tipo=="cartao")
      ctrl=true;
    return ctrl;
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

  enderecoView_(){
    print(widget.pedido.idPedido);
    return StreamBuilder(
        stream: Firestore.instance.collection('Usuarios').document(widget.user.uid)
            .collection("Pedidos").document(widget.pedido.idPedido).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState==ConnectionState.active){

            return
                enderecoUserView(snapshot.data['enderecoEntrega']);
              return Container();
          }else
            return Container();
        });
  }

  enderecoUserView(var data){
//    enderecoUserSnapShot   end_user = new enderecoUserSnapShot(data);
      end_user_ =  new enderecoUser(data['rua'],data['bairro'],data['numero'],data['complemento'],data['localizacao'],data['temp']);
    return
      Container(
          margin: EdgeInsets.fromLTRB(10, 10, 15, 10),
          decoration:
          BoxDecoration(color:Colors.white,borderRadius:BorderRadius.only( topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20),)
              ,boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)]),
          child:
//    BorderRadius.all(Radius.circular(20))
          Column(

            children: <Widget>[


              Row(mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max, children: <Widget>[

                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[

                      Container(
                          width: MediaQuery.of(context).size.width*.44,
                          margin: EdgeInsets.fromLTRB(10, 25,0, 0),
                          alignment: Alignment.center, child:
                      Text(data['rua']+", "+data['bairro'], maxLines: 4,
                        overflow: TextOverflow.ellipsis,style:
                        TextStyle(color: Colors.black87,fontFamily: 'RobotoLight'),)),

                      Container(
                          width: MediaQuery.of(context).size.width*.44,
                          margin: EdgeInsets.fromLTRB(10, 0,0, 5),
                          alignment: Alignment.centerLeft, child:
                      Text("Nº "+data['numero']+", "+data['complemento'], maxLines: 6,
                        overflow: TextOverflow.ellipsis,style:
                        TextStyle(color: Colors.black45,fontFamily: 'RobotoLight'),)),

                    ],),
//
                  Container(
                      height: 180,
                      width:136,
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
                  bg_pop_end=true;
                }); },child:
              Container(
                padding:EdgeInsets.all(10) ,
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  alignment: Alignment.center, child:
              Text("Atualizar",style:
              TextStyle(color: Colors.red,fontFamily: 'RobotoBold'),)))),

            ],));
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
          var numb = widget.listaDistancia_[i].duracao.toString().split(" ");
          var n = numb[0];
          var duracao = int.parse(numb[0].toString()) + 30;
          text = "previsão: "+n.toString() +" à "+duracao.toString() +" mins | "+formatDistancia(i);
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

  getLocal(var data){
    var   _center;

    _center=new LatLng(data['localizacao'].latitude,
        data['localizacao'].longitude);
    if (mapController!=null)
      mapController.moveCamera(CameraUpdate.newLatLngZoom(_center, 15));

    return _center;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
    getLoja();
    getChat();
    listachat=listaChat_();
    _controllerIcon_moto = AnimationController(duration: Duration(milliseconds:4000),vsync: this)..repeat();
    animation = Tween<Offset>(begin: Offset(.0, 0), end: Offset(2, 0)).animate(_controllerIcon_moto);

  }

  @override
  void dispose() {
    _controllerIcon_moto.dispose();
    super.dispose();

  }

  aguardarrespcancel() {

    return
      LimitedBox(maxHeight:MediaQuery.of(context).size.height*.7,child:
      SingleChildScrollView(child:
      Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          decoration: BoxDecoration(color: Colors.white,boxShadow: [
            BoxShadow( color: Colors.grey,
              offset: Offset(0.0,0.0,  ),)
          ],),
          child:
          Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width,
                    child:
                    Stack(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              margin:EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child:Text("CANCELANDO...",style: TextStyle(fontSize: 20,fontFamily: 'BreeSerif',letterSpacing: 0.4),)),
                        ])),

                Container(
                    padding:EdgeInsets.all(10),
                    margin:EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child:
                    Column(
                        children: <Widget>[
                          Image.asset('gif_load.gif',width: 50,height: 50,),
                        ])),

                Container(
                    padding:EdgeInsets.all(10),
                    margin:EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child:Text("Aguarde...",
                      style: TextStyle(color:Colors.grey,fontSize: 20,fontFamily: 'BreeSerif',letterSpacing: 0.4),)),



              ])
      )));
  }

  setFecharPedido_cancelado (var uid,var pedido)async{

    var b = await bloc.cancelPedido_nao_aceito(uid, pedido);

  }


  setCancelPedido  (var uid,var pedido)async{
    setState(() {
      pop_precess_cancel = true;
      } );
     var b = await bloc.cancelPedido(uid, pedido);

  }

  setCancelPedidoreembolso  (var uid,var pedido)async{
    setState(() {
      pop_pedido_view=false;
      view_ajuda=false;
      pop_precess_cancel = true;
    } );
    var b = await bloc.cancelPedido_reembolso(uid, pedido);

  }

  getLoja() async{
    Loja loja = await bloc.getLojaPedido(widget.pedido.idloja);
    if (loja!=null)
      tellloja=loja.tell;

    print("loja xxxy "+loja.tell);
  }

  sendMsgAjuda  (var uid,var idpedido,var msg)async{

    var b = await bloc.sendMsgAjuda(uid, idpedido,msg);
    if (b==true){
      bottompop=0.0;
      view_field_pedidoerrado=false;
      view_ocorreu_um_problema=false;
    }

  }


  getChat(){
    Firestore.instance.collection('Usuarios').document(widget.user.uid)
        .collection("Pedidos").document(widget.pedido.idPedido)
        .collection("chat").orderBy("time").snapshots().listen((event) {

          if (event.documentChanges.length>0)
            setState(() {
              view_chat=true;
            });
    });
  }

}