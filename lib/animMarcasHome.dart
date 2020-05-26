import 'dart:async';
import 'package:flutter/material.dart';
class animMarcasHome extends StatefulWidget {
  final Widget child;
  final Duration time;

  animMarcasHome(this.child, this.time);
  @override
  _animatorState createState() => _animatorState();
}
class _animatorState extends State<animMarcasHome>
    with SingleTickerProviderStateMixin {
  Timer timer;
  AnimationController animationController;
    ScrollController _scrollController = ScrollController();

  Animation animation;
  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 290), vsync: this);
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    timer = Timer(widget.time, animationController.forward);
    _scrollController.jumpTo(animation.value);
  }
  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    animationController.dispose();
  }
  @override
  Widget build(BuildContext context) {

  }
}
Timer timer;
Duration duration = Duration();
wait() {
  if (timer == null || !timer.isActive) {
    timer = Timer(Duration(microseconds: 120), () {
      duration = Duration();
    });
  }
  duration += Duration(milliseconds: 100);
  return duration;
}
