import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firestore/User.dart';
import 'package:flutter_firestore/barCurve.dart';
import 'package:flutter_firestore/distanciaLoja.dart';
import 'package:flutter_firestore/enderecoUser.dart';
import 'package:flutter_firestore/enderecoUserSnapShot.dart';
import 'package:flutter_firestore/form_endereco_user.dart';
import 'package:flutter_firestore/headCurve.dart';
import 'package:flutter_firestore/itemListLojas.dart';
import 'package:flutter_firestore/prePedido.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'BlocAll.dart';
import 'dart:ui';
import 'dart:async';

import 'Bloc_finaceiro.dart';
import 'CardUser.dart';
import 'Loja.dart';
import 'Produto_cesta.dart';
import 'cartao_form.dart';
import 'itemCards.dart';
import 'itemCarduser.dart';
import 'item_cesta.dart';


typedef show_blur_bg =  Function(bool);
typedef show_btn_float =  Function(bool);

class barCesta extends StatefulWidget  {

  List<Produto_cesta> listaCesta = new List<Produto_cesta>();
  distanciaLoja listaDistancia_ ;
  show_blur_bg call_back_show_bg;
  show_btn_float show_btn_float_;
  var view_barra_ctrol;
  User user;
  barCesta (this.view_barra_ctrol,this.user,this.listaCesta,this.listaDistancia_,this.call_back_show_bg,this.show_btn_float_);

  @override
  barCestaState createState() => barCestaState();

}


class barCestaState extends State<barCesta>   {

  var controller_mask_troco= new MaskedTextController(mask: '0,00', text: '');

  var top=1.0;
  var right=0.0;
  var bottom=0.0;
  var qntdItens=0.0;
  var qntdItenstxt="";
  var view_remove=false;
  var totaltxt="";
  var total=0.0;
  var frete=0.0;
  var v_cartaoapp=false;
  TextEditingController c_cvv = TextEditingController();

  var listaProdutos;
  var pedidoMinimo=0;
  double initial=0.0;
  var bloc = BlocAll();
  var bloc_financeiro = Bloc_financeiro();
  var view_resumo_cesta=false;
  var fazerpedido=false;
  var view_cestadetalhes=false;
  var view_formpag=false;
  var view_resumo_compra=false;
  var view_cestadetalhespreco=false;
  var view_form_end=false;
  GoogleMapController mapController;
  Produto_cesta selecionado;
  var listaCesta_;
  var ctrolControls=false;
  var alturaBarra=0.0;
  var barra_;
  var cor_endereco=Colors.white;
  var ctrol_view_btnEnd=false;
  var confirmarEndereco=false;
  var confirmarFormaPag=false;
  var confirmarEnderecoviewbtn=false;
  var bttmResumo=0.0;
  var iconCheckPagamento_dinheiro=Icons.radio_button_unchecked;
  var iconCheckPagamento_maquina=Icons.radio_button_unchecked;
  var iconCheckPagamento_cartao=Icons.radio_button_unchecked;
  var iconCheckPagamento=Icons.radio_button_unchecked;
  var cartaoselect=-1;
  var cardSelecionado;
  var view_cvv_pop=false;
  var idcardselecionado;
  var tipoPagSelectItem;
  var pagSelect=false;
  var pagSelectfinal=false;
  var show_popprocessando=false;
  var show_popprocessando_erro=false;
  var tipoPag="";
  var view_troco=false;
  var view_deb_maq=false;
  var view_cred_maq=false;
  var view_card_form = false;
  var greyfilter=BlendMode.color;
  var idCartao;
  enderecoUserSnapShot end_user;
  enderecoUser end_user_;
  var view=false;
  var user;
  var cartao = false;
  var maquina = false;
  double distance=0.0;
  var enderecoView ;
  var enderecoTemp_=false;
  var blur_bg;
  var layout_dinheiro;
  var layout_maquina;
  var layout_cartao;
  var view_cards_;
  var iconesCardsCheck=[];
  var itemListaCard_;
  var viewcomprapagamento_;
  var troco=0.0;

  @override
  Widget build(BuildContext context) {

   if (widget.view_barra_ctrol==false){
     //listaCesta_=listaCesta();
   }

   if (widget.listaCesta!=null)
      if (widget.listaCesta.length==0)
        setState(() {
          widget.call_back_show_bg(false);
        });

    if (pagSelect!=false){
        setState(() {
          viewcomprapagamento_=viewresumopagamento();
          view_cestadetalhes = false;
          view_resumo_cesta=false;
          view_resumo_compra=true;
          fazerpedido=true;
        });
    }else
      {
        fazerpedido=false;
      }


    if (confirmarEndereco==false){
      setState(() {
        cor_endereco=Colors.white;
//        ctrol_view_btnEnd=true;
        iconCheckPagamento_dinheiro=Icons.radio_button_unchecked;
        iconCheckPagamento_maquina=Icons.radio_button_unchecked;
      });
    }else
    {
      setState(() {
        cor_endereco=Colors.amber[100];
//          enderecoView = enderecoView_();
      });
    }

    if (widget.listaCesta[0].cartaoApp!=null)
      setState(() {
        cartao = widget.listaCesta[0].cartaoApp;
      });

    if (widget.listaCesta[0].maquinaCartao!=null)
      setState(() {
        maquina = widget.listaCesta[0].maquinaCartao;
      });

    v_cartaoapp=widget.listaCesta[0].cartaoApp;

    if (widget.user.uid==null)
      return Container();
    else
    return

      Visibility(visible: view,child:
      barCompleta());

  }


  @override

  void dispose() {
    controller_mask_troco.dispose();
    super.dispose();
  }

  getLoja() async{
    print("getLoja");
    var idloja;
      Produto_cesta p =  widget.listaCesta[0];
       idloja=p.idloja;
    Loja loja = await bloc.getLojaPedido(idloja);
    if (loja!=null) {
      setState((){
        print("pedidoMinimo");
        print(loja.pedidoMinimo);
        pedidoMinimo= loja.pedidoMinimo;
      });
    }
    print("loja xxxy "+loja.tell);
  }

  barCompleta(){
    _checkreresult();
    return
//Container(decoration: BoxDecoration(color: Colors.transparent),child:
      SingleChildScrollView(child:
      Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[

            Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[

                  Visibility(visible: view_resumo_cesta || pagSelect,
                      child:blur_bg),

                  Visibility(visible: true,
                      child:
                  Container( decoration: BoxDecoration(color: Colors.transparent,boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 0.0,
                      offset: Offset(
                        0.0, // horizontal, move right 10
                        0.0, // vertical, move down 10
                      ),
                    )
                  ]),height: 45,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, alturaBarra),
                      child:
                      barra()
                  )),
                  //////////////////////////////////////////////////////////
                  Visibility(visible:show_popprocessando, child:
                    Container(child:
                    Column(children: [
                      aguardarresppagamento()
                    ],)),),
                  Visibility(visible:show_popprocessando_erro, child:
                    Container(child:
                    Column(children: [
                      returnoErroPagamentoCartao()
                    ],)),),
                  Visibility(visible: (pagSelectfinal), child:
                  viewcomprapagamento_,),


                  Visibility(visible:view_resumo_cesta || !widget.view_barra_ctrol && !fazerpedido, child:
//                  Visibility(visible:view_resumo_cesta || !widget.view_barra_ctrol && !fazerpedido, child:
                  LimitedBox(maxHeight:MediaQuery.of(context).size.height*.7,child:
                  SingleChildScrollView(child:
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, bttmResumo),
                      decoration: BoxDecoration(color: Colors.white,boxShadow: [
                        BoxShadow( color: Colors.black12,blurRadius:4.0,
                          offset: Offset(0.0,45.0,  ),)
                      ],),
                      child:
                      Column(
                          children: <Widget>[


                            Container(
                              decoration: BoxDecoration(color: Colors.white),
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child:
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(margin: EdgeInsets.fromLTRB(0, 0, 5, 0), decoration: BoxDecoration(color:Colors.orange,borderRadius: BorderRadius.all(Radius.circular(20))),width: 5,height: 5,),
                                  Container(alignment: Alignment.centerLeft,margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child:Text(widget.listaCesta[0].loja.toString().toUpperCase()+" ",textAlign: TextAlign.right, style: TextStyle(color: Colors.black ,fontSize:14,fontFamily: 'BreeSerif'))),
                                  Container(margin: EdgeInsets.fromLTRB(5, 0, 0, 0), decoration: BoxDecoration(color:Colors.orange,borderRadius: BorderRadius.all(Radius.circular(20))),width: 5,height: 5,),
//                         Container(margin: EdgeInsets.fromLTRB(10, 5, 0, 0), child:  Text("Frete: R\u0024 3,00 ",style: TextStyle(color: Colors.black54,fontSize: 14,fontFamily: 'BreeSerif')),),
//                         Container(margin: EdgeInsets.fromLTRB(5, 5, 5, 0), decoration: BoxDecoration(color:Colors.orange,borderRadius: BorderRadius.all(Radius.circular(20))),width: 5,height: 5,),
                                  //   Container(alignment: Alignment.centerLeft,margin: EdgeInsets.fromLTRB(0, 4, 5, 0), child:Text( formatDistancia(),textAlign: TextAlign.right, style: TextStyle(color: Colors.black54,fontSize:14,fontFamily: 'BreeSerif'))),
                                ],),
                            ),

                            Divider(color: Colors.black45,height: 2,),

                            Container(
                                margin: EdgeInsets.fromLTRB(0, 10,0, 5),
                                alignment: Alignment.topCenter, child: listaCesta_),

                            Text("Pedido mínimo de R\$ "+pedidoMinimo.toString(),style:
                            TextStyle(color: Colors.grey,fontFamily: 'BreeSerif',fontSize:16),),
//
                            Visibility(visible: !view_cestadetalhes,child:
                            GestureDetector(onTap: (){
                              setState(() {

                                var t = double.parse(total.toString().replaceAll(",", "."));
                                print('$pedidoMinimo  $t');
                                if (pedidoMinimo <= t){
                                if (view_cestadetalhes){
                                    view_cestadetalhes=false;}
                                  else
                                    view_cestadetalhes=true;
                                }else
                                  {
                                    _snackbar("Pedido mínimo de R\$ "+pedidoMinimo.toString().replaceAll('.',','));
                                  }

                              });
                            },
                              child:
                              Container(
                                  width: MediaQuery.of(context).size.width*0.5,
                                  decoration: BoxDecoration(border: Border.all(color: Colors.orange[200]), borderRadius: BorderRadius.all(Radius.circular(5))),
                                  margin: EdgeInsets.fromLTRB(0, 10,0, 10),
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  alignment: Alignment.topCenter, child:
                              Text("Fazer pedido",style:
                              TextStyle(color: Colors.orange,fontFamily: 'BreeSerif',fontSize:20),)),)),
//

                            Visibility(visible: view_cestadetalhes,child:
                            GestureDetector(onTap: (){
                              setState(() {
                                if (view_cestadetalhes){
                                    confirmarEndereco=false;
                                    view_resumo_compra=false;
                                    tipoPag="";
                                    pagSelect=false;
                                    view_formpag=false;
                                    view_cestadetalhes=false;
                                }
                                else{
                                  view_cestadetalhes=true;}
                              });
                            },
                              child:
                              Container(
                                  width: 100,
                                  margin: EdgeInsets.fromLTRB(0, 5,0, 0),
                                  alignment: Alignment.topCenter, child:
                              Icon(Icons.keyboard_arrow_up,color:Colors.orange)),)),

                            Visibility(visible:view_cestadetalhes, child:
                            Column(
                                children: <Widget>[
                                  Divider(color: Colors.orange,height: 2,),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.fromLTRB(10,10,0,0),
                                        alignment: Alignment.centerLeft,
                                        child: Text("Total com frete: "+totalComFrete()
                                          ,textAlign: TextAlign.center,style: TextStyle(fontSize: 19,fontFamily: 'BreeSerif',color: Colors.orange),)),

                                  ]),
                                  //END ENTREGA TEXT
                                  Visibility(visible:true, child:
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[

                                    Container(
                                        padding: EdgeInsets.fromLTRB(20,5,0,10),
                                        alignment: Alignment.center,
                                        child: Text("FRETE: "+formatFrete() ,style:
                                        TextStyle(fontStyle: FontStyle.italic,fontSize: 14,fontFamily:'RobotoRegular',color: Colors.black54),)),
                                    Visibility(visible: cartao,child:
                                    Container(
                                        padding: EdgeInsets.fromLTRB(5,0,0,0),
                                        alignment: Alignment.centerLeft,
                                        child: Image.asset("card-app.png",width: 20,height: 20,))),
                                    Visibility(visible: cartao,child:
                                    Container(
                                        padding: EdgeInsets.fromLTRB(10,0,0,0),
                                        alignment: Alignment.centerLeft,
                                        child: Image.asset("card_machine.png",width: 20,height: 20,))),
                                  ],)),

                                  Divider(color:Colors.grey),

                                  Visibility(visible: !pagSelect,child:
                                  Column(children: <Widget>[

                                  Container(
                                      margin: EdgeInsets.fromLTRB(10, 15,0,10),
                                      alignment: Alignment.center, child:
                                  Text("ENDEREÇO DE ENTREGA ",style:
                                  TextStyle(color: Colors.black87,fontSize: 18,fontFamily: 'BreeSerif'),)),

                                  Container(
                                      margin: EdgeInsets.fromLTRB(10, 0,0,10),
                                      alignment: Alignment.center, child:
//                              enderecoView_()
                                  enderecoView
                                  ),

                                  Visibility(
                                      visible: false ,
                                      child:
                                      GestureDetector(onTap: (){
                                        setState(() {
                                          confirmarEndereco=true;
                                          view_formpag=true;
                                          ctrol_view_btnEnd=false;
                                        });
                                      },
                                        child:
                                        Container(
                                            decoration: BoxDecoration(border: Border.all(color: Colors.orange[200]), borderRadius: BorderRadius.all(Radius.circular(5))),
                                            margin: EdgeInsets.fromLTRB(40, 5, 40, 30),
                                            padding: EdgeInsets.fromLTRB(0, 10, 0,10),
                                            alignment: Alignment.topCenter, child:
                                        Text("CONFIRMAR ENDEREÇO",textAlign: TextAlign.center,style:
                                        TextStyle(color: Colors.orange,fontFamily: 'RobotoBold'),)),)),
                                ])),


                   ])),


                            //PAGAMENTO VIEW
                            Visibility(visible: view_formpag,child:
                            Column(children: <Widget>[
                              Container(
                                  margin: EdgeInsets.fromLTRB(10, 10,0,10),
                                  alignment: Alignment.center, child:
                              Text("Qual a forma de pagamento?x",
                                style:
                                TextStyle(color: Colors.black,fontSize: 17,fontFamily: 'BreeSerif'),)),
                              //PAGUE DINHEIRO
                              pagamentoDinheiro(),
                              //MAQUINA CARTÃO
                              Visibility(visible: maquina,
                                  child:formaPagMaquina()),
                              Visibility(visible:view_troco,child:Container(height:75)),

                              //LISTA CARTOES USER
                              Visibility(visible:v_cartaoapp,child:
                                Column(children:[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(25, 10,0,10),
                                    alignment: Alignment.centerLeft, child:Text("Seus cartões",
                                    style:TextStyle(fontFamily: 'BreeSerif',fontSize:18,color:Colors.grey))),
                                //LISTA SEUS CARTOES
                                 view_cards_,
                                //BTN ADD CARTOES
                                pagamentoCartaoVazio(),
                              ])),

                            ])),
                      ])
                  )
            )),),

          ]),
          StreamBuilder(
              stream: Firestore.instance.collection('Lojas_ON')
                  .document(widget.listaCesta[0].idloja)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.active)
                  return Container();
                else
                if (snapshot.connectionState == ConnectionState.active)
                  if (snapshot.data.data!=null){
                    return Container();
                }else{
                    return
                      Visibility(
                        visible: view_resumo_cesta,
                        child:
                        Container(
                            alignment: Alignment.center,
                            width:MediaQuery.of(context).size.width,
                            height:MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(color:Colors.grey.withOpacity(.3)),
                            child:
                            Container(
                                alignment: Alignment.center,
                                height: 170,
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(color:Colors.white,
                                    boxShadow: [BoxShadow(color:Colors.grey,blurRadius: 3)],
                                    borderRadius: BorderRadius.all(Radius.circular(25))),
                                child:
                                Column(children:[
                                  Text("Esta loja ficou offline",
                                      style:TextStyle(fontFamily: 'BreeSerif',
                                          color:Colors.orange,fontSize: 24)),
                                Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    child:    Text("Não é possivel continuar com esse pedido",
                                      textAlign: TextAlign.center,style:TextStyle(fontFamily: 'BreeSerif',
                                          color:Colors.grey,fontSize: 18))),

                               GestureDetector(
                                   onTap:(){
                                     deleteCesta();
                                   },
                                   child:
                                  Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                      child:    Text("Limpar cesta aqui",
                                          style:TextStyle(fontFamily: 'RobotoLight',
                                              color:Colors.black,fontSize: 20)))),
                                ])
                            )));}
              }),

            Visibility(visible: view_cvv_pop  ,child:
            Column(
                children: <Widget>[
                  Container(
                      child: ClipRect(
                        child:  BackdropFilter(
                          filter:  ImageFilter.blur(sigmaX:1, sigmaY:1),
                          child:  Container(
                            width:MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            decoration:  BoxDecoration(color: Colors.grey.withOpacity(0.5)),
                            child:  Container(
                                width:MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(4),
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(4),
                                        decoration:
                                        BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(20)),
                                            boxShadow: [BoxShadow(color:Colors.grey,blurRadius: 2)] ,color:Colors.white),child:
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[

                                          GestureDetector(
                                              onTap:(){

                                                setState((){
                                                  view_cvv_pop=false;
                                                });
                                              },
                                              child:
                                    Container(
                                    margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                                    child: Icon(Icons.close) )),


                                          Container(
                                              margin: EdgeInsets.fromLTRB(10, 15, 10, 0),

                                              child:Text("Envie o códio de\nsegurança do cartão",textAlign: TextAlign.center ,
                                                  style: TextStyle(fontSize: 16,fontFamily: 'BreeSerif'))),
                                          Container(
                                              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                              child:Text("CVV",style: TextStyle(fontFamily: 'RobotoBold'),)),
                                          Container(width: 60, child:
                                          TextFormField(controller: c_cvv, textAlign: TextAlign.center,autofocus: true,
                                            decoration:
                                            InputDecoration(hintText: "000",hintStyle:
                                            TextStyle(color:Colors.grey)),)),
                                          GestureDetector(
                                              onTap:(){
                                                if (c_cvv.text.length==3) {
                                                  enviarPedido();
                                                  setState((){
                                                    view_cvv_pop=false;
                                                    show_popprocessando=true;
                                                    show_popprocessando_erro=false;
                                                    pagSelectfinal=false;
                                                  });

                                                } else
                                                  _snackbar("Digite o CVV, código de segurança do cartão .");
                                              },
                                              child:
                                              Container(
                                                decoration:BoxDecoration(color: Colors.green,borderRadius: BorderRadius.all(Radius.circular(20))),
                                                  margin: EdgeInsets.fromLTRB(20, 25, 20, 10),
                                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                                  child: Text("PAGAR",
                                                      style: TextStyle(fontSize: 16,
                                                          fontFamily: 'BreeSerif',color: Colors.white))))
                                        ])

                                    ),

                                  ],)
                            ),
                          ),
                        ),
                      ))
                ])),

            Container(decoration:BoxDecoration(borderRadius: BorderRadius.circular((20))),child:

            Visibility(child:
            formularioEndereco(),visible: view_form_end,)),

            Positioned(
                child:
                Visibility( child:
                formularioCartao(),visible: view_card_form,)),

          ]));
  }




  deleteCesta()async{
    Produto_cesta p = new Produto_cesta(listaProdutos[0]);
    await Firestore.instance.collection('Usuarios').document(widget.user.uid)
        .collection("cesta").getDocuments().then((event) {
         event.documents.forEach((element) {
              element.reference.delete();
         });
    });
  }

  returnoErroPagamentoCartao() {

    return
      LimitedBox(maxHeight:MediaQuery.of(context).size.height*.7,child:
      SingleChildScrollView(child:
      Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          margin: EdgeInsets.fromLTRB(0, 0, 0, bttmResumo),
          decoration: BoxDecoration(color: Colors.white,boxShadow: [
            BoxShadow( color: Colors.black12,blurRadius:4.0,
              offset: Offset(0.0,45.0,  ),)
          ],),
          child:
          Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width,
                    child:
                    Stack(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              margin:EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child:Text("Ocorreu um erro\n no pagamento :(",style: TextStyle(fontSize: 20,fontFamily: 'BreeSerif',letterSpacing: 0.4),)),
                        ])),

                Container(
                    padding:EdgeInsets.all(10),
                    margin:EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child:
                    Column(
                        children: <Widget>[
                          Icon(Icons.error,size: 50,color:Colors.red),
                        ])),

                GestureDetector(
                    onTap:(){
                      if (c_cvv.text.length==3) {
                        enviarPedido();
                        setState(() {
                          view_cvv_pop = false;
                          show_popprocessando = true;
                          show_popprocessando_erro = false;
                          pagSelectfinal = false;
                        });
                      }
                      } ,
                    child:
                Container(
                    padding:EdgeInsets.all(10),
                    margin:EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child:Text("Tentar novamente",
                      style: TextStyle(color:Colors.orange,fontSize: 20,
                          fontFamily: 'BreeSerif',letterSpacing: 0.4),))),

          GestureDetector(
              onTap:(){
                if (c_cvv.text.length==3) {
                  setState(() {
                    view_cvv_pop = false;
                    show_popprocessando = false;
                    show_popprocessando_erro = false;
                    pagSelectfinal = true;
                  });
                }
              } ,
              child:   Container(
                    padding:EdgeInsets.all(10),
                    margin:EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child:Text("Voltar",
                      style: TextStyle(color:Colors.grey,fontSize: 20,
                          fontFamily: 'BreeSerif',letterSpacing: 0.4),))),




              ])
      )));
  }


  aguardarresppagamento() {

    return
    LimitedBox(maxHeight:MediaQuery.of(context).size.height*.7,child:
    SingleChildScrollView(child:
    Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        margin: EdgeInsets.fromLTRB(0, 0, 0, bttmResumo),
        decoration: BoxDecoration(color: Colors.white,boxShadow: [
          BoxShadow( color: Colors.black12,blurRadius:4.0,
            offset: Offset(0.0,45.0,  ),)
        ],),
        child:
        Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  child:
                  Stack(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            margin:EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child:Text("PROCESSANDO COMPRA",style: TextStyle(fontSize: 20,fontFamily: 'BreeSerif',letterSpacing: 0.4),)),
                      ])),

              Container(
                  padding:EdgeInsets.all(10),
                  margin:EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child:
                  Column(
                      children: <Widget>[
                        Image.asset('gif_load.gif',width: 50,height: 50,),
                      ])),

              Container(
                padding:EdgeInsets.all(10),
                margin:EdgeInsets.fromLTRB(0, 0, 0, 0),
                child:Text("Aguarde...",
                  style: TextStyle(color:Colors.grey,fontSize: 20,fontFamily: 'BreeSerif',letterSpacing: 0.4),)),



            ])
    )));
  }


  getBandeira(var b){
    if (b == "Visa")
    return  Image.asset("visa.png",width: 40,height: 60,);
    if (b == "Master")
      return  Image.asset("visa.png",width: 40,height: 60,);
    else
      return  Image.asset("cardcredit.png",width: 40,height: 60,);

  }



  viewresumopagamento (){

    listaCesta_=listaCesta();

    String textbtnFinalPedido;
    if (tipoPag=="cartao")
      textbtnFinalPedido="Fazer pagamento";
    else
      textbtnFinalPedido="Finalizar pedido";


    return

  Visibility(visible: true ,child:
  LimitedBox(maxHeight:MediaQuery.of(context).size.height*.7,child:
  SingleChildScrollView(child:
  Container(
  width: MediaQuery.of(context).size.width,
  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
  margin: EdgeInsets.fromLTRB(0, 0, 0, bttmResumo),
  decoration: BoxDecoration(color: Colors.white,boxShadow: [
  BoxShadow( color: Colors.black12,blurRadius:4.0,
  offset: Offset(0.0,45.0,  ),)
  ],),
  child:
  Stack(
      children: <Widget>[

   Column(
  children: <Widget>[


    Container(
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width,
        child:
        Stack(
            children: <Widget>[
              GestureDetector(
                  onTap:(){
                    setState(() {
                      confirmarEndereco=false;
                      tipoPag="";
                      cartaoselect=-1;
                      pagSelect=false;
                      pagSelectfinal=false;
                      view_formpag=false;
                      view_resumo_cesta=true;
                      view_cestadetalhes=true;
                      listaCesta_=listaCesta();
                    });
                  },
                  child:
              Icon(Icons.arrow_back_ios,color:Colors.black54)),
              Container(
                  alignment: Alignment.center,
                  margin:EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child:Text("RESUMO DA COMPRA",style: TextStyle(fontSize: 20,fontFamily: 'BreeSerif',letterSpacing: 0.4),)),
    ])),

    Container(
        padding:EdgeInsets.fromLTRB(0, 10, 0, 10),
        margin:EdgeInsets.fromLTRB(0, 25, 0, 0),
        decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(3),topLeft: Radius.circular(3)),
            boxShadow: [BoxShadow(color: Colors.grey[400],blurRadius: 1)],color:Colors.white),
        child:
      Column(
          children: <Widget>[
      Container(
          width: MediaQuery.of(context).size.width,
         child:Text("Total com frete",textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'BreeSerif',fontSize: 16,letterSpacing: 0.4,color: Colors.grey))),
      Container(
          width: MediaQuery.of(context).size.width,
          margin:EdgeInsets.fromLTRB(0, 0, 0, 0),child:Text(totalComFrete(),textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'BreeSerif',fontSize: 25,color:Colors.deepOrange,letterSpacing: 0.4))),
      ])),


      Container(
          padding:EdgeInsets.all(10),
          margin:EdgeInsets.fromLTRB(0, 0, 0, 0),
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0)),
              boxShadow: [BoxShadow(color: Colors.grey[400],blurRadius: 1)],color:Colors.white),
          child:
          Column(
              children: <Widget>[
          Container(
                width: MediaQuery.of(context).size.width,
                margin:EdgeInsets.fromLTRB(0, 10, 0, 0), child:Text("Endereço para entrega",
              style: TextStyle( fontSize: 16,fontFamily: 'BreeSerif',letterSpacing: 0.4,color:Colors.grey),textAlign: TextAlign.center,)),
            Container(
                width: MediaQuery.of(context).size.width,
                margin:EdgeInsets.fromLTRB(10, 5, 10, 0),child:
            Text(end_user_.rua+", "+end_user.bairro,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18,fontFamily: 'BreeSerif',letterSpacing: 0.4))),
            Container(
                margin:EdgeInsets.fromLTRB(0, 0, 0, 15),
                width: MediaQuery.of(context).size.width,
                child:Text("Nº "+end_user_.numero+", "+end_user.complemento,
                    textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontFamily: 'BreeSerif'))),

              ])),
              Container(
                    padding:EdgeInsets.all(10),
                    margin:EdgeInsets.fromLTRB(0, 0, 0, 0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0)),
                        boxShadow: [BoxShadow(color: Colors.grey[400],blurRadius: 1)],color:Colors.white),
                    child:
                    Column(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              margin:EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child:Text("Forma de pagamento",
                                style: TextStyle( fontSize: 16,fontFamily: 'BreeSerif',letterSpacing: 0.4,color:Colors.grey),textAlign: TextAlign.center,)),
                              Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child:  formaPagResumo()),
                ])),

            Container(
                padding:EdgeInsets.all(10),
                margin:EdgeInsets.fromLTRB(0, 0, 0, 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomRight: Radius.circular(3),bottomLeft: Radius.circular(3)),
                    boxShadow: [BoxShadow(color: Colors.grey[400],blurRadius: 1)],color:Colors.white),
                child:
                Column(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          margin:EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child:Text("Lista",
                            style: TextStyle( fontSize: 16,fontFamily: 'BreeSerif',letterSpacing: 0.4,color:Colors.grey),textAlign: TextAlign.center,)),
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child:  listaCesta_),
                    ])),

            GestureDetector(
                onTap:(){
                  enviarPedido();
                  setState(() {
                    show_popprocessando=true;
                    pagSelectfinal=false;

                  });

                },
                child:
            Container(
                padding:EdgeInsets.all(10),
                margin:EdgeInsets.fromLTRB(0, 20, 0, 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)),
                    boxShadow: [BoxShadow(color: Colors.grey[400],blurRadius: 1)],color:Colors.white),
                child:
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      GestureDetector(
                          onTap:(){
                              if (tipoPag=="cartao") {
                                setState(() {
                                  view_cvv_pop = true;
                                });
                              }
                              else{
                              setState(() {show_popprocessando=true;
                              pagSelectfinal=false;
                              });
                              enviarPedido();
                              }

                          },
                          child:
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child:  Container(
                              child:Text( textbtnFinalPedido,
                                style: TextStyle(color:Colors.orange,
                                    fontFamily: 'BreeSerif',fontSize: 20),)))),
                    ]))),

  ]),





      ]),


  ))));
  }

  formaPagResumo(){
    if (cartaoselect!=-1){
      return  Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
          padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)],color:Colors.white),
          child:
            Row(mainAxisAlignment: MainAxisAlignment.center,mainAxisSize: MainAxisSize.max, children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child:
                  getBandeira(cardSelecionado['bandeira'])),
              Container(
                  margin: EdgeInsets.fromLTRB(10, 10,10, 10),
                  alignment: Alignment.center, child:
              Text("  **** "+cardSelecionado['maskNumb'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                TextStyle(color: Colors.black87,fontFamily: 'RobotoLight',fontSize: 20),)),
          ],));
      }else
        {
          if (tipoPag=="dinheiro"){
                return
                  Container(
                      margin: EdgeInsets.fromLTRB(0,15,0, 10),
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              child:
                              Row(mainAxisAlignment: MainAxisAlignment.center,mainAxisSize: MainAxisSize.max, children: <Widget>[
                                Row(mainAxisAlignment: MainAxisAlignment.center,mainAxisSize: MainAxisSize.max, children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Image.asset("money.png",width: 30,height: 30)),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(5, 0,0, 0),
                                      alignment: Alignment.center, child:
                                  Text("Dinheiro",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                    TextStyle(fontSize: 18,color: Colors.black87,fontFamily: 'BreeSerif'),)),
                                ],),

                              ],)),


                        ],));
          }else
            {
             return
               Container(
                   margin: EdgeInsets.fromLTRB(0,5,0, 10),
                   child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child:
                        Row(mainAxisAlignment: MainAxisAlignment.center,mainAxisSize: MainAxisSize.max, children: <Widget>[
                          Row(mainAxisAlignment: MainAxisAlignment.center,mainAxisSize: MainAxisSize.max, children: <Widget>[
                            Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Image.asset("card_machine.png",width: 30,height: 30)),
                            Container(
                                margin: EdgeInsets.fromLTRB(5, 10,0, 10),
                                alignment: Alignment.center, child:
                            Text("Máquina de cartão",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                              TextStyle(fontSize: 18,color: Colors.black,fontFamily: 'BreeSerif'),)),
                          ],),

                        ],)),


              ],));
            }
        }
  }

  view_cards(){
   return Container(
        child:
        StreamBuilder(
            stream: Firestore.instance.collection('Usuarios').document(widget.user.uid)
                .collection("cartoes").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState== ConnectionState.active){
                return  itemCarduser(snapshot, (value,cartao,idcartao){selectitem(value,cartao,idcartao);},"compra");
              } else
                return Container(height: 50,);

            })
    );
  }

  selectitem(var resp,var cartao,var idcartao){
    setState((){
      iconCheckPagamento_dinheiro=Icons.radio_button_unchecked;
      iconCheckPagamento_maquina=Icons.radio_button_unchecked;
      pagSelect=true;
      pagSelectfinal=true;
      tipoPag="cartao";
      cartaoselect=resp;
      cardSelecionado=cartao;
      idcardselecionado=idcartao;

    });
  }


  itemListCards(var data, var index){

    var icon = Icons.radio_button_unchecked;
    if (cartaoselect==index)
        icon=Icons.radio_button_checked;
    return
      GestureDetector(
          onTap:  (){
            setState(() {
              print("click cartao");
              cartaoselect=index;
            });
          },
            child:
          Column(children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)],color:Colors.white),
                    child:
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max, children: <Widget>[
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max, children: <Widget>[
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child:
                            getBandeira(cardSelecionado['bandeira'])),
                        Container(
                            margin: EdgeInsets.fromLTRB(25, 10,0, 10),
                            alignment: Alignment.center, child:
                        Text(data['bandeira']+"  **** "+data['maskNumb'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                          TextStyle(color: Colors.black87,fontFamily: 'RobotoLight'),)),
                      ],),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child:Icon(icon,color: Colors.orange,),),
                    ],)),

              ],),

          ],));
  }

  @override
  void initState() {
    getLoja();

    layout_maquina=formaPagMaquina();
    layout_dinheiro=pagamentoDinheiro();
    layout_cartao=pagamentoDinheiro();
    view_cards_= view_cards();
    viewcomprapagamento_=Container();
    blur_bg=blug_bg_();
    getUseruid();
    bloc.getEnderecoUser();
    enderecoView = enderecoView_();
    listaCesta_=listaCesta();
    if (widget.listaCesta.length==0)
      widget.call_back_show_bg(false);
    _checkreresult();

    super.initState();
  }


  blug_bg_(){
   return Container(
        child: ClipRect(
          child:  BackdropFilter(
            filter:  ImageFilter.blur(sigmaX:1, sigmaY:1),
            child:  Container(
              width: double.infinity,
              height: 600,
              decoration:  BoxDecoration(color: Colors.transparent),
              child:  Container(
              ),
            ),
          ),
        ));
  }


  enderecoView_(){
    return StreamBuilder(
        stream: Firestore.instance.collection('Usuarios').document(widget.user.uid)
            .collection("endereco").where("temp",isEqualTo: false).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState==ConnectionState.active){

          if (snapshot.data.documents.length > 0) {
                  enderecoTemp_=false;
                return
                  enderecoUserView(snapshot.data.documents[0]);
            }
            else{

              return
                StreamBuilder(
                    stream: Firestore.instance.collection('Usuarios').document(widget.user.uid)
                        .collection("endereco").where("temp",isEqualTo: true).snapshots(),
                    builder: (context, snapshot1) {
                      if (snapshot1.connectionState==ConnectionState.active){
                        if (snapshot1.data.documents.length > 0) {
                          enderecoTemp_=true;
                          return
                            enderecoTemp(snapshot1.data.documents[0]);
                        }else
                          return Container();
                      }else
                        return Container();
                    });
            }
          }else
            return Container();
        });
  }


  void getDadosUser(var uid) async {

    var user = await FirebaseAuth.instance.currentUser();

    var document = await Firestore.instance.collection('Usuarios').document(widget.user.uid);
    document.snapshots()
        .listen((data) => {
      getUser(data,data.documentID)
    });

  }


  void getUser(var data,var documentID){
    setState(() {
    user = new User(data['nome'],data['tell'],data['email'],data['uid'],data['localizacao']);
      view=true;
      print("USER X "+data['uid'].toString());
    });
  }



  getUseruid() async {
    var userx = await FirebaseAuth.instance.currentUser();
    getDadosUser(userx.uid);
  }


  enderecoUserView(var data){
    end_user = new enderecoUserSnapShot(data);
    end_user_ =  new enderecoUser(data['rua'],data['bairro'],data['numero'],data['complemento'],data['localizacao'],data['temp']);
    print("ENDERECO COMP "+end_user_.localizacao.latitude.toString());
    return
      Container(
          margin: EdgeInsets.fromLTRB(15, 10, 15, 20),
          decoration:
          BoxDecoration(borderRadius:BorderRadius.only( topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20),)
              ,boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)],color:cor_endereco),
          child:
//    BorderRadius.all(Radius.circular(20))
          Column(

            children: <Widget>[


              Row(mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max, children: <Widget>[

//                             Container(
//                               margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
//                               child:
//                               Icon(Icons.location_searching,size: 20,),),

                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[

                      Container(
                          width: MediaQuery.of(context).size.width*.54,
                          margin: EdgeInsets.fromLTRB(20, 25,0, 0),
                          alignment: Alignment.centerLeft, child:
                      Text(data['rua']+", "+data['bairro'], maxLines: 4,
                        overflow: TextOverflow.ellipsis,style:
                        TextStyle(color: Colors.black87,fontFamily: 'RobotoLight'),)),

                      Container(
                          width: MediaQuery.of(context).size.width*.54,
                          margin: EdgeInsets.fromLTRB(20, 0,0, 5),
                          alignment: Alignment.centerLeft, child:
                      Text("Nº "+data['numero']+", "+data['complemento'], maxLines: 6,
                        overflow: TextOverflow.ellipsis,style:
                        TextStyle(color: Colors.black45,fontFamily: 'RobotoLight'),)),

                    ],),
//
//                  Container(
//                      decoration:
//                      BoxDecoration(borderRadius:BorderRadius.only(topRight: Radius.circular(20))),
//                      height: 130,
//                      width:105,
//                      alignment: Alignment.center, child:
//                  GoogleMap(
//                    onMapCreated:  _onMapCreated,
//                    zoomControlsEnabled: false,
//                    buildingsEnabled: true,
//                    rotateGesturesEnabled: false,
//                    zoomGesturesEnabled: false,
//                    scrollGesturesEnabled: false,
//                    mapType: MapType.normal,
//
//                    initialCameraPosition:  CameraPosition(
//                        target:getLocal(data),
//                        zoom: 16.0
//                    ),
//                  )),
                  Container(
                      height: 130,
                      width:MediaQuery.of(context).size.width*.29,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0), alignment: Alignment.centerLeft,
                      child:
                      Stack(children: <Widget>[
                      GoogleMap(
                            onMapCreated:  _onMapCreated,
                            zoomControlsEnabled: false,
                            buildingsEnabled: true,
                            rotateGesturesEnabled: false,
                            zoomGesturesEnabled: false,
                            scrollGesturesEnabled: false,
                            mapType: MapType.normal,
                            initialCameraPosition:  CameraPosition(
                                target:getLocal(data),
                                zoom: 17.0
                            )),
                        Visibility(visible: true, child:
                        Container(
                            height: 150,
                            alignment: Alignment.center,
                            child:Icon(Icons.radio_button_checked,color: Colors.red,size: 25,))),
                      ],)),

                ],),
              Divider(color:Colors.red,height: 1,),
              Visibility(visible:true,child:
              GestureDetector(onTap: (){
                setState(() {
                  view_form_end=true;
                  ctrol_view_btnEnd=true;
//                view_resumo_cesta=false;
                  confirmarEndereco=false;
                  view_formpag=false;
                }); },child:
              Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  alignment: Alignment.center, child:
              Text("Atualizar",style:
              TextStyle(color: Colors.red,fontFamily: 'RobotoBold'),)))),

              Visibility(
                  visible:!confirmarEndereco,
                  child:
              Container(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 20),
                  margin: EdgeInsets.fromLTRB(15, 20, 15, 20),
                  decoration: BoxDecoration(
                      borderRadius:BorderRadius.all(Radius.circular(20)),
                      boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)],color:Colors.white),
                  child:
                  Row(mainAxisAlignment: MainAxisAlignment.center,mainAxisSize: MainAxisSize.max, children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        GestureDetector(onTap: (){
                          setState(() {
                            confirmarEndereco=true;
                            view_formpag=true;
                            ctrol_view_btnEnd=false;
                            enderecoView = enderecoView_();
                          }); },child:
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 5,0, 0),
                            alignment: Alignment.center, child:
                        Text("CONFIRMAR ENDEREÇO",style:
                        TextStyle(color: Colors.orange,fontFamily: 'RobotoBold',
                            fontSize: 16),))),
                      ],),
                  ],))),



            ],));
  }
  getLocal(var data){
    var   _center ;

    if (data!=null) {
      print(data['localizacao']);
      print(data['localizacao'].longitude);


      _center = new LatLng(data['localizacao'].latitude,
          data['localizacao'].longitude);
      if (mapController != null)
        mapController.moveCamera(CameraUpdate.newLatLngZoom(_center, 15));
    }
    return _center;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  enderecoTemp(var data)
  {
    end_user = new enderecoUserSnapShot(data);
    end_user_ =  new enderecoUser(data['rua'],data['bairro'],data['numero'],data['complemento'],data['localizacao'],data['temp']);
    print("ENDERECO COMP "+end_user_.complemento);
    return
      Column(children: <Widget>[
        Container(
            margin: EdgeInsets.fromLTRB(15, 10,0, 0),
            alignment: Alignment.centerLeft, child:
        Text("Endereço automatico",style:
        TextStyle(color: Colors.grey,fontFamily: 'RobotoLight'),)),

        Column(

          children: <Widget>[

            Container(
                margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)],color:Colors.white),
                child:


                Row(mainAxisAlignment: MainAxisAlignment.start,mainAxisSize: MainAxisSize.max, children: <Widget>[

                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child:
                    Icon(Icons.location_searching,size: 20,),),

                  Column(

                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width*0.7,
                          margin: EdgeInsets.fromLTRB(20, 10,0, 10),
                          alignment: Alignment.centerLeft, child:
                      Text(data['rua']+", "+data['bairro'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                        TextStyle(color: Colors.black87,fontFamily: 'RobotoLight'),)),
                    ],),

                ],)),
            Container(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 20),
                margin: EdgeInsets.fromLTRB(15, 20, 15, 20),
                decoration: BoxDecoration(
                    borderRadius:BorderRadius.all(Radius.circular(20)),
                    boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)],color:Colors.white),
                child:
                Row(mainAxisAlignment: MainAxisAlignment.center,mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      GestureDetector(onTap: (){
                        setState(() {
                        view_form_end=true;
                      }); },child:
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 5,0, 0),
                          alignment: Alignment.center, child:
                      Text("COMPLETAR ENDEREÇO",style:
                      TextStyle(color: Colors.orange,fontFamily: 'RobotoLight'),))),
                    ],),
                ],)),
          ],),

      ],);
  }



  formaPagMaquina()
  {
    return
      GestureDetector(
          onTap: (){
            setState(() {
              iconCheckPagamento_maquina=Icons.radio_button_checked;
              iconCheckPagamento_dinheiro=Icons.radio_button_unchecked;
              if (cartaoselect!=-1)
                view_cards_= view_cards();
              cartaoselect=-1;
              tipoPag="maquina";
              view_formpag=false;
              pagSelect=true;
              pagSelectfinal=true;
            });},
          child:
          Column(children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)],color:Colors.white),
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max, children: <Widget>[
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max, children: <Widget>[
                        Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Image.asset("card_machine.png",width: 40,height: 40)),
                        Container(
                            margin: EdgeInsets.fromLTRB(25, 10,0, 10),
                            alignment: Alignment.center, child:
                        Text("Máquina de cartão",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                          TextStyle(color: Colors.black,fontFamily: 'RobotoLight',fontSize: 18),)),
                      ],),
//                      Container(
//                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
//                        child:Icon(iconCheckPagamento_maquina,color: Colors.orange,),),
                    ],),

                 Container(
                          margin:EdgeInsets.fromLTRB(0, 0, 0, 0),
                          padding:EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Visibility(
                            visible: view_cred_maq,
                            child:
                          Container(
                              margin:EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child:Text("Crédito",style: TextStyle(color:Colors.grey),))),

                         Visibility(
                             visible: view_deb_maq,
                             child:Container(
                              margin:EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child:Text("Débido",style: TextStyle(color:Colors.grey)))),
                      ]))
                   ],),
         )]),);

  }


  pagamentoDinheiro()
  {
    return
      GestureDetector(
          onTap: (){setState(() {

            if (!view_troco)
            view_troco=true;
            else
              view_troco=false;

          });},
          child:
          Column(children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)],color:Colors.white),
                child:

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max, children: <Widget>[
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max, children: <Widget>[

                        Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Image.asset("money.png",width: 50,height: 50)),
                        Container(
                            margin: EdgeInsets.fromLTRB(25, 10,0, 10),
                            alignment: Alignment.center, child:
                        Text("Dinheiro",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                          TextStyle(color: Colors.black87,fontFamily: 'RobotoLight',fontSize: 20),)),

                      ],),
//                      Container(
//                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
//                        child:Icon(iconCheckPagamento_dinheiro,color: Colors.orange,),),
                    ],),

                    Visibility(
                        visible: view_troco,
                        child:
                    Row(
                      children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(30, 0, 0, 0) ,
                          child:Text("Troco para R\u0024 ",
                            style: TextStyle(fontSize: 20,fontFamily: 'BreeSerif'),
                          )),
                      Container(
                        width: 100,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(0, 22, 0, 0) ,
                        child:
                        TextFormField(
                          textAlign: TextAlign.left,
                          controller: controller_mask_troco  , maxLength: 6,
                          style: TextStyle(fontSize: 25,fontFamily: 'BreeSerif'),
                          onChanged: (text){
                            if (text.length<=3)
                              controller_mask_troco.updateMask("0,00");
                            if (text.length<=4)
                              controller_mask_troco.updateMask("0,00");
                            if (text.length>4)
                              controller_mask_troco.updateMask("00,00");
                            if (text.length>5)
                              controller_mask_troco.updateMask("000,00");
                            if (text.length>=6)
                              controller_mask_troco.updateMask("000,00");
                          },
                          decoration: InputDecoration.collapsed(
                              hintStyle: TextStyle(color: Colors.black),

                              hintText: '0,00'
                          ),
                          keyboardType:  TextInputType.number,
                        )),
                      GestureDetector(
                        onTap: (){setState(() {
                          if (controller_mask_troco.text.length>0){
                          var t =controller_mask_troco.text.replaceAll(",", ".");
                          troco = double.parse(controller_mask_troco.text.replaceAll(",", ".")) ;
                          }
                          iconCheckPagamento_dinheiro=Icons.radio_button_checked;
                          iconCheckPagamento_maquina=Icons.radio_button_unchecked;
                          if (cartaoselect!=-1)
                            view_cards_= view_cards();
                          cartaoselect=-1;
                          tipoPag="dinheiro";
                          pagSelect=true;
                          pagSelectfinal=true;
                          view_troco=true;
                        });},
                        child:
                          Container(
                            width: 50,
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),
                                boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)],color:Colors.white),
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10) ,
                            child:Text("OK",textAlign: TextAlign.center,style: TextStyle(color:Colors.orange,fontSize: 18),))),
                    ],)),


              ],)),

          ],));
  }

  _snackbar(text){
    final snackBar = SnackBar(content: Text(text));
    Scaffold.of(context).showSnackBar(snackBar);

  }

  pagamentoCartaoVazio()
  {
    return
      GestureDetector(onTap:(){setState(() {
        view_card_form=true;
      });} ,child:
      Column(children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 30),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)],color:Colors.white),
                child:
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max, children: <Widget>[
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child:
                        Image.asset("cardcredit.png",width: 40,height: 60,)),

                    Container(
                        margin: EdgeInsets.fromLTRB(25, 10,0, 10),
                        alignment: Alignment.center, child:
                    Text("Novo cartão de crédito",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                      TextStyle(color: Colors.black,fontFamily: 'RobotoLight',fontSize: 14),)),
                  ],),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child:Icon(Icons.playlist_add,color: Colors.grey,),),
                ],)),

          ],),

      ],));
  }



  formularioCartao(){

    return
      Container( width: double.infinity,height: MediaQuery.of(context).size.height,
          child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0,0.2),   child:
          ClipRect(
              child:  BackdropFilter(
                  filter:  ImageFilter.blur(sigmaX:1, sigmaY:1),
                  child:  Container(
                    decoration:  BoxDecoration(color: Colors.grey[200].withOpacity(.60)),
                    child:
                    Container(
                        padding: EdgeInsets.fromLTRB(30, 0, 30,0),
                        child:Column(mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            cartao_form(widget.user.uid,(){hide_pop_cardform();})
                          ],)
                    ),
                  )))));
  }


  hide_pop_cardform()
  {
    setState(() {
      view_card_form=false;
    });
  }

  formularioEndereco(){

    return
      Container( width: double.infinity,height: MediaQuery.of(context).size.height,
          child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0,0.2),   child:
          ClipRect(
              child:  BackdropFilter(
                  filter:  ImageFilter.blur(sigmaX:2, sigmaY:2),
                  child:  Container(
                    decoration:  BoxDecoration(color: Colors.white.withOpacity(.20)),
                    child:
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 30, 20,0),
                        child:Column(mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            form_endereco_user(end_user_,null,widget.listaCesta[0].localizacao ,null,(){desativarFormEndereco();})
                          ],)
                    ),


                  )))));
  }


  desativarFormEndereco(){
    setState(() {
      print("desativaformend");

      view_form_end=false;
      bloc.resetListProduto();

    });
  }


  formatDistancia(){

    var unidadeMedida="";
    double valeu = double.parse(widget.listaDistancia_.distancia);
    if (valeu<1000)
      unidadeMedida="m";
    else {
      valeu=valeu/1000;
      unidadeMedida = "km";
    }
    var distTxt="";
    return  distTxt= valeu.toStringAsFixed(1)+""+unidadeMedida;

  }


  barra(){
    return  Container(decoration: BoxDecoration(color: Colors.transparent,boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 2.0,
        offset: Offset(
          0.0, // horizontal, move right 10
          -2.0, // vertical, move down 10
        ),
      )
    ],),height: 45,child:

    barraView()

      ,);
  }


  barraView(){
    return
      GestureDetector(onTap: () {
        setState(() {
          if(widget.view_barra_ctrol==false)
            widget.show_btn_float_(false);

          if (view_resumo_cesta == false) {
            widget.call_back_show_bg(true);
            view_resumo_cesta=true;
            view_formpag=false;
            view_resumo_compra=false;
            tipoPag="";
            confirmarEndereco=false;
          }
          else{
            view_cestadetalhes=false;
            confirmarEndereco=false;
            widget.call_back_show_bg(false);
            view_resumo_cesta=false;
          }
        });
      }, child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0,0),
        child:
      ClipRect(
        child:  BackdropFilter(
          filter:  ImageFilter.blur(sigmaX:3, sigmaY:3),
          child:  Container(
            width: double.infinity,
            height:  double.infinity,
            decoration:  BoxDecoration(color: Colors.orange[400].withOpacity(.7)),
            child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[


              Container(margin: EdgeInsets.fromLTRB(10, 0, 0, 0), child:
              Text("R\u0024 " + totaltxt.toString(), style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'RobotoBold',
                  fontWeight: FontWeight.bold,
                  fontSize: 14),)),

              Container(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                  child: Image.asset("basket_.png",width:25,height:25,)),
//        Icon(Icons.shopping_basket, color: Colors.white)),
              Container(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.fromLTRB(5, 5, 15, 5),
                  child:
                  Text(qntdItenstxt, style: TextStyle(color: Colors.white,
                      fontFamily: 'RobotoBold',
                      fontWeight: FontWeight.bold,
                      fontSize: 16),)),
            ],),
//           Container(margin: EdgeInsets.fromLTRB(0,10.5, 0, 0),
//                  child:
//                 Divider(color:Colors.white,height: 0,thickness: 2,)),

          ),
        ))),
      );
  }


  formatFrete(){

    var coef = widget.listaCesta[0].coefKm;
    var distKm=0.0;

    for(int i = 0; i < widget.listaCesta.length;i++) {
//      if (widget.listaCesta[i].loja == widget.listaDistancia_.loja) {}
//      }
      if (widget.listaDistancia_ != null) {
        distKm = double.parse(widget.listaDistancia_.distancia) / 1000;

        if (widget.listaCesta[0].distanciaGratisKm >= distKm) {
          return "Entrega gratis";
        } else {
          if (distKm != 0.0) {
            var frete = (coef * distKm);
            var fretef = frete.toStringAsFixed(2).toString();
            return "R\u0024 " + fretef;
          } else
            return "";
        }
      }else
        return "";
    }
  }


  totalComFrete(){

    var coef = widget.listaCesta[0].coefKm;
    var distKm=0.0;

    for (int i = 0; i < widget.listaCesta.length;i++) {
      if (widget.listaDistancia_ != null) {
        if (widget.listaCesta[i].idloja == widget.listaDistancia_.idloja) {
            distKm = double.parse(widget.listaDistancia_.distancia) / 1000;
            if (widget.listaCesta[0].distanciaGratisKm >= distKm) {
              return "R\$ " + total.toStringAsFixed(2).replaceAll(".", ",");
            }
            else {
            if (distKm != null) {
              var frete_ = (coef * distKm);
              var fretef = (total + frete_).toStringAsFixed(2).replaceAll(".", ",");
              frete = frete_;
              return fretef;
            } else
              return "...";
          }
        } else
          return "...";
      }else
        return "...";
    }
  }


  listaCesta()  {
    return
      Container(
          height: 140,
          child:
          StreamBuilder(
              stream: Firestore.instance
                  .collection("Usuarios").document(widget.user.uid).collection("cesta")
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
                    listaProdutos = (snapshot.data.documents);
                    return new ListView.builder(
                        padding: EdgeInsets.all(0.0),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          print("ITEM CESTA LISTA"+index .toString());

                          return item_cesta(snapshot.data.documents[index],null,(value){return selectItemCestaList(value);});
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
          ));
  }


  listaCards()  {

    return
      Container(
          height: 125,
          child:
          StreamBuilder(
              stream: Firestore.instance
                  .collection("Usuarios").document(widget.user.uid).collection("cartoes")
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
                        padding: EdgeInsets.all(0.0),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          print("ITEM CESTA LISTA"+index .toString());
                          return item_cesta(snapshot.data.documents[index],null,(value){return selectItemCestaList(value);});
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
          ));
  }



  selectItemCestaList(var prod){
    ctrolControls=true;
    setState(() {
      if (prod==null)
        ctrolControls=false;
      else
        ctrolControls=true;
    });

    selecionado=prod;
  }


  getPrecoFormat(preco,quantidade){
    print("precooo x "+preco.toString());
    double p = (quantidade*preco)*1.0;

    print("precooo x1 "+p.toString());

    preco = p.toStringAsFixed(2).toString();
    preco=preco.replaceAll(".", ",");

    return preco;
  }


  _checkreresult() {
    total=0.0;
    qntdItens=0.0;
    var valfinal=0.0;
    if (widget.listaCesta.length==0)
      widget.call_back_show_bg(false);
    for (int i = 0; i <  widget.listaCesta.length; i++) {

      Produto_cesta produto = widget.listaCesta[i];
      var preco = produto.preco;

      var quantidade = produto.quantidade;
      var t = (preco * quantidade);

      total += t;
      qntdItens += quantidade;
      qntdItenstxt = qntdItens.toStringAsFixed(0).toString() + " itens";

      valfinal = total ;


    }
    setState(() {
      totaltxt = valfinal.toStringAsFixed(2).toString().replaceAll(".",",");
    });
  }


  enviarPedido() async {


    Pedido pedido_= new Pedido();
    enderecoUser endereco = end_user_;
    var idloja;
    var formaPagamaneto = tipoPag;
    List<Map> lista_produtos_ = new List<Map>();
    for (int i=0; i < listaProdutos.length;i++){
      Produto_cesta p = new Produto_cesta(listaProdutos[i]);
      lista_produtos_.add(p.getproduto());
      idloja=p.idloja;
    }
    var time=FieldValue.serverTimestamp();
    var nomeUser=widget.user.nome ;
    var tellUser = widget.user.tell;
    //aguardando//recusado//confirmado//fazendo sua cesta//entrega//finalizado//cancelado
    var status = "prepedido";
    pedido_.total=total;
    pedido_.frete=frete;
    pedido_.enderecoEntrega = endereco.getenderecoUser();
    pedido_.tipoPagamento=formaPagamaneto;
    pedido_.troco=troco;
    pedido_.lista_produtos=lista_produtos_;
    pedido_.nomeUser=nomeUser;
    pedido_.tellUser=tellUser;
    pedido_.status=status;
    pedido_.time=time;
    pedido_.idloja=idloja;
    pedido_.emailUser=widget.user.email;
    pedido_.statusPagamento=false;
    pedido_.distancia = widget.listaDistancia_.distancia;
    pedido_.previsao = widget.listaDistancia_.duracao;
    Random random = new Random();
    int randomNumber = random.nextInt(1000000) + 10000;
    pedido_.idPedido=idloja+""+ randomNumber.toString();
    pedido_.timeAguardando=FieldValue.serverTimestamp();


    if (tipoPag=="cartao"){
        var resultEnvioPedido = await bloc.savePrePedido(widget.user.uid,pedido_,widget.user.nome,idcardselecionado,idloja);
        if (resultEnvioPedido){
            pedido_.statusPagamento=true;
            var resultEnvioPedidofinal = await bloc.savePedidoFinal(widget.user.uid,pedido_);
            if (resultEnvioPedidofinal){
              print("sucesso pedido pago");
              //hide barCesta; show  barPedido
            }else
            {
              pagSelectfinal=true;
            }

        }else
          {
            setState((){
              show_popprocessando_erro=true;
              show_popprocessando=false;
              view_cvv_pop=false;
            });
          }
    }else
      {
        widget.call_back_show_bg(false);

        var resultEnvioPedidofinal = await bloc.savePedidoFinal(widget.user.uid,pedido_);
        if (resultEnvioPedidofinal){
           //hide barCesta; show  barPedido
        }else
          {
            pagSelectfinal=true;
          }
      }

  }



}

