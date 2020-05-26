import 'package:cloud_firestore/cloud_firestore.dart';

class Loja {

  var nome;
  var id;
  var img;
  var snapshot;

  Loja(DocumentSnapshot snapshot){
    this.nome=snapshot['nome'];
    this.id=snapshot['id'];
    this.img=snapshot['img'];
  }


  getLoja(){
    Map<String, dynamic> p = {
      'nome':this.nome,'id':this.id,'img':this.img
    };
    return p;
  }

}