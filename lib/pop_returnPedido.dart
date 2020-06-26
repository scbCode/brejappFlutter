import 'package:flutter/material.dart';
import 'dart:ui';
typedef show_pop_final =  Function();

class pop_returnPedido extends StatefulWidget {

  show_pop_final call_show_pop_final;
  pop_returnPedido (this.call_show_pop_final);

  @override
  pop_returnPedidoState createState() => pop_returnPedidoState();

}

class pop_returnPedidoState extends State<pop_returnPedido>   with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
   return
       Container(
        height: MediaQuery.of(context).size.height-50 ,
         child: ClipRect(
           child:  BackdropFilter(
             filter:  ImageFilter.blur(sigmaX:4, sigmaY:4),
             child:  Container(
                 padding: EdgeInsets.all(30),
                 height: MediaQuery.of(context).size.height-50 ,
                 decoration:  BoxDecoration(color: Colors.transparent),
               child:

               Column(
                   mainAxisAlignment: MainAxisAlignment.center ,
                   children:[
             Container(
                 alignment: Alignment.center,
                 padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                 decoration:
                 BoxDecoration(
                   boxShadow: [BoxShadow(color:Colors.grey[500],blurRadius: 3,offset: Offset(0,2) )],
                   borderRadius: BorderRadius.all(Radius.circular(70)),color: Colors.white,) ,
                 child:
               Container(child:
               Column(
                   mainAxisAlignment: MainAxisAlignment.center ,
                   children:[
                   Container(
                     margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child:
                    Text("PEDIDO CANCELADO",style: TextStyle(fontFamily: 'BreeSerif',fontSize: 16), )),
                   Container(
                       alignment: Alignment.center,
                       margin: EdgeInsets.fromLTRB(10, 15, 10, 30),
                       child:
                     Text("Sua solicitação de reembolso está sendo processada",textAlign: TextAlign.center ,style: TextStyle(fontSize: 16,fontFamily: 'RobotoLight',color: Colors.black))),

                    GestureDetector(onTap:(){widget.call_show_pop_final();},child:
                     Container(
                         decoration:   BoxDecoration(
                             borderRadius:BorderRadius.all(Radius.circular(30))),
                         alignment: Alignment.center,
                         margin: EdgeInsets.fromLTRB(10, 15, 10, 30),
                         child:
                         Text("ENTENDI",textAlign: TextAlign.center ,
                             style: TextStyle(fontSize: 16,fontFamily: 'RobotoBold',color: Colors.orange)))),

                   ]))),
//               Container(
//              height: 200,
//                 alignment: Alignment.center,
//                 padding: EdgeInsets.all(10),
//                 decoration:
//                 BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)),color: Colors.white,
//                 ) ,
//                 child:
//
    ])))));
  }


}