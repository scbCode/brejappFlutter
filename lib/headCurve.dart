import 'package:flutter/material.dart';

class headCurve extends CustomPainter {

  var color ;
  headCurve(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    var path = new Path();
    path.lineTo(0.0, size.height - 20);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 20.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
    Offset(size.width - (size.width / 3.25), size.height - 50);
    var secondEndPoint = Offset(size.width, size.height - 38);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 60);
    path.lineTo(size.width, 0.0);
    path.close();

    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(headCurve oldDelegate) {
    return true;
  }
}