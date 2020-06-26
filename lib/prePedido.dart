import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firestore/enderecoUser.dart';
import 'package:flutter_firestore/item_cesta.dart';

import 'Produto_cesta.dart';

class Pedido {

  var total;
  var frete;
  Map<String,dynamic> enderecoEntrega;
  var tipoPagamento;
  var troco;
  var time;
  var idloja;
  var nomeUser;
  var tellUser;
  var status;
  var statusPagamento;
  var emailUser;
  var idPedido;
  var timeAguardando;
  var timeConfirmado;
  var timeEntrega;
  var motivoRecusa;
  List<dynamic> lista_produtos;



  Pedido();

  setPedido(DocumentSnapshot snapshot){
    this.total=snapshot['total'];
    this.frete=snapshot['frete'];
    this.enderecoEntrega=snapshot['enderecoEntrega'];
    this.tipoPagamento=snapshot['tipoPagamento'];
    this.troco=snapshot['troco'];
    this.time=snapshot['time'];
    this.idloja=snapshot['idloja'];
    this.nomeUser=snapshot['nomeUser'];
    this.tellUser=snapshot['tellUser'];
    this.status=snapshot['status'];
    this.emailUser=snapshot['emailUser'];
    this.statusPagamento=snapshot['statusPagamento'];
    this.lista_produtos=snapshot['lista_produtos'];
    this.idPedido=snapshot['idPedido'];
    this.timeAguardando=snapshot['timeAguardando'];
    this.timeConfirmado=snapshot['timeConfirmado'];
    this.motivoRecusa=snapshot['motivoRecusa'];
  }


  getPedidoMap(){

    Map<String, dynamic> p = {
      'total':this.total,'frete':this.frete,'enderecoEntrega':this.enderecoEntrega,
      'tipoPagamento':this.tipoPagamento,'troco':this.troco,'time':this.time,'idloja':this.idloja
      ,'nomeUser':this.nomeUser,'tellUser':this.tellUser,'status':this.status,
      'statusPagamento':this.statusPagamento,'lista_produtos':this.lista_produtos,
      'emailUser':this.emailUser,
      'idPedido':this.idPedido,
      'timeAguardando':this.timeAguardando,
      'timeConfirmado':this.timeConfirmado,
      'timeEntrega':this.timeEntrega,
      'motivoRecusa':this.motivoRecusa,
    };
    return p;
  }
}