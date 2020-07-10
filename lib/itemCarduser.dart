

import 'package:flutter/material.dart';

typedef SeletItem = Function(int,dynamic,dynamic);

class itemCarduser extends StatefulWidget{

  var snapshot;
  var tipo;
  SeletItem seletItem;
  itemCarduser(this.snapshot,this.seletItem,this.tipo);

  @override
  itemCardState createState() =>itemCardState();

}


class itemCardState extends State<itemCarduser>  {

  var cartaoselect=-1;

  @override
  Widget build(BuildContext context) {



    return
      ListView.builder(
          padding: EdgeInsets.all(0.0),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.snapshot.data.documents.length,
          itemBuilder: (context, index) {
            Offset _offset = Offset.zero;
            var data = widget.snapshot.data.documents[index];
            return item(data,index);});


  }

  item (var data, var index){
    var icon;
    if (widget.tipo=="compra") {
       icon = Icons.radio_button_unchecked;
      if (cartaoselect == index)
        icon = Icons.radio_button_checked;
    }else
      icon = Icons.delete_forever;



    return
    GestureDetector(
        onTap:  (){
          setState(() {
            print("click cartao");
            if (widget.tipo=="compra") {
              cartaoselect = index;
              var idcard = widget.snapshot.data.documents[index].documentID;
              widget.seletItem(cartaoselect, data, idcard);
            }else
              {
                var idcard = widget.snapshot.data.documents[index].documentID;
                widget.seletItem(cartaoselect, data, idcard);
              }
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
                          Image.asset("visa.png",width: 40,height: 60,)),
                      Container(
                          margin: EdgeInsets.fromLTRB(25, 10,0, 10),
                          alignment: Alignment.center, child:
                      Text(data['bandeira']+"  **** "+data['maskNumb'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                        TextStyle(color: Colors.black87,fontFamily: 'RobotoLight'),)),
                    ],),

                  Visibility(
                      visible: true,
                      child:
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child:Icon(icon,color: Colors.orange,),)),
                  ],)),

            ],),

        ],));
  }

}