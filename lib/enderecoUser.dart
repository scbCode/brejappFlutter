import 'package:cloud_firestore/cloud_firestore.dart';


class enderecoUser {

  var rua;
  var bairro;
  var numero;
  var complemento;
  var localizacao;
  var temp;

  enderecoUser (String rua,String bairro, String numero, String complemento, GeoPoint localizacao,temp){
    this.rua=rua;
    this.bairro=bairro;
    this.numero=numero;
    this.complemento=complemento;
    this.localizacao=localizacao;
    this.temp=temp;
  }


  getenderecoUser (){
    Map<String, dynamic> p = {
      'rua':this.rua,'bairro':this.bairro,'numero':this.numero,'complemento':this.complemento,'localizacao':this.localizacao,'temp':this.temp
    };
    return p;
  }



}