import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firestore/Produto.dart';
import 'package:flutter_firestore/animator.dart';
import 'package:flutter_firestore/distanciaLoja.dart';
import 'package:flutter_firestore/enderecoUser.dart';
import 'package:flutter_firestore/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'BlocAll.dart';
import 'Produto_cesta.dart';

typedef showLoginPop = bool Function();

class itemListProd extends StatefulWidget {

  Produto_cesta produto;
  List<distanciaLoja> distancias=null;
  final showLoginPop callback_login;
  var local_user=null;
  var  listaCesta = [];
  var refresh=false;
  var itemOncheck=false;
  var uid;

  itemListProd (this.produto,this.local_user, this.distancias,this.listaCesta,@required this.callback_login);

  @override
  _itemListProdstate createState() => _itemListProdstate();

}


class _itemListProdstate extends State<itemListProd>  {
  distanciaLoja distancia;
  var total=1;
  var incremental=0;
  var totalPreco=0.0;
  var totalPrecotxt=0.0;
  var opc=0.0;
  var vbtnremoveitem=false;
  var vbtnRemoveqntd=false;
  var addvisi=false;
  var itemOn=false;
  var checkOn;
  var colorBtnAdd=Colors.orange;
  var textBtnadd="ADICIONAR";
  var arrow=Icons.arrow_drop_down;
  var view_dist=false;
  var distanceMatrix;
  var isLocationEnabled=false;
  var gelada=false;
  var   qntd = 1;
  var uid;
  final bloc = BlocAll();
  var styleTextFreteGratis = TextStyle(letterSpacing: 1.5,color: Colors.red,fontSize: 10,fontStyle: FontStyle.italic,fontFamily: 'RobotoBold');
  var styleTextFrete =TextStyle(letterSpacing: 0.1,color: Colors.grey[700],fontSize: 12,fontFamily: 'RobotoLight');
  var styleTextFrete_ =TextStyle(color: Colors.grey[700],fontSize: 12,fontFamily: 'RobotoLight');

  AnimationController _controllerIcon;

  @override
  Widget build(BuildContext context) {
    if (widget.produto.quantidade==null)
      widget.produto.quantidade=total;

    if (itemOn==true){
      _itemOn();
    }
    else{
      _itemOff();
    }
    return
      animator(
          GestureDetector(
              onTap: (){
                setState((){
                  if (addvisi==false) {
                    addvisi=true;
                  }else
                  {
                    addvisi=false;
                  }
                });
              },
              child:
              StreamBuilder<List<dynamic>>(
                  stream: bloc.check,
                  builder: (context,value) {
                    if (value.connectionState==ConnectionState.active) {
//                      print("BLOC ITEM CESTA ATIVO");
                      if (value.data.isNotEmpty) {
                        var ct5rl=false;
                        for ( int i = 0;i< value.data.length;i++ ){
                          if (value.data[i].id==widget.produto.id){
                              print("BLOC ITEM == ITEM "+value.data[i].quantidade.toString());
                              if ( widget.produto.quantidade==0)
                                widget.produto.quantidade=1;
                              widget.produto.quantidade=value.data[i].quantidade;
                              total=widget.produto.quantidade+incremental;
                              incremental=0;
                              ct5rl=true;
                          }
                        }
                        if (ct5rl){
                          print("BLOC ITEM TRUE");
                          itemOn=true;
                          return _item_(itemOn);
                        }
                        else {
                          print("BLOC ITEM FALSE");
                          itemOn=false;
                          return _item_(itemOn);
                        }
                      }else {
                        print("BLOC ITEM FALSE");
                        itemOn=false;
                        return _item_(itemOn);
                      }
                    }else{
                      print("BLOC ITEM FALSE");
                      itemOn=false;
                      return _item_(itemOn);
                    }
                    {
                      //CASO AGUARDANDO DADOS
                      itemOn=false;
                      return _item_(itemOn);
                    }
                  })
          ), new Duration(milliseconds: 500));
  }


  _item_(var ativo){

    if (ativo){
      textBtnadd="NA CESTA";
      total = widget.produto.quantidade;
      int q = widget.produto.quantidade;
      print("ITEM ON "+q.toString());
      if (q == 1){
        vbtnremoveitem=true;
        vbtnRemoveqntd=false;
      }
      if (q > 1){
        vbtnremoveitem=false;
        vbtnRemoveqntd=true;
      }
      colorBtnAdd=Colors.green;
    }

    return
      Container(
          margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start ,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(width: 50,height: 100, padding: EdgeInsets.fromLTRB(0, 5, 0, 5) , margin: EdgeInsets.fromLTRB(5, 0, 0, 0), alignment: Alignment.centerRight , child:
                  Image.network(widget.produto.img)),
                  Expanded(
                      child:
                      Container(
                          margin: EdgeInsets.all(10),
                          child:
                          Stack(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    Container(margin:EdgeInsets.fromLTRB(10, 0, 0, 0),child:Text(widget.produto.nome,textAlign: TextAlign.left, style: TextStyle(letterSpacing: 0.0,fontSize:18,fontFamily: 'BreeSerif'))),

                                    Visibility(visible: widget.produto.gelada,child:
                                    Container(
                                        decoration: BoxDecoration(border: Border.all(color: Colors.lightBlue[400]),borderRadius: BorderRadius.all(Radius.circular(3))),
                                        padding: EdgeInsets.fromLTRB(4, 1, 4, 0),
                                        margin:EdgeInsets.fromLTRB(4, 3, 0, 0),height: 15,child:
                                    Text("gelada",style: TextStyle(fontSize: 10,color: Colors.lightBlue[400]),)))
                                  ],),
                                  Container(margin:EdgeInsets.fromLTRB(10, 0, 0, 0),child:Text(widget.produto.descricao,textAlign: TextAlign.left, style: TextStyle(letterSpacing: 0.7, color: Colors.grey[700], fontSize:12,fontFamily: 'RobotoLight'))),
                                  Container(margin:EdgeInsets.fromLTRB(10, 0, 0, 0),child:Text(widget.produto.vol,textAlign: TextAlign.left, style: TextStyle(letterSpacing: 1.9, color: Colors.grey[700], fontSize:12,fontFamily: 'RobotoLight'))),
                                  Row (mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(alignment: Alignment.bottomRight,margin: EdgeInsets.fromLTRB(10, 4, 5, 0), child:Text(widget.produto.loja,textAlign: TextAlign.right, style: TextStyle(letterSpacing: 0.5,color: Colors.orange[300] ,fontSize:12,fontFamily: 'RobotoLight'))),
                                      Container(margin: EdgeInsets.fromLTRB(5, 5, 5, 0), decoration: BoxDecoration(color:Colors.orange,borderRadius: BorderRadius.all(Radius.circular(20))),width: 5,height: 5,),
                                      Visibility(
                                        visible:view_dist,child:
                                      Container(margin: EdgeInsets.fromLTRB(0, 5, 0, 0), child:  Text(distanceTo().toString(),style: TextStyle(letterSpacing: 0.1,color: Colors.grey[700],fontSize: 12,fontFamily: 'RobotoLight'),)),
                                      ),
                                    ],),
                                  Container(margin: EdgeInsets.fromLTRB(10, 5, 0, 0), child:  Text("Entrega: "+formatFrete(),style: styleTextFrete),),

                                ],),
                              Container(
                                  alignment: Alignment.centerRight,
                                  margin:EdgeInsets.fromLTRB(0, 15, 5, 0),child:Text("R\u0024 "+_FormatPreco(widget.produto.preco.toString()),textAlign: TextAlign.left, style: TextStyle(color: Colors.deepOrangeAccent,fontSize:24,fontFamily: 'BreeSerif'))),
                            ],))),


                ],),
              Stack(children: <Widget>[
                Visibility(
                  visible: addvisi || itemOn==true,
                  child:
                  Column(children: <Widget>[Divider(
                    color: Colors.orange[200],
                  ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //btn adicionar
                        StreamBuilder<List<dynamic>>(
                            stream: bloc.check,
                            builder: (context,value) {
                              if (value.connectionState==ConnectionState.active) {
                                var ctrol = false;
                                print("GET CESTA ++++");
                                widget.listaCesta.clear();
                                widget.listaCesta.addAll(value.data);

                                if (value.data.isNotEmpty) {
                                  return
                                    Container(
                                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0), child:
                                    OutlineButton(hoverColor: Colors.orange,
                                        focusColor: Colors.orange,
                                        textTheme: ButtonTextTheme.normal,
                                        splashColor: Colors.orange,
                                        color: Colors.yellow[300],
                                        onPressed: () {
                                           print("click");
                                          _addLista();
                                        },
                                        child:
                                        Row(children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                            child: Icon(
                                                Icons.shopping_basket, color: colorBtnAdd,
                                                size: 15),),
                                          Text(textBtnadd + " R\u0024 " +
                                              totalPrecotxt.toStringAsFixed(2).replaceAll(
                                                  ".", ","), style: TextStyle(
                                              color: colorBtnAdd,
                                              fontFamily: 'RobotoLight'),)
                                        ])));
                                } else
                                  return
                                    Container(
                                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0), child:
                                    OutlineButton(hoverColor: Colors.orange,
                                        focusColor: Colors.orange,
                                        textTheme: ButtonTextTheme.normal,
                                        splashColor: Colors.orange,
                                        color: Colors.yellow[300],
                                        onPressed: () {
                                          print("click2");
                                          _addLista();
                                        },
                                        child:
                                        Row(children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                            child: Icon(
                                                Icons.shopping_basket, color: colorBtnAdd,
                                                size: 15),),
                                          Text(textBtnadd + " R\u0024 " +
                                              totalPrecotxt.toStringAsFixed(2).replaceAll(
                                                  ".", ","), style: TextStyle(
                                              color: colorBtnAdd,
                                              fontFamily: 'RobotoLight'),)
                                        ])));
                              }else
                                return
                                  Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0), child:
                                  OutlineButton(hoverColor: Colors.orange,
                                      focusColor: Colors.orange,
                                      textTheme: ButtonTextTheme.normal,
                                      splashColor: Colors.orange,
                                      color: Colors.yellow[300],
                                      onPressed: () {
                                        widget.listaCesta.add(widget.produto);
                                        print("click3");
                                        _addLista();
                                      },
                                      child:
                                      Row(children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                          child: Icon(
                                              Icons.shopping_basket, color: colorBtnAdd,
                                              size: 15),),
                                        Text(textBtnadd + " R\u0024 " +
                                            totalPrecotxt.toStringAsFixed(2).replaceAll(
                                                ".", ","), style: TextStyle(
                                            color: colorBtnAdd,
                                            fontFamily: 'RobotoLight'),)
                                      ])));
                            }),

                        //total qntd
                        Opacity(
                            opacity: 1,
                            child:
                            Container(margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                              alignment: Alignment.bottomRight,
                              child: Text("$total",style: TextStyle(fontSize: 14,color: colorBtnAdd,fontFamily: 'RobotoBold'),),
                            )),
                        //botao + qntd
                        new GestureDetector(
                            onTap: (){
                              setState((){
                                _incrementQntdItem();
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)),border:  Border.all(color: colorBtnAdd)),
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 20),
                                child: SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: Icon(Icons.plus_one, color:colorBtnAdd)
                                )
                            )
                        ),
                        Visibility(visible:vbtnremoveitem,child:
                        Opacity(
                            opacity: 1,
                            child:   Container(margin: EdgeInsets.fromLTRB(0, 0, 0, 0),child:
                            new GestureDetector(
                                onTap: (){
                                  setState((){
                                    _removeItemCesta();
                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)),border:  Border.all(color: Colors.red)),
                                    margin: EdgeInsets.fromLTRB(10, 5, 0, 10),
                                    padding: EdgeInsets.fromLTRB(0, 4, 0, 2),
                                    child: SizedBox(
                                      width: 35,
                                      height: 28,
                                      child
                                          :Icon(Icons.remove_shopping_cart,color:Colors.red,size: 18,),

                                    )
                                )
                            )
                            )
                        )),
                        //btn - qntd
                        Visibility(visible:vbtnRemoveqntd, child:
                        Container(margin: EdgeInsets.fromLTRB(0, 0, 0, 0),child:
                        new GestureDetector(
                            onTap: (){
                              setState((){
                                print("ok");
                                _decrementQntdItem();

                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)),border:  Border.all(color: colorBtnAdd)),
                                margin: EdgeInsets.fromLTRB(15, 5, 0, 10),
                                padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                                child: SizedBox(
                                  width: 35,
                                  height: 28,
                                  child: Text("-1", textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: colorBtnAdd),),

                                )
                            )
                        )
                        )
                        ),

                      ],)],),
                ),
              ],)
            ],)
      );
  }

  _decrementQntdItem(){
    setState(() {
      if (itemOn==true){
        if (total>1) {
          setState(() {
            incremental -= 1;
          });
          decrementItemCesta_on(widget.produto);
        }
      }else {
        if (total>1){
          total-=1;
          totalPreco-=widget.produto.preco;
          totalPrecotxt = totalPreco;}
        if (total==1){
          vbtnRemoveqntd=false;
        }
      }
    });

  }

  formatFrete(){

    var coef = widget.produto.coefKm;
    var distKm=0.0;
    if (widget.distancias.toString() != "[]"){
      print("FRETE "+widget.distancias.toString());
      for(int i = 0; i < widget.distancias.length;i++){
        if (widget.distancias[i].loja == widget.produto.loja){
          if (widget.distancias[i].distancia!=null)
            distKm = double.parse(widget.distancias[i].distancia)/1000;
        }
      }

      if ( widget.produto.distanciaGratisKm>=distKm){
        styleTextFrete=styleTextFreteGratis;
        return "grátis";
      }else {
        if (distKm != 0.0) {
          styleTextFrete=styleTextFrete_;
          var frete = (coef * distKm).round();
          var fretef = frete.toStringAsFixed(2).toString();
          return "R\u0024 "+fretef;
        } else
          return "...";
      }
    } else
      return "...";
  }


  _incrementQntdItem(){

    if (itemOn==true){
      opc=1.0;
      vbtnRemoveqntd=true;
      if (widget.produto.quantidade<99) {
        setState(() {
          incremental += 1;
        });
        incrementItemCesta_on(widget.produto);
      }
    }else{
      opc=1.0;
      vbtnRemoveqntd=true;
      setState(() {
        totalPreco += widget.produto.preco;
        totalPrecotxt = totalPreco;
        incremental += 1;
        total+=1;
        print("total : "+total.toString());
        widget.produto.quantidade=total;
      });
    }
  }


  _itemOff(){
    print("item off");
    setState(() {
      vbtnremoveitem=false;
      textBtnadd="ADICIONAR";
//      total=1;
      colorBtnAdd=Colors.orange;
    });

  }
  _itemOn(){
    setState(() {

      textBtnadd="NA CESTA";
      total = widget.produto.quantidade;
      int q = widget.produto.quantidade;
      print("ITEM ON "+q.toString());
      if (q == 1){
        vbtnremoveitem=true;
        vbtnRemoveqntd=false;
      }
      if (q > 1){
        vbtnremoveitem=false;
        vbtnRemoveqntd=true;
      }
      colorBtnAdd=Colors.green;
    });
  }



  _addLista() async{
    print("_addLista");

    var check = await checkLogado() ;
    if(widget.local_user!=null){

      if (itemOn==false)
        if (check==true){
            print("setlist");
          addItemCesta(widget.produto);
        }else
        {
          widget.callback_login();
        }
    }else
    {
      print ("addlista null");
      widget.callback_login();
    }
  }


  _removeItemCesta() async{

    await Firestore.instance.collection("Usuarios")
        .document(uid).collection("cesta").document(widget.produto.id).delete();

    setState(() {
      itemOn=false;
      widget.produto.cesta=false;
    });

  }


  _snackbar(text){
    final snackBar = SnackBar(content: Text(text));
    Scaffold.of(context).showSnackBar(snackBar);
  }


  checkLogado()  async  {
    var firebaseUser  = await FirebaseAuth.instance.currentUser();
    if(firebaseUser == null)
    {
      _snackbar("Você não está logado");
      return false;
    }
    else{

      return true;
    }
  }

  _FormatPreco(String preco){

    totalPrecotxt=double.parse(preco)*total;

    if (preco.length<=2)
      preco = preco+",00";
    if (preco.contains("."))
      preco= preco.replaceAll(".", ",");
    if (preco.length==3)
      preco+="0";


    return preco;
  }

  void decrementItemCesta_on(Produto_cesta item) async{

    Produto_cesta  p =item;
    total-=1;
    item.quantidade=total;

    if (uid!=null)
      await Firestore.instance.collection("Usuarios")
          .document(uid).collection("cesta").document(item.id).updateData(p.getproduto());

  }


  void incrementItemCesta_on(Produto_cesta item) async{

    Produto_cesta  p =item;
    total+=1;
    item.quantidade=total;
    if (uid!=null)
      await Firestore.instance.collection("Usuarios")
          .document(uid).collection("cesta").document(item.id).updateData(p.getproduto());
  }


  void addItemCesta(Produto_cesta item) async{
    var ctrol = false;
    if(widget.listaCesta!=null){
      if(widget.listaCesta.length>0) {
        for (int i = 0;i<widget.listaCesta.length;i++){
          if (widget.listaCesta[0].idloja != item.idloja) {
            print("loja diff");
            ctrol = true;
          }
        }
      }
    }

    print("addItemCesta "+widget.listaCesta.length.toString());

    item.quantidade=total;
    if (ctrol==false){
        await Firestore.instance.collection("Usuarios")
            .document(uid).collection("cesta").document(item.id).setData(item.getproduto())
        .then((e){
            setState(() {
              print("add item lista pos load");
              bloc.getCesta();
              itemOn = true;
              widget.produto.cesta = true;
              colorBtnAdd=Colors.green;
              vbtnremoveitem = true;
              vbtnRemoveqntd=false;
              widget.produto.quantidade = total;
            });
        });
    }else
    {
      _snackbar("Voçê possui itens de outra loja na sua cesta, deseja substituir");

    }

  }


  @override
  void initState() {



    getUser();
    super.initState();
  }

  getUser () async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    if (user!=null)
    uid =  user.uid;

    if (uid!=null)
    bloc.getCesta();
//    _controllerIcon = AnimationController(duration: Duration(milliseconds: 10000));
//
//    setState(() {
//      _controllerIcon.forward(from: 0.0);
//      _controllerIcon.repeat();
//    });

    if ( widget.distancias!=null) {
      view_dist=true;
    }else{
    }

  }



  @override

  void dispose() {
//    _controllerIcon.dispose();

    super.dispose();
  }


  String distanceTo() {

    var ctrol =false;
    var distTxt = "...";
    if ( widget.distancias!=[])
      if ( widget.distancias.isNotEmpty)
        if ( widget.distancias!=null){
          for(int i = 0; i < widget.distancias.length;i++){
            if (widget.distancias[i].distancia!=null)
              if (widget.distancias[i].loja == widget.produto.loja){
                var unidadeMedida="";
                double valeu = double.parse(widget.distancias[i].distancia);
                if (valeu<1000)
                  unidadeMedida="m";
                else {
                  valeu=valeu/1000;
                  unidadeMedida = "km";
                }
                distTxt= valeu.toStringAsFixed(1)+""+unidadeMedida;
                ctrol=true;
              }
          }
        }else
        {
        }
    return distTxt;

  }

  _getLocation() async {
    if (isLocationEnabled == false)
      isLocationEnabled = await Geolocator().isLocationServiceEnabled();

    if (isLocationEnabled == true) {
      var currentLocation = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      widget.local_user = currentLocation;
      refresh();
//      checkDistanceAtual();
    }

  }



  refresh(){
    setState(() {

    });
  }

  calcFret(){
    var fretefinal;



    return fretefinal;
  }

}

