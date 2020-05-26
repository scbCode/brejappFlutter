import 'package:flutter/material.dart';

class barCurve extends CustomPainter {

  var color ;
  barCurve(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    var path = new Path();

    path.lineTo(0.0, 0.0);


    var firstControlPoint = Offset(size.width / 3, size.height-50);
    var firstEndPoint = Offset(size.width / 2, size.height - 40);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);



    var secondControlPoint =  Offset(size.width/2, size.height -40);
    var secondEndPoint = Offset((size.width / 1.5), size.height-50);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);


//
//    var firstControlPoint = Offset(size.width / 3, size.height-30);
//    var firstEndPoint = Offset(size.width / 2, size.height - 30);
//    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
//        firstEndPoint.dx, firstEndPoint.dy);
//
//
//    var secondControlPoint =
//    Offset(size.width - (size.width / 2), size.height -30);
//    var secondEndPoint = Offset(size.width, size.height -50);
//    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
//        secondEndPoint.dx, secondEndPoint.dy);

    path.close();

    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(barCurve oldDelegate) {
    return true;
  }
}