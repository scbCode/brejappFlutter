import 'dart:math' as math;
import 'package:flutter/material.dart';

class ClickyButton extends StatefulWidget {
  final Duration _duration = const Duration(milliseconds: 70);
  final Widget child;
  final MaterialColor color;
  final GestureTapCallback onPressed;

  const ClickyButton({
    Key key,
    @required this.child,
    this.color = Colors.green,
    @required this.onPressed,
  })  : assert(onPressed != null),
        assert(child != null),
        super(key: key);

  @override
  _ClickyButtonState createState() => _ClickyButtonState();
}

class _ClickyButtonState extends State<ClickyButton> {

  double _faceLeft = 20.0;
  double _faceTop = 0.0;
  double _sideWidth = 15.0;
  double _bottomHeight = 10.0;
  Curve _curve = Curves.ease;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 220.0,
        height: 80.0,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
            Positioned(
                top: 0.2, child:
                Container(
               margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
               child: Transform(
                origin: Offset(10, 0),
                transform: Matrix4.skewY(-0.79),
                child:
                Container(
                  decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 2,offset: Offset(-5,0))]),
                  child:AnimatedContainer(
                  duration: widget._duration,
                  curve: _curve,
                  width: _sideWidth,
                  height: 60.0,
                  color: widget.color[600],
                )),
              ),
            )),
            Positioned(
              child: Transform(
                transform: Matrix4.skewX(-0.8),
                child: Transform(
                  origin: Offset(100, 5),
                  transform: Matrix4.rotationZ(math.pi),
                  child:    Container(
                    decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 2,offset: Offset(0,-5))]),
                    child: AnimatedContainer(
                    duration: widget._duration,
                    curve: _curve,
                    width: 200.0,
                    height: _bottomHeight,
                    color: widget.color[700],
                  )),
                ),
              ),
              top: 60.0,
              left: 20.1,
            ),
            AnimatedPositioned(
              duration: widget._duration,
              curve: _curve,
              child: Container(
                alignment: Alignment.center,
                width: 200.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: widget.color,
                  border: Border.all(color: widget.color[700], width: 1),
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
      _faceLeft = 20.0;
      _faceTop = 0.0;
      _sideWidth = 15.0;
      _bottomHeight = 20.0;
    });

    onPressDelay();
  }

  Future onPressDelay() {

    return new Future.delayed(const Duration(milliseconds: 500), () =>     widget.onPressed());
  }
}