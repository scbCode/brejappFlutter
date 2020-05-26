import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firestore/main.dart';
import 'package:flutter_firestore/viewBusca.dart';
import 'package:page_transition/page_transition.dart';

import 'animationItem.dart';
import 'dropdownBasic.dart';


class distanciaUser {

  var nome;
  var distancia;

  distanciaUser(String nome,String distancia){
    this.nome=nome;
    this.distancia=distancia;
  }


  getdistanciaUser(){
    Map<String, dynamic> p = {
      'nome':this.nome,'distancia':this.distancia
    };
    return p;
  }



}