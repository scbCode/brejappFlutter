
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firestore/animator.dart';

import 'Loja.dart';
import 'Produto_cesta.dart';

class Bloc_financeiro {

  final control_check = StreamController<String>.broadcast();
  Stream <String> get get_frete => control_check.stream;



  void dispose() {
    control_check.close();
  }


  enviarMsgChat(var msg,var  emailUsuario,var uidUsuario,var remetente,var idloja,var idPedido,var time,var nome) async {

    DateTime timeAguard = DateTime.now();
    var refData = Firestore.instance;
    var ctrol=false;
    await refData.collection("Usuarios")
        .document(uidUsuario).collection('Pedidos')
        .document(idPedido).collection('chat')
        .add({
            'emailUsuario': emailUsuario,
            'msg': msg,
            'remetente': remetente,
            'time': timeAguard,
            'idloja': idloja,
            'idPedido':idPedido,
            'nome': nome
    }).then((v){
      print("SAVE MSG");
    }).catchError((erro){
      print("SAVE MSG ERROR");
    });

//    final HttpsCallable callable = await CloudFunctions.instance.getHttpsCallable(
//      functionName: 'enviarMsgChatUserParaLoja',
//    );
//    dynamic resp = await callable.call(<String, dynamic>{
//      'emailUsuario': emailUsuario,
//      'msg': msg,
//      'remetente': remetente,
//      'time': timeAguard.toIso8601String(),
//      'idPedido': idPedido,
//      'nome': nome,
//      'idloja': idloja
//    });
    return true;

  }

  pagamentoCatao(var CustomerName,var idPedido,var idcard, var idLoja) async {

    print("pagamentoCatao "+idPedido);
    final HttpsCallable callable = await CloudFunctions.instance.getHttpsCallable(
      functionName: 'pagamentoCredito',
    );

    dynamic resp = await callable.call(<String, dynamic>{
      'nomeComprador': CustomerName,
      'idPedido': idPedido,
      'idCard': idcard,
      'idLoja':idLoja,
      'time':""
    });

    print("pagamentoCatao data");
    print(resp.data);

    if (resp.data!=null){
      print("pagamentoCatao data 1");

      var body = resp.data['body'];
      var result =  resp.data['resp'];
      print("pagamentoCatao data 2 "+result);

      if (result!=null && result == 'Sucesso'){

        if (body['ReturnCode']=="4")
          return  true;
        else
        if (body['ReturnCode']=="6")
          return  true;
        else
        if (body['ReturnCode']=="05")
        return  false;
        else
        if (body['ReturnCode']=="57")
        return  false;
        else
        if (body['ReturnCode']=="78")
        return  false;
        else
          return  true;


      }else
        return  false;

    }else
      return  false;
  }



  deleteCartao(var uid,var id)async{
    var refData = Firestore.instance;
    await Firestore.instance.collection('Usuarios').document(uid)
        .collection("cartoes").document(id).delete();

    return true;

//    refData.collection("Usuarios")
//        .document(uid).collection('cesta').orderBy("status").getDocuments().then((event) {
//      for(int i =0;i<event.documents.length;i++) {
//        event.documents[i].reference.delete();
//      }
//    });

  }



  callTokenrizarCartao(var CustomerName,var CardNumber,var Holder,var ExpirationDate,var Brand) async {

      final HttpsCallable callable = await CloudFunctions.instance.getHttpsCallable(
        functionName: 'criarToken');

      dynamic resp = await callable.call(<String, dynamic>{
        'CustomerName': CustomerName,
        'CardNumber': CardNumber.toString().trim(),
        'Holder': Holder,
        'ExpirationDate': ExpirationDate,
        'Brand': Brand
      });
      return resp.data;

  }



  Future<bool> saveTokenCartaoUser(var uid, var token,var nome) async {
        var refData = Firestore.instance;
        var ctrol=false;
        await refData.collection("Usuarios")
            .document(uid).collection('cartoes')
            .add({'token':token,'criado':FieldValue.serverTimestamp(),
          'nome':nome,
          'tipo':'credito','bandeira':'Master','maskNumb':'9876'  })
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





