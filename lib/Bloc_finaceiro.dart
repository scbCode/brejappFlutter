
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


  enviarMsgChat(var msg,var  emailUsuario,var uidUsuario,var remetente,var idloja,var idPedido,var time) async {

    var refData = Firestore.instance;
    var ctrol=false;
    await refData.collection("Usuarios")
        .document(uidUsuario).collection('Pedidos').document(idPedido).collection('chat')
        .add({
      'emailUsuario': emailUsuario,
      'msg': msg,
      'remetente': remetente,
      'time': FieldValue.serverTimestamp(),
      'idloja': idPedido
    }).then((v){
      print("SAVE MSG");
    }).catchError((erro){
      print("SAVE MSG ERROR");
    });

    final HttpsCallable callable = await CloudFunctions.instance.getHttpsCallable(
      functionName: 'enviarMsgChatUserParaLoja',
    );
    dynamic resp = await callable.call(<String, dynamic>{
      'emailUsuario': emailUsuario,
      'msg': msg,
      'remetente': remetente,
      'time': "123",
      'idloja': idloja
    });
    return resp.data;
  }





  callTokenrizarCartao(var CustomerName,var CardNumber,var Holder,var ExpirationDate,var Brand) async {

    final HttpsCallable callable = await CloudFunctions.instance.getHttpsCallable(
      functionName: 'criarToken',
    );
    dynamic resp = await callable.call(<String, dynamic>{
      'CustomerName': CustomerName,
      'CardNumber': CardNumber.toString().trim(),
      'Holder': Holder,
      'ExpirationDate': ExpirationDate,
      'Brand': Brand
    });
    return resp.data;
  }



  Future<bool> saveTokenCartaoUser(var uid, var token) async {
        var refData = Firestore.instance;
        var ctrol=false;
        await refData.collection("Usuarios")
            .document(uid).collection('cartoes')
            .add({'token':token,'criado':FieldValue.serverTimestamp(),'tipo':'credito','bandeira':'Master','maskNumb':'9876'  })
            .then((v){
              print("SAVE CARD");
              ctrol=true;
             return  true;
            }).catchError((erro){
              print("SAVE CARD ERROR");
        });

         return ctrol;

  }

}





