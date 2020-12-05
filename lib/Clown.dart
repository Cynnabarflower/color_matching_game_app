import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Clown extends StatefulWidget {

  num w;
  num h;
  var lampColor;
  var leftEyeColor;
  var rightEyeColor;
  var shirtColor;
  var shirt2Color;
  var shirt3Color;
  var shortsColor;
  var armColor;
  var handColor;
  var footColor;
  List<ClownBodyPart> parts = [];
  var partColors = [];

  Clown({this.w, this.h, this.partColors}) : super(key: GlobalKey()) {
  }

  @override
  State createState() => _ClownState();
}

class _ClownState extends State<Clown> {

  ClownBodyPart head, body, outline, tie, patch, buttons, hands, boots;

  var headGroup = [];
  var bbb = false;
  var kk = -1.0;
  List<ClownBodyPart> parts;


  void initParts() {
    print('init parts');
    const yOff = 10.0;
     head = ClownBodyPart(AssetImage('images/Clown/head.png'), Offset(0, yOff), 383, 429, color: widget.partColors[0].color);
     body = ClownBodyPart(AssetImage('images/Clown/costume.png'), Offset(0, yOff), 383, 429, color: widget.partColors[1].color);
     tie = ClownBodyPart(AssetImage('images/Clown/tie.png'), Offset(0, yOff), 383, 429, color: widget.partColors[2].color);
    outline = ClownBodyPart(AssetImage('images/Clown/clown_outline.png'), Offset(0, yOff), 383, 429, color: Colors.white);
    hands = ClownBodyPart(AssetImage('images/Clown/hands.png'), Offset(0, yOff), 383, 429, color: widget.partColors[3].color);
    boots = ClownBodyPart(AssetImage('images/Clown/boots.png'), Offset(0, yOff), 383, 429, color: widget.partColors[4].color);
    patch = ClownBodyPart(AssetImage('images/Clown/patch.png'), Offset(0, yOff), 383, 429, color: widget.partColors[5].color);
    buttons = ClownBodyPart(AssetImage('images/Clown/buttons.png'), Offset(0, yOff), 383, 429, color: widget.partColors[6].color);

  }

  @override
  void initState() {
    initParts();
    parts = widget.parts = [head, body, tie, hands, boots, patch, buttons, outline];
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      eyesAnimation(true);
      handAnimation(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    var minDx = 99999.0;
    var maxDx = -999999.0;
    var k = min(widget.w/369, widget.h/446) * 0.9;
    if (k != kk) {
      parts.forEach((e) {
        e.resetOffset(); e.resetSize();
        minDx = min(minDx, e.offset.dx);
        maxDx = max(maxDx, e.offset.dx + e.w);
      });

      parts.forEach((e) {
        print("$minDx $maxDx");
        e.w *= k; e.h *=k; e.offset *= k;
        e.offset += Offset(-minDx*k -(maxDx-minDx)/2*k + widget.w/2, 0);
        e.updateStateOffset();
        e.updateStateSize();
        e.setState();
      } );

      print(k);
      kk = k;
    }



    return Container(
      width: widget.w,
      height: widget.h,
      alignment: Alignment.center,
      child: Stack(
        fit: StackFit.loose,
        overflow: Overflow.visible,
        children: parts,
      ),
    );
  }

  void headNodeAnimation({up = true}) {
    headGroup.forEach((e) => (e.key as GlobalKey<dynamic>).currentState.animateMove(e.offset + Offset(0, (up ? -1 : 1) * 10*kk), Duration(milliseconds: 2000)));
    Future.delayed(Duration(milliseconds: 1000), (){
      headNodeAnimation(up: !up);
    });
  }

  void handAnimation(left, {up = true}) {
 /*   (leftArm3.key as GlobalKey<_ClownBodypartState>).currentState.reset();*/
   /* (leftArm3.key as GlobalKey<_ClownBodypartState>).currentState.animationSize(leftArm.w, leftArm.h * (up ? 1 : 1.5), Duration(milliseconds: 1000));
    (leftHand.key as GlobalKey<_ClownBodypartState>).currentState.animateMove(leftHand.offset + Offset(0, leftArm.h * (up ? 0 : 0.5)), Duration(milliseconds: 1000));
    (rightArm3.key as GlobalKey<_ClownBodypartState>).currentState.animationSize(rightArm.w, rightArm.h * (!up ? 1 : 1.5), Duration(milliseconds: 1000));
    (rightHand.key as GlobalKey<_ClownBodypartState>).currentState.animateMove(rightHand.offset + Offset(0, rightArm.h * (!up ? 0 : 0.5)), Duration(milliseconds: 1000));
*/    Future.delayed(Duration(milliseconds: 1000), (){
      handAnimation(left, up: !up);
    });
  }

  void eyesAnimation(left, {up = true}) {
   /* (leftEye.key as GlobalKey<_ClownBodypartState>).currentState.animationSize(leftEye.w * (up ? 1 : 1.1), leftEye.h * (up ? 1 : 1.1), Duration(milliseconds: 1000));
    (leftEyeGlare.key as GlobalKey<_ClownBodypartState>).currentState.animationSize(leftEyeGlare.w * (up ? 1 : 1.1), leftEyeGlare.h * (up ? 1 : 1.1), Duration(milliseconds: 1000));
    (rightEye.key as GlobalKey<_ClownBodypartState>).currentState.animationSize(rightEye.w * (!up ? 1 : 1.1), rightEye.h * (!up ? 1 : 1.1), Duration(milliseconds: 1000));
    (rightEyeGlare.key as GlobalKey<_ClownBodypartState>).currentState.animationSize(rightEyeGlare.w * (!up ? 1 : 1.1), rightEyeGlare.h * (!up ? 1 : 1.1), Duration(milliseconds: 1000));
*/
    Future.delayed(Duration(milliseconds: 1000), (){
      eyesAnimation(left, up: !up);
    });
  }

  Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

}

class ClownBodyPart extends StatefulWidget {

  AssetImage image;
  Offset offset;
  Offset defaultOffset;
  Color color;
  num w;
  num h;
  num defaultW;
  num defaultH;
  bool flip = false;

  ClownBodyPart(this.image, this.offset,  this.w, this.h, {this.color, this.flip = false}) : super(key: GlobalKey<_ClownBodypartState>()){
    this.defaultOffset = offset;
    this.defaultW = w;
    this.defaultH = h;
  }

  void resetOffset() {
    this.offset = defaultOffset;
  }

  void updateStateOffset() {
    if ((this.key as GlobalKey).currentState != null) {
      (this.key as GlobalKey<_ClownBodypartState>).currentState.offset = this.offset;
    }
  }

  void resetSize() {
    this.w = defaultW;
    this.h = defaultH;
  }

  void updateStateSize() {
    if ((this.key as GlobalKey).currentState != null) {
      (this.key as GlobalKey<_ClownBodypartState>).currentState
        ..w = w
        ..h = h;
    }
  }

  void setState() {
    if ((this.key as GlobalKey).currentState != null) {
      (this.key as GlobalKey).currentState.setState(() {

      });
    }
  }

  @override
  State createState() => _ClownBodypartState();

}

class _ClownBodypartState extends State<ClownBodyPart> {

  Offset moveOffset;
  Duration moveDuration = Duration.zero;
  Offset offset;
  num w;
  num h;
  Duration sizeDuration = Duration.zero;

  @override
  void initState() {
    moveOffset = widget.offset;
    offset = widget.offset;
    w = widget.w;
    h = widget.h;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: moveDuration,
      left: offset.dx,
      top: offset.dy,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(widget.flip ? pi : 0),
        child: AnimatedContainer(
          duration: sizeDuration,
          width: w,
            height: h,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: widget.image,
                  colorFilter: ColorFilter.mode(widget.color, BlendMode.modulate)
              ),
            )
        ),
      ),
    );
  }

  void animateMove(Offset offset, Duration duration) {
    this.offset = offset;
    this.moveDuration = duration;
    setState(() {
    });
  }

  void animationSize(num w, num h, Duration duration) {
    this.w = w;
    this.h = h;
    this.sizeDuration = duration;
    setState(() {
    });
  }

}

class PartColor {
  var color;

  PartColor(this.color);
}