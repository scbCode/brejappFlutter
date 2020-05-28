
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Produto{

  var nome;
  var preco;
  var descricao;
  var vol;
  var loja;
  var id;
  var img;
  var tags;
  var gelada;
  var coefKm;
  var distanciaMaxKm;
  var distanciaGratisKm;
  bool cartaoApp;
  bool maquinaCartao;
  LatLng localizacao;
  DocumentSnapshot snapshot;

  Produto(DocumentSnapshot snapshot){
    this.nome=snapshot["nome"];
    this.preco=snapshot["preco"];
    this.descricao = snapshot["descricao"];
    this.vol =  snapshot["vol"];
    this.loja =  snapshot["loja"];
    this.img =  snapshot["img"];
    this.id =  snapshot["id"];
    this.tags =  snapshot["tags"];
    this.gelada =  snapshot["gelada"];
    this.coefKm =  snapshot["coefKm"];
    this.distanciaMaxKm =  snapshot["distanciaMaxKm"];
    this.distanciaGratisKm =  snapshot["distanciaGratisKm"];
    this.localizacao =  snapshot["localizacao"];
    this.cartaoApp =  snapshot["cartaoApp"];
    this.maquinaCartao =  snapshot["maquinaCartao"];
  }

   getproduto(){

    Map<String, dynamic> p = {
     'nome':this.nome,'preco':this.preco,'vol':this.vol,'loja':this.loja,'img':this.img,'id':this.id,
      'tags':this.tags,'localizacao':this.localizacao,'gelada':this.gelada,
      'coefKm':this.coefKm,'distanciaMaxKm':this.distanciaMaxKm,'distanciaGratisKm':this.distanciaGratisKm,'cartaoApp':this.cartaoApp,'maquinaCartao':this.maquinaCartao
    };
    return p;
  }

}