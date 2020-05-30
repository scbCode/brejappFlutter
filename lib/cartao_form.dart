import 'package:button3d/button3d.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'ClickyButton.dart';

typedef hide_pop =  Function();


class cartao_form extends StatefulWidget {


  hide_pop hide_pop_callback;
  cartao_form (this.hide_pop_callback);


  @override
  cartao_formState createState() => cartao_formState();

}

class cartao_formState extends State<cartao_form>  with SingleTickerProviderStateMixin {

  final myController_numero = TextEditingController();
  var controller_mask_card = new MaskedTextController(mask: '0000 0000 0000 0000', text: '');
  var controller_mask_card_data = new MaskedTextController(mask: '00/00', text: '');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController_numero.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

  return
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
             child: TextFormField( style: TextStyle(fontSize: 19,color: Colors.amber,fontFamily: 'credtfontbold'),
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
                  onPressed: () {},
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
     );
  }

  @override
  void initState() {
    super.initState();
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

    myController_numero.text=n;
  }

  callTokenrizarCartao() async {


    print("callTokenrizarCartao");
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'criarToken',
    );
    dynamic resp = await callable.call(<String, dynamic>{
      'YOUR_PARAMETER_NAME': 'YOUR_PARAMETER_VALUE',
    });
    print("callTokenrizarCartaofinal");

  }



}