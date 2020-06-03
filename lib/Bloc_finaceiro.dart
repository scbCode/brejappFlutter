
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Loja.dart';
import 'Produto_cesta.dart';

class Bloc_financeiro {

  final control_check = StreamController<String>.broadcast();
  Stream <String> get get_frete => control_check.stream;


  void dispose() {
    control_check.close();
  }



  callTokenrizarCartao(var CustomerName,var CardNumber,var Holder,var ExpirationDate,var Brand) async {

    final HttpsCallable callable = await CloudFunctions(region: "us-central1").getHttpsCallable(
      functionName: 'criarToken',
    );
    dynamic resp = await callable.call(<String, dynamic>{
      'CustomerName': CustomerName,
      'CardNumber': CardNumber,
      'Holder': Holder,
      'ExpirationDate': ExpirationDate,
      'Brand': Brand
    });

    return resp.data;
  }

}





