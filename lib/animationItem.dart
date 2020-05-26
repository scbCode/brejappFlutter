import 'package:auto_animated/auto_animated.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

class animationItem extends StatefulWidget {

  Function clickItem;
  final list;

  @override
  animationItem(  this.list ,this.clickItem);

  @override
  _AnimationTestState createState() => _AnimationTestState(list);
}

class _AnimationTestState extends State<animationItem> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  static var _listItems = <Widget>[];
  final fetchedList = [];
  int contItem;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  _AnimationTestState(list){
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _loadItems();
    super.initState();
  }

  void changeAutoComplete(){

  }


  void _loadItems() {


    var itemBusca = SimpleAutoCompleteTextField(
        textSubmitted: (text) => setState(() {
          if (text != "") {
            print(text);
           // widget.clickItem(text);
          }
        }),
        decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Buscar'
         ), suggestions:widget.list);

    if (fetchedList.length==0)
    fetchedList.add(itemBusca);

    for(var i =0;i< widget.list.length;i++){
      if(i>0)
        fetchedList.add(
          new GestureDetector(
              onTap: () =>{ widget.clickItem("124") },
              child:Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                  ),
          child:
           Text(" "+widget.list[i],style:TextStyle(fontSize: 14,color: Colors.black),))));
    }


    var future = Future(() {});
    for (var i = 0; i < widget.list.length; i++) {
      future = future.then((_) {
        return Future.delayed(Duration(milliseconds: 100), () {
          _listItems.add(fetchedList[i]);
          _listKey.currentState.insertItem(i);
        });
      });
    }

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
       Container(
         height: 300,
        color: Colors.white, child:

      AnimatedList(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      key: _listKey,
      padding: EdgeInsets.only(top: 10),
      itemBuilder: (context, index, animation) {
        return SlideTransition(
          position: CurvedAnimation(
            curve: Curves.elasticOut,
            parent: animation,
          ).drive((Tween<Offset>(
            begin: Offset(0, -1),
            end: Offset(0, 0),
          ))),
          child: _listItems[index],
        );
      },
    )
   );
  }
}