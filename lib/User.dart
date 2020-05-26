import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firestore/main.dart';
import 'package:flutter_firestore/viewBusca.dart';
import 'package:page_transition/page_transition.dart';

import 'animationItem.dart';
import 'dropdownBasic.dart';


class User {

  var nome;
  var tell;
  var email;
  var uid;
  var localizacao;

  User(String nome,String tell, String email, String uid, var localizacao){
    this.nome=nome;
    this.tell=tell;
    this.email=email;
    this.uid=uid;
    this.localizacao=localizacao;
  }


  getUser(){
    Map<String, dynamic> p = {
      'nome':this.nome,'tell':this.tell,'email':this.email,'uid':this.uid,'localizacao':this.localizacao
    };
    return p;
  }



}