import 'dart:async';

import 'package:flutter/material.dart';

class CardColorAnimated extends StatefulWidget {
  final Widget child;
  final Color startColor;
  final Color endColor;
  final ShapeBorder shape;
  const CardColorAnimated(
      this.child, this.startColor, this.endColor, this.shape);

  @override
  _CardColorAnimatedState createState() => _CardColorAnimatedState();
}

class _CardColorAnimatedState extends State<CardColorAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _colorTween;
  late Timer timer;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1999));
    _colorTween = ColorTween(begin: widget.startColor, end: widget.endColor)
        .animate(_animationController);
    changeColors();
    super.initState();
  }

  @override
  dispose() {
    timer.cancel();
    _animationController.dispose(); // you need this
    super.dispose();
  }

  Future changeColors() async {
    timer = Timer(const Duration(milliseconds: 2000), () {
      if (_animationController.status == AnimationStatus.completed) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => Card(
        color: _colorTween.value,
        shape: widget.shape,
        child: widget.child,
      ),
    );
  }
}
