
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'itemListLojas.dart';

typedef OpenPerfil = String Function(String);

class listaLojas extends StatefulWidget {

  var view_resumo_cesta=false;

  OpenPerfil openperfil;
  listaLojas (this.openperfil);

  @override
  listaProdutoState createState() => listaProdutoState ();

}


class listaProdutoState  extends State<listaLojas> {



  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection("Perfil_loja").where('online',isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text("AGUARDE....");
            case ConnectionState.none:
              return new Text("sem item");
              // TODO: Handle this case.
              break;
            case ConnectionState.active:
              return new ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return itemListLojas(snapshot.data.documents[index],(value){openPerfilLoja(value);});
                  }
              );
              // TODO: Handle this case.
              break;
            case ConnectionState.done:
              return new Text("sem item");
              // TODO: Handle this case.
              break;
          }

        }
    );

  }

  openPerfilLoja(var id){

    widget.openperfil(id);
  }

}