import 'package:button3d/button3d.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore/Bloc_finaceiro.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'ClickyButton.dart';

typedef hide_pop =  Function();


class cartao_form extends StatefulWidget {


  hide_pop hide_pop_callback;
  cartao_form (this.hide_pop_callback);


  @override
  cartao_formState createState() => cartao_formState();

}

class cartao_formState extends State<cartao_form>  with TickerProviderStateMixin {

  final myController_nome = TextEditingController();
  var controller_mask_card = new MaskedTextController(mask: '0000 0000 0000 0000', text: '');
  var controller_mask_card_data = new MaskedTextController(mask: '00/00', text: '');
  AnimationController _controller;
  AnimationController _controller_rotate;
  Animation<double> _animation;
  Animation<double> _animation_rotate;
  Bloc_financeiro bloc_finance = new Bloc_financeiro();


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController_nome.dispose();
    controller_mask_card.dispose();
    controller_mask_card_data.dispose();
    _controller_rotate.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  initState() {


    setState(() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this, value: 0.1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticInOut);
//    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);

      _controller_rotate = AnimationController(
          duration: const Duration(milliseconds: 1500), vsync: this, value: 0.1);
      _animation_rotate = CurvedAnimation(parent: _controller_rotate, curve: Curves.ease);
//    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);


      _controller.forward();

    });

    super.initState();

  }

  @override
  Widget build(BuildContext context) {

  return
  Stack(children: <Widget>[
    Positioned(top: 0,bottom: 0,left: 0,right: 0, child:
    Container( alignment: Alignment.center, child:Image.asset('gif_load.gif',width: 50,height: 50,))),
      ScaleTransition(
        scale: _animation,
    child:
    Container(
       child:
      Column(children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, 60,0, 0),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 3)] , color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(8))),
          child:
         Column(children: <Widget>[
           Container(
             height: 30,
             child: Text("ADICIONAR CARTÃO DE CRÉDITO",textAlign: TextAlign.center,) ),
           Container(
                height: 30,
                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child:
                TextFormField(controller: controller_mask_card  , maxLength: 19,
                  style: TextStyle(fontSize: 16,color: Colors.amber,fontFamily: 'NomeCredito'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration.collapsed(
                    hintStyle: TextStyle(color: Colors.grey),
                  hintText: '0000 0000 0000 0000'
                   ),
                keyboardType:  TextInputType.number,),),

           Container(
             height: 30,
             child: TextFormField(controller: myController_nome, style: TextStyle(fontSize: 19,color: Colors.amber,fontFamily: 'credtfontbold'),
               textInputAction: TextInputAction.next,
               onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
               decoration: InputDecoration.collapsed(
                   hintStyle: TextStyle(color: Colors.grey),
                   hintText:'NOME NO CARTÃO'),
             keyboardType: TextInputType.text,),),

           Container(
             height: 30,
             margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
             child: TextFormField(controller: controller_mask_card_data, style: TextStyle(fontSize: 19,color: Colors.amber,fontFamily: 'credtfontbold'),
               textInputAction: TextInputAction.next,
               onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
               decoration: InputDecoration.collapsed(
                   hintStyle: TextStyle(color: Colors.grey),
                   hintText: '00/00'
             ),
             keyboardType:  TextInputType.number,),),
         ],)),

       Container(
            margin: EdgeInsets.fromLTRB(0,30,0,0),
            child:
            Transform.scale(
                scale: 0.7,
                child:
                ClickyButton(
                  child: Text(
                    'SALVAR',
                    style: TextStyle(
                        fontFamily:'BreeSerif',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 3,
                        fontSize: 25),
                  ),
                  color: Colors.amber,
                  onPressed: () { checkCardDados();},
                ))
//          Button3d(
//            height: 50,
//            style: Button3dStyle.WHITE, // Button3dStyle.RED, Button3dStyle.WHITE
//            onPressed: () {},
//            child: Text("SALVAR"),
//          )
        ),
        Container(
            margin: EdgeInsets.fromLTRB(0,0,0,0),
            child:
            Transform.scale(
                scale: 0.7,
                child:
                ClickyButton(

                  child: Text(
                    'VOLTAR',
                    style: TextStyle(
                      fontFamily:'BreeSerif',
                        color: Colors.white,
                        letterSpacing: 3,
                        fontSize: 25),
                  ),
                  color: Colors.grey,
                  onPressed: () {widget.hide_pop_callback();},
                ))
//          Button3d(
//            height: 50,
//            style: Button3dStyle.WHITE, // Button3dStyle.RED, Button3dStyle.WHITE
//            onPressed: () {},
//            child: Text("SALVAR"),
//          )
        ),
       ],)
     ))],);
  }


  formatNumero(String numero){

    var n="";

    for (int i = 0; i <numero.length;i++){

        n += numero[i];

        if (i==3 ){
            n+=" ";
        }

//        if (i==7){
//          n+=" ";
//        }
//
//        if (i==12){
//          n+=" ";
//        }

    }

//    myController_nome.text=n;
  }

  _snackbar(text){
    final snackBar = SnackBar(content: Text(text));
    Scaffold.of(context).showSnackBar(snackBar);

  }


  checkCardDados() {
    var numero = controller_mask_card.text;
    String nome = myController_nome.text;
    var data = controller_mask_card_data.text;

    if (numero.length < 19)
      _snackbar("número incompleto");
    else if (nome
        .toString()
        .split(" ")
        .length < 2)
      _snackbar("nome incompleto");
    else if (data.length < 5)
      _snackbar("data incompleta");
    else {
      setState(() {
        _controller.reverse();
        sendCartaoTokenrize();
      });
    }
  }

  sendCartaoTokenrize(){
    bloc_finance.callTokenrizarCartao();
  }



}