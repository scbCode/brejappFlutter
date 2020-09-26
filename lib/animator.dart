import 'dart:async';
import 'package:flutter/material.dart';
class animator extends StatefulWidget {
  final Widget child;
  final Duration time;
  animator(this.child, this.time);
  @override
  _animatorState createState() => _animatorState();
}
class _animatorState extends State<animator>
    with SingleTickerProviderStateMixin {
  Timer timer;
  AnimationController animationController;
  Animation animation;
  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 590), vsync: this);
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    timer = Timer(widget.time, animationController.forward);
  }
  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    animationController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: widget.child,
      builder: (BuildContext context, Widget child) {
        return Opacity(
          opacity: 1,
          child: Transform.translate(
            offset: Offset( (1 - animation.value) * -300,0.0),
//            offset: Offset(0.0, (1 - animation.value) * 20),
            child: child,
          ),
        );
      },
    );
  }
}
Timer timer;
Duration duration = Duration();
wait() {
  if (timer == null || !timer.isActive) {
    timer = Timer(Duration(microseconds: 320), () {
      duration = Duration();
    });
  }
  duration += Duration(milliseconds: 200);
  return duration;
}
class WidgetANimator extends StatelessWidget {
  final Widget child;
  WidgetANimator(this.child);
  @override
  Widget build(BuildContext context) {
    return animator(child, wait());
  }
}