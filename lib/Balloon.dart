
import 'dart:math';

import 'package:flutter/cupertino.dart';

class Balloon extends StatefulWidget {
  Color color;
  var template = AssetImage('images/balloon.png');
  double w, h;
  var scaleFactor = 0.25;

  num transformScaleX = 1 + Random().nextDouble() / 5 - 0.15;
  num transformScaleY = 1 + Random().nextDouble() / 5 - 0.15;
  num dx = Random().nextDouble() / 20 - 0.025;
  num dy = Random().nextDouble() / 20 - 0.035;
  num alpha = Random().nextDouble() / 10 - 0.05;
  num beta = Random().nextDouble() / 10 - 0.05;
  num angle = (Random().nextDouble() - 0.5) * pi * 0.095;

  Balloon(this.color, {key, this.w, this.h,})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _BalloonState();

  Balloon.from(Balloon b, {key}) : super(key: key ?? GlobalKey()) {
    color = b.color;
    template = b.template;
    w = b.w;
    h = b.h;
    scaleFactor = b.scaleFactor;
    transformScaleX = b.transformScaleX;
    transformScaleY =  b.transformScaleY;
    dx = b.dx;
    dy = b.dy;
    alpha = b.alpha;
    beta = b.beta;
    angle = b.angle;
  }
}

class _BalloonState extends State<Balloon> with TickerProviderStateMixin {
  var showDifferences = false;
  var scaleFactor = 0;
  int counter = 0;

  @override
  void initState() {
    super.initState();
  }

  void startAnimation() {
    setState(() {
      counter = 1;
    });
  }

  void stopAnimation() {
    setState(() {
      counter = 0;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      key: GlobalKey(),
      duration: Duration(milliseconds: 1500),
      tween: Tween(begin: 0, end: 4*pi),
      builder: (context, value, child) =>
          Transform.rotate(
        angle: sin(value) * pi/16 * counter,
        child: Transform(
          transform: Matrix4.skew(widget.alpha, widget.beta),
          child: Container(
            width: widget.w *
                (showDifferences ? 1 + scaleFactor : 1) *
                widget.transformScaleX,
            height: widget.h *
                (showDifferences ? 1 + scaleFactor : 1) *
                widget.transformScaleY,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: widget.template,
                    colorFilter: ColorFilter.mode(widget.color, BlendMode.modulate)
                ),
            ),
          ),
        ),
      ),
      onEnd: () {
        counter = 0;
        setState(() {

        });
      },
    );
  }
}