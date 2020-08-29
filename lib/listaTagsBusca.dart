import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


typedef changeRefLista = String Function(String,String,String);

class listaTagsBusca extends StatefulWidget {

  changeRefLista buscaFiltro;
  listaTagsBusca(this.buscaFiltro);

  @override
  listaTagsBuscaState createState() => listaTagsBuscaState();

}

class listaTagsBuscaState extends State<listaTagsBusca> {

  TextEditingController control_busca = TextEditingController();

  var buscaSelecionada = "tudo";
  var buscaMarcaFiltro = "-";
  var buscaMarcaFiltrotam = "-";
  var itemselect = "";
  var streamMarcas=   Firestore.instance
      .collection("marcas_on").snapshots();
  var streamMarcasTamanho=  Firestore.instance
      .collection("tamanho_embalagens_on").snapshots();
  var itemTipo_;
  var listatipo;
  Color c_busca = Colors.grey[400];
  Color c_tudo = Colors.orange;
  Color c_marca = Colors.grey[400];
  Color c_tipo = Colors.grey[400];
  Color c_loja = Colors.grey[400];
  Color c_tamanho = Colors.grey[400];
  Color selectitem = Colors.grey[400];
  var tiposelecionado="";
  var listaFiltros = ["busca","tudo","marca","tipo","lojas","tamanho"];


  @override
  Widget build(BuildContext context) {

    if (buscaSelecionada=="busca"){
      c_busca = Colors.orange;
      c_tudo = Colors.grey[400];
      c_marca = Colors.grey[400];
      c_tipo = Colors.grey[400];
      c_loja = Colors.grey[400];
      c_tamanho = Colors.grey[400];

    }

    if (buscaSelecionada=="tudo"){
      c_tudo = Colors.orange;
      c_busca = Colors.grey[400];
      c_marca = Colors.grey[400];
      c_tipo = Colors.grey[400];
      c_loja = Colors.grey[400];
      c_tamanho = Colors.grey[400];
    }
    if (buscaSelecionada=="marca"){
       c_marca = Colors.orange;
       c_busca = Colors.grey[400];
       c_tudo = Colors.grey[400];
       c_tipo = Colors.grey[400];
       c_loja = Colors.grey[400];
       c_tamanho = Colors.grey[400];
    }
    if (buscaSelecionada=="tipo"){
      c_marca =Colors.grey[400];
      c_busca = Colors.grey[400];
      c_tudo = Colors.grey[400];
      c_tipo =  Colors.orange;
      c_loja = Colors.grey[400];
      c_tamanho = Colors.grey[400];
    }
    if (buscaSelecionada=="loja"){
      c_marca =Colors.grey[400];
      c_tudo = Colors.grey[400];
      c_tipo =  Colors.grey[400];
      c_loja = Colors.orange;
      c_tamanho = Colors.grey[400];
    }
    if (buscaSelecionada=="tamanho"){
      c_marca =Colors.grey[400];
      c_busca = Colors.grey[400];
      c_tudo = Colors.grey[400];
      c_tipo =  Colors.grey[400];
      c_loja = Colors.grey[400];
      c_tamanho = Colors.orange;
    }

    return
    Column(children: <Widget>[


      //TUDO
    Container(
          height: 45,
          child:
    ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: listaFiltros.length,
        itemBuilder: (context, index) {

          if (listaFiltros[index]=="busca")
            return
              GestureDetector(
                  onTap: (){
                    setState(() {
                      buscaMarcaFiltrotam='-';
                      buscaMarcaFiltro='-';

                      if (buscaSelecionada!="busca")
                      buscaSelecionada="busca";
                      else{
                        buscaSelecionada="tudo";
                        widget.buscaFiltro("tudo","preco","-");
                      }
                    });
                  },
                  child:
                  Container(
                    margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    decoration: BoxDecoration(
                      ),
                    child:
                    Icon(Icons.search,color: c_busca,)));


          if (listaFiltros[index]=="tudo")
              return
            GestureDetector(
              onTap: (){
                setState(() {
                  buscaMarcaFiltrotam='-';
                  buscaMarcaFiltro='-';
                  buscaSelecionada="tudo";
                  widget.buscaFiltro(buscaSelecionada,"preco",'-');

                });
              },
              child:
              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                decoration: BoxDecoration(
                    border: Border.all(color: c_tudo, width: 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(20))),
                child: Text("Tudo",style: TextStyle(fontFamily: 'BreeSerif',color: c_tudo)),));

          if (listaFiltros[index]=="marca")
            return
            GestureDetector(
              onTap: (){
                      setState(() {
                        buscaMarcaFiltrotam='-';
                        buscaMarcaFiltro='-';      buscaSelecionada = "marca";
                        itemselect="";
                      });
              },
                 child:
              Container(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
              decoration: BoxDecoration(
              border: Border.all(color: c_marca, width: 1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(20))),
              child: Text("Marcas",style: TextStyle(fontFamily: 'BreeSerif',color: c_marca)),));
          if (listaFiltros[index]=="tipo")
          return
          GestureDetector(
          onTap: (){
          setState(() {
            buscaMarcaFiltrotam='-';
            buscaMarcaFiltro='-'; buscaSelecionada="tipo";
          itemselect="";
          });
          }, child:
          Container(
          margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          decoration: BoxDecoration(
          border: Border.all(color:c_tipo, width: 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(20))),
          child: Text("Tipos",style: TextStyle(fontFamily: 'BreeSerif',color: c_tipo)),));
          if (listaFiltros[index]=="lojas")
          return
          GestureDetector(
          onTap: (){
          setState(() {
          buscaSelecionada="loja";});
          buscaMarcaFiltrotam='-';
          buscaMarcaFiltro='-';  itemselect="";
          },
          child:
          Container(
          margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          decoration: BoxDecoration(
          border: Border.all(color:c_loja, width: 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(20))),
          child: Text("Lojas",style: TextStyle(fontFamily: 'BreeSerif',color: c_loja)),));
          if (listaFiltros[index]=="tamanho")
          return
          GestureDetector(
          onTap: (){
          setState(() {
            buscaMarcaFiltrotam='-';
            buscaMarcaFiltro='-';
          buscaSelecionada="tamanho";});
          itemselect="";
          }, child:
          Container(
          margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          decoration: BoxDecoration(
          border: Border.all(color: c_tamanho, width: 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(20))),
          child: Text("Tamanho",style: TextStyle(fontFamily: 'BreeSerif',color: c_tamanho))));


        })),

    // MARCA
    Visibility(
        visible: buscaSelecionada=="marca",
        child:
    Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          width: MediaQuery.of(context).size.width,
          child:
        StreamBuilder(
        stream:streamMarcas,
        builder: (context, snapshot) {
         if (snapshot.connectionState == ConnectionState.active) {
          return
            Column(children: [

              Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child:
              ListView.builder(
            padding: EdgeInsets.all(0),
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {

            var nome = snapshot.data.documents[index]['nome'];

                   return
                   GestureDetector(
                       onTap: (){
                         setState((){
                         buscaMarcaFiltrotam='-';
                         buscaMarcaFiltro=nome;});
                         widget.buscaFiltro(buscaSelecionada,buscaMarcaFiltro,'-');
                       },
                       child:
                     Container(
                         margin: EdgeInsets.all(5),
                         decoration:
                            BoxDecoration(color:Colors.white,boxShadow: [BoxShadow(color:Colors.grey[300],blurRadius: 2)],
                                borderRadius: BorderRadius.all(Radius.circular(50))),
                         child:
                     Image.network(snapshot.data.documents[index]['url_icon'],
              width: 40,height: 40,)));
            })),
             Visibility(
                 visible:buscaMarcaFiltro!="-",
                 child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child:
                  StreamBuilder(
                      stream: streamMarcasTamanho,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.active) {
                          return ListView.builder(
                              padding: EdgeInsets.all(0),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {

                                var nomevol = snapshot.data.documents[index]['nome'];
                                var cor=Colors.grey;
                                if (buscaMarcaFiltrotam==nomevol)
                                  cor=Colors.orange;
                                else
                                  cor=Colors.grey;

                                return
                                  GestureDetector(
                                      onTap: (){
                                        setState((){});
                                        buscaMarcaFiltrotam=nomevol;
                                        widget.buscaFiltro(buscaSelecionada,buscaMarcaFiltro,nomevol);
                                      },
                                      child:
                                      Container(
                                          margin: EdgeInsets.all(5),
                                          alignment: Alignment.center,
                                          child:
                                          Text(snapshot.data.documents[index]['nome'],style:
                                          TextStyle(color:cor,fontFamily: 'RobotoBold'),
                                          )));
                              });
                        }else
                          return Container();
                      })))
            ],);
      }else
        return Container();
    }))),

    Visibility(
          visible: buscaSelecionada=="loja",
          child:
          Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child:
              StreamBuilder(
                  stream: Firestore.instance
                      .collection("lojas_on_busca").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      return
                        ListView.builder(
                            padding: EdgeInsets.all(0),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {

                              return
                                itemTipo(snapshot,index);
                            });
                    }else
                      return Container();
                  }))),

    //TIPO
    listaTipos(),
      // MARCA
      Visibility(
          visible: buscaSelecionada=="tamanho",
          child:
          Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child:
              StreamBuilder(
                  stream:   Firestore.instance
                      .collection("tamanho_embalagens_on").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      return ListView.builder(
                          padding: EdgeInsets.all(0),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {

                            var nome = snapshot.data.documents[index]['nome'];

                            return
                              GestureDetector(
                                  onTap: (){
                                    widget.buscaFiltro(buscaSelecionada,nome,'-');
                                  },
                                  child:
                                  Container(
                                      margin: EdgeInsets.all(5),
                                      padding: EdgeInsets.all(5),
                                      alignment: Alignment.center,
                                      decoration:
                                      BoxDecoration(color:Colors.white,boxShadow: [BoxShadow(color:Colors.grey[300],blurRadius: 2)],
                                          borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child:
                                      Text(snapshot.data.documents[index]['nome'],style: TextStyle(fontFamily: 'RobotoBold'),
                                      )));
                          });
                    }else
                      return Container();
                  }))),


      Visibility(
          visible: buscaSelecionada=="busca",
          child:
          Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child:   TextField(decoration: InputDecoration(hintText: "Qual cerveja hoje?"),
                controller: control_busca,
                onChanged: (value){
                  buscaManual(value);
                },
                keyboardType: TextInputType.text ,
                style: TextStyle(fontSize: 24,color:Colors.orange,
                    fontFamily: 'RobotoLight'),)
           )),



    ],);

  }

  @override
  void initState() {
    super.initState();
  }


  buscaManual(var texto){
    if (texto.length>2)
    widget.buscaFiltro("tags",texto,'-');
  }


  listaTipos(){
   return
     Visibility(
         visible: buscaSelecionada=="tipo",
         child:
         Container(
             margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
             width: MediaQuery.of(context).size.width,
             height: 50,
             child:
             StreamBuilder(
                 stream: Firestore.instance
                     .collection("tipos_cervejas").snapshots(),
                 builder: (context, snapshot) {
                   if (snapshot.connectionState == ConnectionState.active) {
                     return ListView.builder(
                         padding: EdgeInsets.all(0),
                         scrollDirection: Axis.horizontal,
                         itemCount: snapshot.data.documents.length,
                         itemBuilder: (context, index) {
                           var nome = snapshot.data.documents[index]['nome'];
                           var select= Colors.grey[400];
                           if (nome==itemselect)
                             select=Colors.orange;

                           return
                             GestureDetector(
                                 onTap: (){
                                   widget.buscaFiltro(buscaSelecionada,nome,'-');
                                   setState(() {
                                     itemselect=nome;
                                   });

                                 },
                                 child:
                                 Container(
                                     alignment: Alignment.center,
                                     margin: EdgeInsets.all(5),
                                     padding: EdgeInsets.all(5),
                                     decoration:
                                     BoxDecoration(color:Colors.white,boxShadow: [BoxShadow(color:select,blurRadius: 2)],
                                         borderRadius: BorderRadius.all(Radius.circular(10))),
                                     child:
                                     Text(snapshot.data.documents[index]['nome'],style: TextStyle(fontFamily: 'RobotoBold'),
                                     )));
                         });
                   }else
                     return Container();
                 })));
  }


  itemTipo(var snapshot,var index){
    var nome = snapshot.data.documents[index]['nome'];

    return
      GestureDetector(
        onTap: (){
          widget.buscaFiltro(buscaSelecionada,nome,'-');
        },
        child:
        Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            decoration:
            BoxDecoration(color:Colors.white,boxShadow: [BoxShadow(color:Colors.grey[300],blurRadius: 2)],
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child:
            Text(snapshot.data.documents[index]['nome'],style: TextStyle(fontFamily: 'RobotoBold'),
            )));
  }


  
}
