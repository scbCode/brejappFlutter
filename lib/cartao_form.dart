import 'package:button3d/button3d.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore/Bloc_finaceiro.dart';
import 'package:flutter_firestore/animator.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:http/http.dart' as http;
import 'ClickyButton.dart';

typedef hide_pop =  Function();


class cartao_form extends StatefulWidget {


  hide_pop hide_pop_callback;
  var uid;
  cartao_form (this.uid,this.hide_pop_callback);


  @override
  cartao_formState createState() => cartao_formState();

}

class cartao_formState extends State<cartao_form>  with TickerProviderStateMixin {

  final myController_nome = TextEditingController();
  var controller_mask_card = new MaskedTextController(mask: '0000 0000 0000 0000', text: '');
  var controller_mask_card_data = new MaskedTextController(mask: '00/00', text: '');
  AnimationController _controller;
  AnimationController _controller_circ;
  AnimationController _controller_rotate;
  Animation<double> _animation;
  Animation<double> _animation_circ;
  Animation<double> _animation_rotate;
  var numcard="";
  Bloc_financeiro bloc_finance = new Bloc_financeiro();
  var opcstart = true;
  var bcoltr=false;
  var view_pop_=false;
  var icon_card;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController_nome.dispose();
    controller_mask_card.dispose();
    controller_mask_card_data.dispose();
    _controller_rotate.dispose();
    _controller.dispose();
    _controller_circ.dispose();
    super.dispose();
  }

  @override
  initState() {

    icon_card = Image.asset('visa.png',width:0,height:0);

    setState(() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this, value: 0.1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticInOut);
//    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);

      _controller_rotate = AnimationController(
          duration: const Duration(milliseconds: 1500), vsync: this, value: 0.1);
      _animation_rotate = CurvedAnimation(parent: _controller_rotate, curve: Curves.ease);
//    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);

      _controller_circ = AnimationController(
          duration: const Duration(milliseconds: 500), vsync: this, value: 1);
      _animation_circ = CurvedAnimation(parent: _controller_circ, curve: Curves.elasticInOut);
//    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);
      _controller.forward();
    });

    super.initState();

  }

  @override
  Widget build(BuildContext context) {

//    _controller_circ.repeat();
//    _controller_circ.forward();
//    _controller.repeat();
//    _controller.forward();



    return
  Stack(children: <Widget>[

//    Positioned(top: 0,bottom: 0,left: 0,right: 0, child:
//    Container( alignment: Alignment.center, child:Image.asset('gif_load.gif',width: 50,height: 50,))),

    //layout result token
    Visibility( visible: view_pop_,child:
    ScaleTransition(
      scale: _animation,
      child:
        Container(
        child:
          Column(children: <Widget>[
            Container(
                width: 250,
                height: 250,
                margin: EdgeInsets.fromLTRB(0, 60,0, 0),
            padding: EdgeInsets.all(20),
            decoration:
            BoxDecoration(boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 25)] ,
                color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(500))),
            child:
                   Column(children: <Widget>[
                     Container(
                         margin: EdgeInsets.fromLTRB(0, 20,0, 0),
                         height: 30,
                         child: Text("Cartão salvo!",textAlign: TextAlign.center,style: TextStyle(fontFamily: 'RobotoBold',fontSize: 16,color: Colors.orange),) ),

//                     Divider(color: Colors.orange,),
//                     Container(
//                         child: Text(numcard,textAlign: TextAlign.center,style: TextStyle(fontFamily: 'RobotoRegular',color: Colors.black54),) ),

                     Container(
                       margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                       child:
                     Align(alignment: Alignment.bottomCenter ,child:
                     ScaleTransition(
                         scale: _animation_circ,
                             child:Icon(Icons.check_circle,color: Colors.green[500],size: 100,)
                         ))),

                     GestureDetector(onTap:(){widget.hide_pop_callback();},
                     child:
                     Container(
                         decoration: BoxDecoration(
                             boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)],
                             color:Colors.orange,borderRadius: BorderRadius.all(Radius.circular(20))),
                         padding: EdgeInsets.fromLTRB(25, 10,25, 10),
                         margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                         child:
                         Text("OK",style: TextStyle(color: Colors.white,fontFamily: 'RobotoLight'),)
                     )),
                   ])
          )])))),

    //layout formulario cartao
    Visibility( visible: !view_pop_,child:
    ScaleTransition(
        scale: _animation,
    child:
    Container(
       child:
      Column(children: <Widget>[

      Container(
      margin: EdgeInsets.fromLTRB(0, 60,0, 0),
        padding: EdgeInsets.fromLTRB(20,20,20,10),
        decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 3)] , color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(8))),
        child:
        Column(children: <Widget>[
          Container(
              height: 30,
              child: Text("CARTÃO DE CRÉDITO",textAlign: TextAlign.center,style: TextStyle(fontFamily: 'RobotoLight'),) ),
      ])),

          Container(
          margin: EdgeInsets.fromLTRB(0, 60,0, 0),
          padding: EdgeInsets.fromLTRB(20,20,20,10),
          decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 3)] , color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(8))),
          child:
         Column(children: <Widget>[
           Container(
             height: 30,
             child: Text("CARTÃO DE CRÉDITO",textAlign: TextAlign.center,style: TextStyle(fontFamily: 'RobotoLight'),) ),
           Container(
                height: 30,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child:
                TextFormField(controller: controller_mask_card  , maxLength: 19,
                  onChanged:(text){
                    if (text.length<=1)
                      setState(() {
                      print("CHANGE NUMB "+text);
                      if (text.length==1){
                      if (text[0]=='4')icon_card=Image.asset('visa.png',width: 40,height: 40,);
                      if (text[0]=='5')icon_card=Image.asset('master.png',width: 40,height: 40);}
                      if (text.length==0)
                        icon_card=Image.asset('visa.png',width: 0,height: 0);
                    });
                  },
                  style: TextStyle(fontSize: 14,color: Colors.amber,fontFamily: 'NomeCredito'),
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
             child: TextFormField(
                    controller: controller_mask_card_data, style: TextStyle(fontSize: 19,color: Colors.amber,fontFamily: 'credtfontbold'),
               textInputAction: TextInputAction.next,
               onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
               decoration: InputDecoration.collapsed(
                   hintStyle: TextStyle(color: Colors.grey),
                   hintText: '00/00'
             ),
             keyboardType:  TextInputType.number,),),

           Container(
              alignment: Alignment.bottomRight,
               margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
               child:icon_card
           )

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
     )))

  ],);
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
    var bandeira = "";

    if (numero[0]=='4')
         bandeira = "Visa";
    if (numero[0]=='5')
      bandeira = "Master";

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
        sendCartaoTokenrize(nome,numero,nome,data,bandeira);
      });
    }
  }

  sendCartaoTokenrize(var nome,var numero,var holder,var data,var bandeira) async{
    print("sendCartaoTokenrize start" );
    var resulToken = await bloc_finance.callTokenrizarCartao(nome,numero,holder,data,bandeira);
    print("sendCartaoTokenrize await" );
    if (resulToken!=null){
      var token = resulToken['body']['CardToken'];
      if (token!=null) {
        var returnSendCard = await bloc_finance.saveTokenCartaoUser(widget.uid, token);
            print(returnSendCard);
        if (returnSendCard) {
            setState(() {
                view_pop_ =true;
            });
        } else {

            }
      }
    }else
      {
        print("sendCartaoTokenrize resulToken null" );
      }


  }

  getDadosCardSave() async{
    Map<String, String> headers = {
      'MerchantId': '28b9bbdf-cbd2-44c2-8cd4-975eaf918710',
      'MerchantKey':'WIGKDGEDWUQYQAKQCZXWTRLRWCWQHHKZJTVYDXDJ'
    };

    dynamic response = await http.get('https://apiquerysandbox.cieloecommerce.cielo.com.br/1/card/85584f09-9407-4dee-a2be-baec3fe03d2f', headers: headers);

    print(response.body);
    setState(() {
      numcard="1";
    });
  }


}