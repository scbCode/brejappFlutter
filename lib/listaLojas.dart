
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

  var marcas =
  [
    "https://firebasestorage.googleapis.com/v0/b/brejapp-flutter.appspot.com/o/o-brahma.png?alt=media&token=a9c0362d-da89-4079-8bc4-f22079b6dbee",
    "https://firebasestorage.googleapis.com/v0/b/brejapp-flutter.appspot.com/o/o-budweiser.png?alt=media&token=547573e8-aa3f-4937-8c19-f9fa818c57d7",
    "https://firebasestorage.googleapis.com/v0/b/brejapp-flutter.appspot.com/o/o-corona.png?alt=media&token=5ede9836-f3e6-403d-9b9e-9e0cba81715e",
    "https://firebasestorage.googleapis.com/v0/b/brejapp-flutter.appspot.com/o/o-brahma.png?alt=media&token=a9c0362d-da89-4079-8bc4-f22079b6dbee",
    "https://firebasestorage.googleapis.com/v0/b/brejapp-flutter.appspot.com/o/o-budweiser.png?alt=media&token=547573e8-aa3f-4937-8c19-f9fa818c57d7",
    "https://firebasestorage.googleapis.com/v0/b/brejapp-flutter.appspot.com/o/o-corona.png?alt=media&token=5ede9836-f3e6-403d-9b9e-9e0cba81715e"
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection("Perfil_loja")
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
                    return itemListLojas(snapshot.data.documents[index],marcas,(value){openPerfilLoja(value);});
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