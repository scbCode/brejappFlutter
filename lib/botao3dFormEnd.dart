import 'dart:math' as math;
import 'package:flutter/material.dart';

class botao3dFormEnd extends StatefulWidget {
  final Duration _duration = const Duration(milliseconds: 70);
  final Widget child;
  final double sizeW;
  final int colorFactor;
  final MaterialColor color;
  final GestureTapCallback onPressed;

  const botao3dFormEnd ({
    Key key,
    @required this.child,
    this.sizeW= 0.0,
    this.colorFactor=0,
    this.color = Colors.green,
    @required this.onPressed,
  })  : assert(onPressed != null),
        assert(child != null),
        super(key: key);

  @override
  _ClickyButtonState createState() => _ClickyButtonState();
}

class _ClickyButtonState extends State<botao3dFormEnd > {

  double _faceLeft = 10.0;
  double _faceTop = 0.0;
  double _sideWidth = 10.0;
  double _bottomHeight = 10.0;
  Curve _curve = Curves.ease;


  @override
  Widget build(BuildContext context) {

    var c_f_a= (widget.colorFactor*100)+(widget.colorFactor*100);
    var c_f_b= (widget.colorFactor*100)+(widget.colorFactor*200);
    var c_f_c= widget.colorFactor*100;


    return Container(
      width: widget.sizeW,
      height: 80.0,
      child: GestureDetector(
        child: Stack(
          children: <Widget>[

            //BASE
            Positioned(
              child: Transform(
                transform: Matrix4.skewX(-0.8),
                child: Transform(
                  origin: Offset((widget.sizeW*.7)/2, 5),
                  transform: Matrix4.rotationZ(math.pi),
                  child:
                  Container(
                      decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 2,offset: Offset(0,-5))]),
                      child:
                  AnimatedContainer(
                    duration: widget._duration,
                    curve: _curve,
                    width:widget.sizeW*.7,
                    height: _bottomHeight,
                    color: widget.color[800],
                  )),
                ),
              ),
              top: 60.0,
              left: 10.1,
            ),


            //LATERAL
            Positioned(
                top: 0.1, child:
            Transform(
              transform: Matrix4.skewX(0.0),
              child:
              Transform(
                  origin: Offset(0, 0),
                  transform: Matrix4.skewY(-0.79),
                  child:
                  Container(
                    decoration: BoxDecoration(boxShadow: [BoxShadow(  color: Colors.black26,blurRadius:2,offset: Offset(-5,0))]),
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child:
                    AnimatedContainer(
                      duration: widget._duration,
                      curve: _curve,
                      width: _sideWidth,
                      height: 60.0,
                      color: widget.color[600],
                    ),
                  )),
            )),

            //FRENTE
            AnimatedPositioned(
              duration: widget._duration,
              curve: _curve,
              child: Container(
                alignment: Alignment.center,
                width: widget.sizeW*.7,
                height: 60.0,
                decoration: BoxDecoration(
                  color: widget.color[400],
//                 boxShadow: [BoxShadow(color: Colors.black54,blurRadius: 3,offset: Offset(-10,0),)],
                  border: Border.all(color: widget.color[600], width: 1),
                ),
                child: widget.child,
              ),
              left: _faceLeft,
              top: _faceTop,
            ),
          ],
        ),
        onTapDown: _pressed,
        onTapUp: _unPressedOnTapUp,
        onTapCancel: _unPressed,
      ),
    );
  }

  void _pressed(_) {
    setState(() {
      _faceLeft = 0.0;
      _faceTop = 5.0;
      _sideWidth = 0.0;
      _bottomHeight = 0.0;
    });
  }

  void _unPressedOnTapUp(_) => _unPressed();

  void _unPressed() {
    setState(() {
      _faceLeft = 10.0;
      _faceTop = 0.0;
      _sideWidth = 10.0;
      _bottomHeight =10.0;
    });

    onPressDelay();
  }

  Future onPressDelay() {

    return new Future.delayed(const Duration(milliseconds: 500), () =>     widget.onPressed());
  }
}