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
        child: ClipRect(
        child:  BackdropFilter(
        filter:  ImageFilter.blur(sigmaX:1.25, sigmaY:1.25),
    child:  Container(
    decoration:  BoxDecoration(color: Colors.transparent),
    child:
      Container(height: 45, decoration: BoxDecoration(color: Colors.white.withOpacity(0.3),
       boxShadow: [BoxShadow(color: Colors.black12,offset:  Offset(0.0,-44),blurRadius: 5 ,)]),
        child:
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[

      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      GestureDetector(onTap: (){
          setState((){
            _home(context);
             widget.colorHome=Colors.orange[200];
             widget.colorUser=Colors.transparent;
             widget.colorBusca=Colors.transparent;
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
                _perfil_user(context);
                widget.colorUser=Colors.orange[200];
                widget.  colorHome=Colors.transparent;
                widget.colorBusca=Colors.transparent;
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

     GestureDetector(onTap: (){ setState((){
       _buscar(context);

      });  },

       child: Container (width: 40, padding:EdgeInsets.fromLTRB(0, 0, 0, 0), decoration: BoxDecoration(color:Colors.white, boxShadow: [BoxShadow(
                color: widget.colorBusca,blurRadius: 2.0, offset: Offset(0.0,0.5, ),)], borderRadius: BorderRadius.all(Radius.circular(5))), alignment: Alignment.center, margin: EdgeInsets.fromLTRB(5, 5, 0, 5) ,child:
              Icon(Icons.search,color:  Colors.grey[400]))),

       ]),
          Text(""+widget.end,style: TextStyle(fontFamily: 'BreeSerif',color: Colors.black87),  overflow: TextOverflow.fade,)



     ],)
   ,)))));
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
      curve: Curves.bounceIn,
      duration: Duration(milliseconds:500),
      alignment: Alignment.center,
      type: PageTransitionType.leftToRight,
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
      curve: Curves.bounceIn,
      duration: Duration(milliseconds:500),
      alignment: Alignment.center,
      type: PageTransitionType.rightToLeft,
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