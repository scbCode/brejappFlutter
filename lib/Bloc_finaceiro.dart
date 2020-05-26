
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Loja.dart';
import 'Produto_cesta.dart';

class Bloc_financeiro {

  final control_check = StreamController<String>.broadcast();
  Stream <String> get get_frete => control_check.stream;

  void dispose() {
    control_check.close();
  }

}





