
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firestore/barNavBottom.dart';
import 'package:flutter_firestore/itemListProd.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'enderecoUser.dart';
import 'headCurve.dart';
import 'itemListLojas.dart';


class perfil_loja extends StatefulWidget {

  var idloja;
  perfil_loja(this.idloja );

  Stream<QuerySnapshot> ref= Firestore.instance
      .collection("Perfil_lojas").where("nome", isEqualTo :"")
      .snapshots();


  @override
  perfil_lojaState createState() => perfil_lojaState();
}

class perfil_lojaState extends State<perfil_loja> {

  var t="x";
  LatLng local_user;


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(

      body: Center(

          child:
          Container(decoration: BoxDecoration(color: Colors.white), child:
          Column(
              children: <Widget>[
               _barTop(),

                Container( child:
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      color: Colors.white,
                      child:CustomPaint(

                        painter: headCurve(Colors.orange),
                      ),
                    ),

                  //Container(height:100, decoration: BoxDecoration(color:Colors.orange),),
                  Container(alignment: Alignment.bottomCenter, margin: EdgeInsets.fromLTRB(0, 10, 0, 0), height:90,width: 90, decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.all(Radius.circular(50))),)
                ],),),
                Container(margin: EdgeInsets.all(5),
                  child:
                  Text("Nome Loja",style: TextStyle(color:Colors.orange,fontSize: 18,fontFamily: 'RobotoBold'),),),
                Row (mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(margin: EdgeInsets.fromLTRB(0, 5, 5, 0), decoration: BoxDecoration(color:Colors.orange,borderRadius: BorderRadius.all(Radius.circular(20))),width: 5,height: 5,),
                    Container(margin: EdgeInsets.fromLTRB(0, 5, 0, 0), child:  Text("11.8km ",style: TextStyle(color: Colors.grey[500],fontSize: 13,fontFamily: 'RobotoLight'),)),
                    Container(margin: EdgeInsets.fromLTRB(0, 5, 5, 0), decoration: BoxDecoration(color:Colors.orange,borderRadius: BorderRadius.all(Radius.circular(20))),width: 5,height: 5,),
                    Container(margin: EdgeInsets.fromLTRB(0, 5, 0, 0), child:  Text("Frete: R 4,00",style: TextStyle(color: Colors.grey[500],fontSize: 13,fontFamily: 'RobotoLight'),)),
                 ],),
                Container(alignment: Alignment.centerLeft, margin: EdgeInsets.fromLTRB(10, 10, 0, 0), child:  Text("Endereço: Rua x nº20 bairro teste ",style: TextStyle(color: Colors.grey[500],fontSize: 13,fontFamily: 'RobotoLight'),)),
                Row (mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(alignment: Alignment.centerLeft, margin: EdgeInsets.fromLTRB(10, 5, 0, 0), child:  Text(": ",style: TextStyle(color: Colors.grey[500],fontSize: 13,fontFamily: 'RobotoLight'),)),
//                    Container(width:20,height:20,margin: EdgeInsets.fromLTRB(10, 5, 0, 0), child:  Icon(Icons.credit_card,color: Colors.green,)),
                    Container(width:20,height:20,margin: EdgeInsets.fromLTRB(0, 5, 0, 0), child:  Icon(Icons.map,color: Colors.orange,)),
                    Container(width:20,height:20,margin: EdgeInsets.fromLTRB(0, 5, 0, 0), child:  Icon(Icons.chat,color: Colors.orange,)),
                  ],),
                Container(margin: EdgeInsets.fromLTRB(10, 30, 0, 0),alignment: Alignment.centerLeft, child: Text("Produtos",style: TextStyle(color:Colors.orange,fontSize: 18,fontWeight: FontWeight.w800 ,fontFamily: 'RobotoBold'),textAlign: TextAlign.start,),),
                Expanded(child:
                StreamBuilder(
                    stream: Firestore.instance
                        .collection("Produtos_On")
                        .where("idloja",isEqualTo: widget.idloja)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return new ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            return Container();
//                            return itemListProd(snapshot.data.documents[index],local_user,null,null);
                          }
                      );
                    }
                ),),
                barNavBottom("Home",true, "",null,null),
              ])
          )),
    );
  }

  _barTop(){
    return Column(children: <Widget>[

      Container( height: 24,decoration: BoxDecoration(color: Colors.orange[300]),),
    ],);
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
        enderecoUser    endereco = new enderecoUser(
            data['rua'], data['bairro'], data['numero'], data['complemento'],
            data['localizacao'],data['temp']);
        local_user = LatLng(endereco.localizacao.latitude,endereco.localizacao.longitude);

      }else {
        print("ENDERECO NULL");

      }
    });
  }


}




