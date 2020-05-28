import 'package:cloud_firestore/cloud_firestore.dart';

class Loja {

  var nome;
  var id;
  var img;
  var cartaoApp;
  var maquinaCredito;
  var snapshot;

  Loja(DocumentSnapshot snapshot){
    this.nome=snapshot['nome'];
    this.id=snapshot['id'];
    this.img=snapshot['img'];
    this.cartaoApp=snapshot['cartaoApp'];
    this.maquinaCredito=snapshot['maquinaCredito'];
  }


  getLoja(){
    Map<String, dynamic> p = {
      'nome':this.nome,'id':this.id,'img':this.img,'cartaoApp':this.cartaoApp,'maquinaCredito':this.maquinaCredito
    };
    return p;
  }

}