import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firestore/main.dart';
import 'package:flutter_firestore/viewBusca.dart';
import 'package:page_transition/page_transition.dart';

import 'animationItem.dart';
import 'dropdownBasic.dart';


class distanciaLoja {

  var loja;
  var distancia;
  var duracao;

  distanciaLoja(
      this.loja,
      this.distancia,
      this.duracao,
    );


  getdistanciaLoja(){
    Map<String, dynamic> p = {
      'loja':this.loja,'distancia':this.distancia,'duracao':this.duracao
    };
    return p;
  }



}