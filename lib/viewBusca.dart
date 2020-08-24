
import 'package:auto_animated/auto_animated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firestore/barBuscar.dart';
import 'package:flutter_firestore/barNavBottom.dart';
import 'package:flutter_firestore/itemListProd.dart';
import 'package:flutter_firestore/barCesta.dart';
import 'package:flutter_firestore/viewBusca.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'enderecoUser.dart';
import 'headCurve.dart';
import 'itemListLojas.dart';


class viewBusca extends StatefulWidget {
  viewBusca();
  Stream<QuerySnapshot> ref= Firestore.instance
      .collection("Produtos_On").where("tags", arrayContains :"cerveja")
      .snapshots();

  @override
  viewBuscaState createState() => viewBuscaState();
}

class viewBuscaState extends State<viewBusca> {

var t="x";
LatLng local_user;
_query(text){

  widget.ref= Firestore.instance
      .collection("Produtos_On").where("tags", arrayContains :"cerveja")
      .snapshots();

 List<String> textsplit = text.split(' ');

  if (textsplit.length>1){
    var t1 = '${textsplit[0][0].toString().toLowerCase()}${textsplit[0].substring(1)}';
    var t2 = '${textsplit[1][0].toString().toLowerCase()}${textsplit[1].substring(1)}';

    Stream<QuerySnapshot> r =  Firestore.instance
        .collection("Produtos_On")
        .where("tags", arrayContains :t1)
        .where("tags", arrayContains :t2)
        .snapshots();
        if (r.isEmpty != null){
            setState(() {
              widget.ref = Firestore.instance
                  .collection("Produtos_On")
                  .where("tags", arrayContains :t1)
                  .where("tags", arrayContains :t2)
                  .snapshots();
            });
        }
  }


  if (textsplit.length==1){
    text = '${textsplit[0][0].toString().toLowerCase()}${textsplit[0].substring(1)}';
    Stream<QuerySnapshot> r =  Firestore.instance
        .collection("Produtos_On").where("tags", arrayContains :text)
        .snapshots();
        if (r.isEmpty != null)
        {
          setState(() {
           widget.ref = Firestore.instance
                .collection("Produtos_On").where("tags", arrayContains :text)
                .snapshots();
          });
        }
  }



}

@override
Widget build(BuildContext context) {


    return Scaffold(

      body: Center(

          child:
          Container(decoration: BoxDecoration(color: Colors.white), child:
          Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  color: Colors.white,
                  child:CustomPaint(

                    painter: headCurve(Colors.orange),
                  ),
                ),
                Expanded(child:
                StreamBuilder(
                    stream: widget.ref,
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
                barNavBottom("Busca",true, "",(value) {
                  return _query(value);
                },null),
              ])
          )),
    );
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



