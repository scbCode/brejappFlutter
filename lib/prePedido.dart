import 'package:flutter_firestore/enderecoUser.dart';
import 'package:flutter_firestore/item_cesta.dart';

class Pedido {

  var total;
  var frete;
  enderecoUser enderecoEntrega;
  var tipoPagamento;
  var troco;
  var time;
  var idLoja;
  var nomeUser;
  var tellUser;
  var status;
  List<item_cesta> lista_produtos;

  Pedido();

}