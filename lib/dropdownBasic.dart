import 'package:flutter/material.dart';


class dropdownBasic extends StatefulWidget {

  Function viewList;
  var margin;
  TextStyle style;
  String hintxt="";
  List<String> values;
  Icon icone;
  Key key;


  dropdownBasic(this.viewList, this.style,this.hintxt,this.values,this.margin,this.icone) ;


  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}


class _MyStatefulWidgetState extends State<dropdownBasic> {
  _MyStatefulWidgetState(){

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return

    Container(
          margin: widget.margin,
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          decoration: BoxDecoration(boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey[350],
              offset: Offset(1.0, 4.0),
              blurRadius: 5.0,
            ),
          ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(width: 1,color:Colors.grey[400])
          ),
          child:
           Row(
            children: <Widget>[
              Container(
                  child:widget.icone
              ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0,0, 0),
            child: Text(widget.hintxt)
            )
      ],),);
  }
}

//
//C:  margin,
//padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
//decoration: BoxDecoration(boxShadow: <BoxShadow>[
//BoxShadow(
//color: Colors.grey,
//offset: Offset(1.0, 2.0),
//blurRadius: 5.0,
//),
//],
//color: Colors.white,
//borderRadius: BorderRadius.circular(5.0),
//),
//child:
//DropdownButtonHideUnderline (
//child:DropdownButton<String>(
//isExpanded: true,
//hint: Text("222"),
//onChanged: (String newValue) {
//setState(() {
//hintxt = newValue;
//});
//},
//iconSize: 0,
//items: values.map((location) {
//return DropdownMenuItem(
//child: new Text(location,textAlign: TextAlign.left,),
//value: location,
//);
//}).toList(),
//)
//),
//
//)