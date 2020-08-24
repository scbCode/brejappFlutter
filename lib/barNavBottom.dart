import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firestore/main.dart';
import 'package:flutter_firestore/viewBusca.dart';
import 'package:page_transition/page_transition.dart';

import 'BlocAll.dart';
import 'Perfil_user.dart';
import 'animationItem.dart';
import 'dropdownBasic.dart';

typedef StringValue = String Function(String);
typedef Open_login =  Function();

class barNavBottom extends StatefulWidget {

  var local;
  var logado;
  var end;

  final StringValue callback_click_busca;
  final Open_login callback_open_login;
  barNavBottom (this.local,this.logado,this.end, @required this.callback_click_busca, @required this.callback_open_login);
  Color colorShadow=Colors.orange[200];
  Color colorHome=Colors.orange[200];
  Color colorBusca=Colors.transparent;
  Color colorUser=Colors.transparent;
  Color coloriconUser= Colors.grey[400];
  var yourList = ['valor1', 'valor2', 'valor3'];
  bool viewList=false;
  var viewBusca=false;

  @override
  barNavBottomState createState() => barNavBottomState();

}


class barNavBottomState extends State<barNavBottom> {
  TextEditingController textController = TextEditingController();
  var bloc = BlocAll();

  @override
  Widget build(BuildContext context) {

    if (widget.local=="Home")
      _activeHome(widget);
    if (widget.local=="Busca")
      _activeBusca(widget);
    if (widget.local=="User")
      _activeUser(widget);

    if (widget.logado)
        widget.coloriconUser=Colors.lightBlueAccent;

    return
      Container(

    child:  Container(
    decoration:  BoxDecoration(color: Colors.white.withOpacity(0.8)),
    child:
      Container(height: 45, decoration: BoxDecoration(color: Colors.white.withOpacity(0.7),
       boxShadow: [BoxShadow(color: Colors.black12,offset:  Offset(0.0,0),blurRadius: 3 ,)]),
        child:
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[

      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      GestureDetector(onTap: (){
          setState((){
            if (widget.local!="Home"){
              _home(context);
             widget.colorHome=Colors.orange[200];
             widget.colorUser=Colors.transparent;
             widget.colorBusca=Colors.transparent;}
          });
       },
      child:
      Container (width: 40, padding:EdgeInsets.fromLTRB(0, 0, 0, 0), decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
          color: widget.colorHome,
          blurRadius: 3.0,
          offset: Offset(
            0.0, // horizontal, move right 10
            0.5, // vertical, move down 10
          ),
        )], borderRadius: BorderRadius.all(Radius.circular(3))), alignment: Alignment.center, margin: EdgeInsets.fromLTRB(5, 5, 0, 5) ,child:
      Icon(Icons.home,color: Colors.orange))),
      GestureDetector(onTap: (){
          setState((){
            if (widget.logado==true){
              if (widget.local!="User"){
                _perfil_user(context);
                widget.colorUser=Colors.orange[200];
                widget.  colorHome=Colors.transparent;
                widget.colorBusca=Colors.transparent;}
            }else
              {
                widget.callback_open_login();
              }
          });
          },
          child:
      Container (width: 40, padding:EdgeInsets.fromLTRB(0, 0, 0, 0),
          decoration: BoxDecoration(color:Colors.white, boxShadow: [BoxShadow(
            color: widget.colorUser,
            blurRadius: 2.0,
            offset: Offset(
              0.0, // horizontal, move right 10
              0.5, // vertical, move down 10
            ),
          )], borderRadius: BorderRadius.all(Radius.circular(3))), alignment: Alignment.center, margin: EdgeInsets.fromLTRB(5, 5, 0, 5) ,child:
      Icon(Icons.account_circle,color:widget.coloriconUser))),



       ]),
        Container(
          width: MediaQuery.of(context).size.width*0.55,
          alignment: Alignment.centerRight, child:  Text(""+widget.end, maxLines: 1,
            overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: 'BreeSerif',color: Colors.black87),  ))



     ],)
   ,)));
 }


@override
void initState() {
    if (widget.logado)
         widget.coloriconUser=Colors.greenAccent;
  super.initState();
}










}


_activeHome(widget){
  widget.colorHome=Colors.orange[200];
  widget.colorUser=Colors.transparent;
  widget.colorBusca=Colors.transparent;
}

_activeUser(widget){
  widget.colorHome=Colors.transparent;
  widget.colorUser=Colors.orange[200];
  widget.colorBusca=Colors.transparent;
}

_activeBusca(widget){
  widget.colorHome=Colors.transparent;
  widget.colorUser=Colors.transparent;
  widget.colorBusca=Colors.orange[200];
  widget.viewBusca=true;
}

_perfil_user(context){
  Navigator.push(
    context,
    PageTransition(
      curve: Curves.elasticInOut,
      duration: Duration(milliseconds:1000),
      alignment: Alignment.center,
      type: PageTransitionType.rightToLeftWithFade,
      child: Perfil_user(),
    ),
  );
}


_buscar(context){
  Navigator.pop(
    context,
    PageTransition(
      curve: Curves.bounceIn,
      duration: Duration(milliseconds:500),
      alignment: Alignment.center,
      type: PageTransitionType.leftToRight,
      child: viewBusca(),
    ),
  );
}

_home(context){

  Navigator.pop(
    context,
    PageTransition(
      curve: Curves.easeIn,
      duration: Duration(milliseconds:1000),
      alignment: Alignment.center,
      type: PageTransitionType.rightToLeftWithFade,
      child: MyHomePage(),
    ),
  );
}


_viewBusca(isView){
  if (!isView){
        return true;
  }else
    return false;
}