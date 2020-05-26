import 'package:cloud_firestore/cloud_firestore.dart';


class enderecoUserSnapShot {

  var rua;
  var bairro;
  var numero;
  var complemento;
  var localizacao;

  enderecoUserSnapShot (DocumentSnapshot snapshot){
    this.rua=snapshot['rua'];
    this.bairro=snapshot['bairro'];
    this.numero=snapshot['numero'];
    this.complemento=snapshot['complemento'];
    this.localizacao=snapshot['localizacao'];
  }


  getenderecoUser (){
    Map<String, dynamic> p = {
      'rua':this.rua,'bairro':this.bairro,'numero':this.numero,
      'complemento':this.complemento,'localizacao':this.localizacao
    };
    return p;
  }



}