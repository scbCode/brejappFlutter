
import 'package:cloud_firestore/cloud_firestore.dart';

class CardUser{

  var digitos;
  var bandeira;
  var token;
  var tipo;
  var check;
  DocumentSnapshot snapshot;

  CardUser(DocumentSnapshot snapshot){
    this.digitos=snapshot["digitos"];
    this.bandeira=snapshot["bandeira"];
    this.token = snapshot["token"];
    this.tipo = snapshot["tipo"];
    this.check = snapshot["check"];
  }

  getproduto(){
    Map<String, dynamic> p = {
      'digitos':this.digitos,'bandeira':this.bandeira,'token':this.token ,'tipo':this.tipo ,'check':this.check };
    return p;
  }

}