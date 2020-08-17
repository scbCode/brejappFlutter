
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firestore/barNavBottom.dart';
import 'package:flutter_firestore/itemListProd.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'BlocAll.dart';
import 'Produto_cesta.dart';
import 'enderecoUser.dart';
import 'headCurve.dart';
import 'itemListLojas.dart';


typedef closePerfil =  Function();
typedef sendItemCesta = Produto_cesta Function(Produto_cesta);

class perfil_loja extends StatefulWidget {

  var idloja;
  var loja;
  var listaCesta;
  closePerfil closePerfil_;
  sendItemCesta sendItemCesta_;
  perfil_loja(this.listaCesta,this.loja,this.closePerfil_,this.sendItemCesta_ );

  Stream<QuerySnapshot> ref = Firestore.instance
      .collection("Perfil_lojas").where("nome", isEqualTo :"")
      .snapshots();

  @override
  perfil_lojaState createState() => perfil_lojaState();

}

class perfil_lojaState extends State<perfil_loja> {

  var t="x";
  LatLng local_user;
  var distanciaKM="";
  var frete="";
  var v_popadditem=false;
  var listaprod;
  var prodadd;
  var listaCores=[];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return
      Scaffold(
        body:

            LimitedBox(maxHeight: MediaQuery.of(context).size.height,child:
            SingleChildScrollView(child:
                Container(decoration: BoxDecoration(color: Colors.white), child:
            Stack(children: <Widget>[

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                   _barTop(),

              Row(

                children: <Widget>[
              GestureDetector(
                  onTap: (){
                    widget.closePerfil_();
                  },
                  child:
                Container(margin: EdgeInsets.fromLTRB(10,30,0,0),
                  alignment: Alignment.centerLeft,
                  child:
                  Icon(Icons.arrow_back,size:35,color:Colors.grey),)),

                Container(margin: EdgeInsets.fromLTRB(10,30,0,0),
                  child:
                  Text(widget.loja['nome'],
                    style: TextStyle(color:Colors.orange,
                        fontSize: 24,fontFamily: 'BreeSerif'),),),
              ],),

                Container(margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child:Image.network(widget.loja['url'],width: 50,)),

                Row (mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(margin: EdgeInsets.fromLTRB(0, 5, 0, 0), child:  Text("Distância: "+distanciaKM,style: TextStyle(color: Colors.grey[500],fontSize: 13,fontFamily: 'RobotoLight'),)),
                    Container(margin: EdgeInsets.fromLTRB(3, 5, 5, 0), decoration: BoxDecoration(color:Colors.orange,borderRadius: BorderRadius.all(Radius.circular(20))),width: 5,height: 5,),
                    Container(margin: EdgeInsets.fromLTRB(0, 5, 0, 0), child:  Text("Frete: "+getfrete(),style: TextStyle(color: Colors.grey[500],fontSize: 13,fontFamily: 'RobotoLight'),)),
                  ],),


                Row ( mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Visibility(
                          visible: widget.loja['vendaPeloApp'],
                          child:
                      Container(margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Image.asset("card-app.png",width: 20))),
                      Visibility(
                        visible: true,
                        child:
                        Container(margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                            child: Image.asset("card_machine.png",width: 20))),
                  ],),
//              Container ( alignment: Alignment.centerLeft, margin: EdgeInsets.fromLTRB(10, 10, 0, 0), child:  Text(widget.loja['endereco']['rua'] ,style: TextStyle(color: Colors.grey[500],fontSize: 13,fontFamily: 'RobotoLight'),)),
                Container (
                    margin: EdgeInsets.fromLTRB(10, 10, 0, 10),alignment: Alignment.centerLeft,
                  child: Text("Produtos",style: TextStyle(color:Colors.orange,fontSize: 18,
                      fontWeight: FontWeight.w800 ,fontFamily: 'BreeSerif'),
                    textAlign: TextAlign.start),),
                listaprod
              ]),

              Visibility(
                  visible:v_popadditem,
                  child:
                  Container(
                      decoration:BoxDecoration(color:Colors.black54),
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height,
                      child:
                      Container(
                          padding: EdgeInsets.all(15),
                          child:
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    decoration:BoxDecoration(color:Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        boxShadow: [BoxShadow(color:Colors.grey)]),
                                    child:
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[

                                          Container(
                                              margin:EdgeInsets.fromLTRB(10, 10, 10, 0),
                                              child:
                                              Text("Adicionar à cesta?",style: TextStyle(fontSize: 20),)),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      v_popadditem=false;
                                                    });
                                                    widget.sendItemCesta_(prodadd);
                                                  },
                                                  child:
                                                  Container(
                                                      decoration:BoxDecoration(color:Colors.orange,borderRadius: BorderRadius.all(Radius.circular(10))),
                                                      margin:EdgeInsets.fromLTRB(10, 20, 10, 10),
                                                      padding:EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                      child:
                                                      Text("Sim",style: TextStyle(fontSize: 20,color: Colors.white),))),

                                              GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      v_popadditem=false;
                                                      prodadd=null;
                                                    });
                                                  },
                                                  child:
                                                  Container(
                                                    decoration:BoxDecoration(color:Colors.grey,borderRadius: BorderRadius.all(Radius.circular(10))),
                                                    margin:EdgeInsets.fromLTRB(10, 20, 10, 10),
                                                    padding:EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                    child:
                                                    Text("Não",style: TextStyle(fontSize: 20,color: Colors.white)),)),
                                            ],)
                                        ]))

                              ])
                      )
                  ))


            ]))),)

    );
  }

  _barTop(){
    return Column(children: <Widget>[
      Container( height: 24,decoration: BoxDecoration(color: Colors.orange[300]),),
    ],);
  }

  getColorsMarcas(){
    Firestore.instance
        .collection("ColorsMarca")
        .snapshots().listen((event) {
          event.documents.forEach((element) {
            setState((){
                listaCores.add(element.data);
            });
          });

    });

  }


  listaprodutos(){
    return
     Container(
         padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
         height: 210,
         child:
     StreamBuilder(
        stream: Firestore.instance
            .collection("Produtos_On")
            .where("idloja",isEqualTo: widget.loja['idloja'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState==ConnectionState.active){
            return
              new
              ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    var color = Color(0xFF330000) ;
                    if (listaCores.length>0)
                        listaCores.forEach((element) {
                        if (element['nome'] == snapshot.data.documents[index]['nome'])
                            color =  Color(int.parse(element['hex']));
                      });

                    return
                      GestureDetector(
                          onTap: (){

                            setState(() {
                              v_popadditem=true;
                              Produto_cesta produto =  new Produto_cesta(snapshot.data.documents[index]);
                              produto.quantidade=1;
                              prodadd=produto;
                            });
                          },
                          child:
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 3.0,
                                      offset: Offset(
                                        0.0, // horizontal, move right 10
                                        1.0, // vertical, move down 10
                                      ),
                                    )
                                  ],
                                  color: Colors.white
                              ),
                              child:

                             Row(children:[

                               RotatedBox(
                                   quarterTurns: -1,
                                   child:
                                    Container(
                                        width: 210,
                                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                        decoration:BoxDecoration(color:color),
                                        child:
                                        Column(children:[


                                        Text( snapshot.data.documents[index]['nome'],
                                          style: TextStyle(fontSize: 20,color: Colors.white,fontFamily: 'RobotoBold'),
                                          textAlign: TextAlign.center, ),

                                          Container(
                                              margin:EdgeInsets.all(0) ,
                                              child:
                                              Text(snapshot.data.documents[index]['vol'],
                                                style: TextStyle(fontSize: 20,color: Colors.white,fontFamily: 'RobotoLight'),)),

                                      ]),


                             )),
                                    Column(children: <Widget>[

                                      Visibility(
                                          visible: true,
                                          child:
                                          Container(
                                              margin: EdgeInsets.fromLTRB(30, 10, 30, 5),
                                              child:
                                              Image.network(
                                                snapshot.data.documents[index]['img'],height: 150,))),

                                      Container(
                                          alignment: Alignment.center,
                                          child:
                                          Text("R\$ "+ (snapshot.data.documents[index]['preco'].toStringAsFixed(2).replaceAll(".",",")),
                                            style: TextStyle(fontFamily: 'BreeSerif',fontSize: 24,color: Colors.deepOrangeAccent),textAlign: TextAlign.center, )),



                                    ],) ])));
                  }
              );}else return Container();
        }
    ));
  }


 getfrete(){

    if (distanciaKM!=""){
        var km = distanciaKM.replaceAll("km", "");
         km = km.replaceAll("m", "");
        km = km.replaceAll(",", ".");
        var kmdouble = double.parse(km)*widget.loja['coefKm'];
        return (kmdouble).toStringAsFixed(2);
    }else
        return "";

 }


  void getEnderecoUser() async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    var document = await Firestore.instance.collection('Usuarios').document(uid);
        document.collection("endereco")
            .document("Entrega")
            .snapshots()
            .listen((data) => {
              setUiEndereco(data)
            });
  }

  void setUiEndereco(var data){
    setState(() {

      if (data.exists) {
        enderecoUser    endereco = new enderecoUser(
            data['rua'], data['bairro'], data['numero'], data['complemento'],
            data['localizacao'],data['temp']);
        local_user = LatLng(endereco.localizacao.latitude,endereco.localizacao.longitude);

      }else {
        print("ENDERECO NULL");

      }
    });
  }



  void addItemCesta(Produto_cesta item) async{
    var ctrol = false;
    if(widget.listaCesta!=null){
      if(widget.listaCesta.length>0) {
        for (int i = 0;i<widget.listaCesta.length;i++) {
          if (widget.listaCesta[0].idloja != item.idloja) {
            print("loja diff");
            ctrol = true;
          }
          if (widget.listaCesta[0].nome != item.nome) {
            ctrol = true;
          }
        }
      }
    }

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    final bloc = BlocAll();

    if (ctrol==false){
      await Firestore.instance.collection("Usuarios")
          .document(uid).collection("cesta").document(item.idloja+""+item.id).setData(item.getproduto())
          .then((e){
        setState(() {
          bloc.getCesta();
        });
      });
    }else
    {

    }

  }

  @override
  void initState() {
    getColorsMarcas();
    getDistanciaLoja(widget.loja['idloja']);
    listaprod=listaprodutos();
    super.initState();
  }

  getDistanciaLoja(var idloja) async{


    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user!=null){
      await Firestore.instance.collection("Usuarios")
          .document(user.uid).collection("distancias")
          .document(idloja)
          .snapshots().listen((data) => {
             getdistancia  (data)
      });
    }
  }

  getdistancia(var data){
    setState(() {
        distanciaKM=distanceTo(data['distancia']);
        print("distanciaKM");
        print(distanciaKM);

    });
  }



  distanceTo(var distancia) {
    var distTxt = distancia;
    var unidadeMedida = "";
    double valeu = double.parse(distancia);
    if (valeu < 1000)
      unidadeMedida = "m";
    else {
      valeu = valeu / 1000;
      unidadeMedida = "km";
    }
    distTxt = valeu.toStringAsFixed(1) + "" + unidadeMedida;

    return distTxt;
  }

}




