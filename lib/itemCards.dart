import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firestore/Produto.dart';
import 'package:flutter_firestore/animator.dart';

import 'CardUser.dart';
import 'Produto_cesta.dart';

typedef showLoginPop = bool Function();

class itemCards extends StatefulWidget {

  CardUser card;
  final showLoginPop callback_login;
  TextStyle styleTxt3 = TextStyle(fontSize: 16,color:Colors.orange,fontFamily: 'RobotoRegular');
  Icon iconSelect= Icon(Icons.star_border);
  var ctrl_remove=false;

  itemCards (this.card, @required this.callback_login);

  @override
  cardsstate createState() => cardsstate ();

}


class cardsstate  extends State<itemCards> {

  @override
  Widget build(BuildContext context) {

    setState((){
    if (widget.card.check==true){
      widget.iconSelect=new Icon(Icons.star,color: Colors.orange);
    }else
      widget.iconSelect=new Icon(Icons.star_border,color: Colors.grey);
    });

    return   Container(
      decoration: BoxDecoration(color:Colors.white, boxShadow: [
      BoxShadow(
        color: Colors.grey[400],
        blurRadius: 3.0,
        offset: Offset(
          0.0, // horizontal, move right 10
          1, // vertical, move down 10
        ),
      )
    ],), child:
    IntrinsicWidth(child:
    Wrap(  children: <Widget>[

      Column(mainAxisSize: MainAxisSize.max,crossAxisAlignment: CrossAxisAlignment.stretch,children: <Widget>[
        Stack(children: <Widget>[
          GestureDetector(onTap: (){
            setState((){

              if (widget.ctrl_remove==false)
                widget.ctrl_remove=true;
              else
                widget.ctrl_remove=false;

            });},
            child:
        Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child:   Icon(Icons.clear,color: Colors.red,size: 20,),)),
        Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.all(19),
            child:
            Column(mainAxisSize: MainAxisSize.max,crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[
              Container(  width: 70, height: 40,
                child: Image.asset(widget.card.bandeira+".png"),),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child:   Text("Final *** " +widget.card.digitos,style:widget.styleTxt3),),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child:   Text(" "+widget.card.tipo.toString().toUpperCase()+"",style:TextStyle(color:Colors.grey)),),
              GestureDetector(onTap: (){
                  setState((){
                  });},
              child:Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                child:   widget.iconSelect)),
          ],)),
          _viewRemove(),

      ],)
    ],)])),
    );
  }


  _viewRemove(){
    return
      Visibility(visible:widget.ctrl_remove, child:
      Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          alignment: Alignment.bottomCenter,
          height: MediaQuery.of(context).size.height,decoration: BoxDecoration(color:Colors.grey[200]), child:
      Container(child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(margin: EdgeInsets.fromLTRB(0, 10, 0, 10), child:
          Text("REMOVER CARTÃO?",style:TextStyle(color:Colors.red))),
          Container(margin: EdgeInsets.fromLTRB(0, 15, 0, 10),padding: EdgeInsets.all(10), decoration: BoxDecoration(color:Colors.white, border: Border.all(color: Colors.green),borderRadius: BorderRadius.all(Radius.circular(10))), child:
          Text("SIM",style: TextStyle(color:Colors.green),)),
          GestureDetector(onTap: (){
            setState((){
              if (widget.ctrl_remove==false)
                widget.ctrl_remove=true;
              else
                widget.ctrl_remove=false;
            });},
            child: Container(margin: EdgeInsets.fromLTRB(0, 10, 0, 10),padding: EdgeInsets.all(10), decoration: BoxDecoration(color:Colors.white, border: Border.all(color: Colors.red),borderRadius: BorderRadius.all(Radius.circular(10))), child:
            Text("NÃO",style: TextStyle(color:Colors.red)))),
        ],))));

  }


  _removerCartao() async{

//      FirebaseUser user = await FirebaseAuth.instance.currentUser();
//      if (user!=null)
//        await Firestore.instance.collection("Usuarios")
//            .document(user.uid).collection("cards").document(widget.produto.id).delete();
      setState(() {
      });
  }

  _snackbar(text){
    final snackBar = SnackBar(content: Text(text));
    Scaffold.of(context).showSnackBar(snackBar);

  }

  checkLogado()  async  {
    var firebaseUser  = await FirebaseAuth.instance.currentUser();
    if(firebaseUser == null)
    {
      _snackbar("Você não está logado");
      return false;
    }
    else{
      return true;
    }
  }


}

