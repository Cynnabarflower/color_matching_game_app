import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewRobot extends StatefulWidget {

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
  List<NewRobotBodyPart> parts = [];
  var partColors = [];

  NewRobot({this.w, this.h, this.partColors}) : super(key: GlobalKey()) {
  }

  @override
  State createState() => _NewRobotState();
}

class _NewRobotState extends State<NewRobot> {

  NewRobotBodyPart head, leftEye, leftEyeGlare, rightEye, rightEyeGlare, leftLamp, leftLampGlare, rightLamp, rightLampGlare;
  NewRobotBodyPart shirt, shirt2, shirt3, button, shorts;

  NewRobotBodyPart leftArm, leftArm2, leftArm3, leftHand;
  NewRobotBodyPart rightArm, rightArm2, rightArm3, rightHand;
  NewRobotBodyPart leftLeg, leftFoot, leftFootGlare;
  NewRobotBodyPart rightLeg, rightFoot, rightFootGlare;

  var headGroup = [];
  var bbb = false;
  var kk = -1.0;
  List<NewRobotBodyPart> parts;


  void initParts() {
    print('init parts');
    head = NewRobotBodyPart(AssetImage('images/Robot/head_2.png'), Offset(100, 55), 170, 120, color: Colors.grey,);
     leftEye = NewRobotBodyPart(AssetImage('images/Robot/eye.png'), Offset(130, 85), 50, 40, color: widget.partColors[1].color);
     leftEyeGlare = NewRobotBodyPart(AssetImage('images/Robot/eyeGlare.png'), Offset(131, 93), 23, 27, color: Colors.white,);
     rightEye = NewRobotBodyPart(AssetImage('images/Robot/eye.png'), Offset(198, 85), 50, 40, color: widget.partColors[2].color);
     rightEyeGlare = NewRobotBodyPart(AssetImage('images/Robot/eyeGlare.png'), Offset(199, 93), 23, 27, color: Colors.white,);
     leftLamp = NewRobotBodyPart(AssetImage('images/Robot/leftLamp.png'), Offset(140, 1), 40, 67, color: widget.partColors[0].color,);
     leftLampGlare = NewRobotBodyPart(AssetImage('images/Robot/leftLampGlare.png'), Offset(140, 1), 40, 67, color: darken(widget.partColors[0].color, 0.25),);
     rightLamp = NewRobotBodyPart(AssetImage('images/Robot/rightLamp.png'), Offset(200, 1), 40, 67, color: widget.partColors[0].color,);
     rightLampGlare = NewRobotBodyPart(AssetImage('images/Robot/rightLampGlare.png'), Offset(200, 1), 40, 67, color: darken(widget.partColors[0].color, 0.25),);

     shirt = NewRobotBodyPart(AssetImage('images/Robot/shirt.png'), Offset(65, 156), 235, 155, color: widget.partColors[3].color,);
     shirt2 = NewRobotBodyPart(AssetImage('images/Robot/shirt2.png'), Offset(65, 156), 235, 155, color: widget.partColors[4].color);
     shirt3 = NewRobotBodyPart(AssetImage('images/Robot/shirt3_2.png'), Offset(114, 310), 137, 30, color: widget.partColors[5].color);
     button = NewRobotBodyPart(AssetImage('images/Robot/button.png'), Offset(168, 260), 28, 28, color: widget.partColors[6].color);
     shorts = NewRobotBodyPart(AssetImage('images/Robot/shorts_2.png'), Offset(114, 338), 137, 37, color: widget.partColors[7].color);

     leftArm = NewRobotBodyPart(AssetImage('images/Robot/arm2.png'), Offset(53, 162), 33, 40, color: Colors.white,);
     leftArm2 = NewRobotBodyPart(AssetImage('images/Robot/arm3.png'), Offset(13, 160), 46, 46, color: widget.partColors[8].color);
     leftArm3 = NewRobotBodyPart(AssetImage('images/Robot/arm.png'), Offset(17, 204), 36, 40, color: Colors.white,);
     leftHand = NewRobotBodyPart(AssetImage('images/Robot/hand.png'), Offset(-5, 224), 78, 50, color: widget.partColors[9].color);

     rightArm = NewRobotBodyPart(AssetImage('images/Robot/arm2.png'), Offset(282, 162), 33, 40, color: Colors.white, flip: true,);
     rightArm2 = NewRobotBodyPart(AssetImage('images/Robot/arm3.png'), Offset(305, 160), 46, 46, color: widget.partColors[8].color,  flip: true);
     rightArm3 = NewRobotBodyPart(AssetImage('images/Robot/arm.png'), Offset(309, 204), 36, 40, color: Colors.white,  flip: true);
     rightHand = NewRobotBodyPart(AssetImage('images/Robot/hand.png'), Offset(286, 224), 78, 50, color: widget.partColors[9].color,  flip: true);

     leftLeg = NewRobotBodyPart(AssetImage('images/Robot/leg_2.png'), Offset(122, 348), 36, 69, color: Colors.white);
     leftFoot = NewRobotBodyPart(AssetImage('images/Robot/foot.png'), Offset(99, 406), 79, 46, color: widget.partColors[10].color);
     leftFootGlare = NewRobotBodyPart(AssetImage('images/Robot/footGlare.png'), Offset(99, 406), 79, 46, color: Colors.white);

     rightLeg = NewRobotBodyPart(AssetImage('images/Robot/leg_2.png'), Offset(200, 348), 36, 69, color: Colors.white, flip: true,);
     rightFoot = NewRobotBodyPart(AssetImage('images/Robot/foot.png'), Offset(177, 406), 79, 46, color: widget.partColors[10].color, flip: true,);
     rightFootGlare = NewRobotBodyPart(AssetImage('images/Robot/footGlare.png'), Offset(177, 406), 79, 46, color: Colors.white, flip: true,);

  }

  @override
  void initState() {
    initParts();
    parts = widget.parts = [leftArm, leftArm3, leftArm2, leftHand,
      rightArm, rightArm3, rightArm2, rightHand,
      leftFoot, leftFootGlare, leftLeg,
      rightFoot, rightFootGlare, rightLeg,
      shorts, shirt, shirt2, shirt3, button, head, leftEyeGlare, rightEyeGlare, leftEye, rightEye, leftLamp, leftLampGlare, rightLamp, rightLampGlare];
    headGroup = [head, leftEye, leftEyeGlare, rightEye, rightEyeGlare, leftLamp, leftLampGlare, rightLamp, rightLampGlare];
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
 /*   (leftArm3.key as GlobalKey<_NewRobotBodypartState>).currentState.reset();*/
    (leftArm3.key as GlobalKey<_NewRobotBodypartState>).currentState.animationSize(leftArm.w, leftArm.h * (up ? 1 : 1.5), Duration(milliseconds: 1000));
    (leftHand.key as GlobalKey<_NewRobotBodypartState>).currentState.animateMove(leftHand.offset + Offset(0, leftArm.h * (up ? 0 : 0.5)), Duration(milliseconds: 1000));
    (rightArm3.key as GlobalKey<_NewRobotBodypartState>).currentState.animationSize(rightArm.w, rightArm.h * (!up ? 1 : 1.5), Duration(milliseconds: 1000));
    (rightHand.key as GlobalKey<_NewRobotBodypartState>).currentState.animateMove(rightHand.offset + Offset(0, rightArm.h * (!up ? 0 : 0.5)), Duration(milliseconds: 1000));
    Future.delayed(Duration(milliseconds: 1000), (){
      handAnimation(left, up: !up);
    });
  }

  void eyesAnimation(left, {up = true}) {
    (leftEye.key as GlobalKey<_NewRobotBodypartState>).currentState.animationSize(leftEye.w * (up ? 1 : 1.1), leftEye.h * (up ? 1 : 1.1), Duration(milliseconds: 1000));
    (leftEyeGlare.key as GlobalKey<_NewRobotBodypartState>).currentState.animationSize(leftEyeGlare.w * (up ? 1 : 1.1), leftEyeGlare.h * (up ? 1 : 1.1), Duration(milliseconds: 1000));
    (rightEye.key as GlobalKey<_NewRobotBodypartState>).currentState.animationSize(rightEye.w * (!up ? 1 : 1.1), rightEye.h * (!up ? 1 : 1.1), Duration(milliseconds: 1000));
    (rightEyeGlare.key as GlobalKey<_NewRobotBodypartState>).currentState.animationSize(rightEyeGlare.w * (!up ? 1 : 1.1), rightEyeGlare.h * (!up ? 1 : 1.1), Duration(milliseconds: 1000));

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

class NewRobotBodyPart extends StatefulWidget {

  AssetImage image;
  Offset offset;
  Offset defaultOffset;
  Color color;
  num w;
  num h;
  num defaultW;
  num defaultH;
  bool flip = false;

  NewRobotBodyPart(this.image, this.offset,  this.w, this.h, {this.color, this.flip = false}) : super(key: GlobalKey<_NewRobotBodypartState>()){
    this.defaultOffset = offset;
    this.defaultW = w;
    this.defaultH = h;
  }

  void resetOffset() {
    this.offset = defaultOffset;
  }

  void updateStateOffset() {
    if ((this.key as GlobalKey).currentState != null) {
      (this.key as GlobalKey<_NewRobotBodypartState>).currentState.offset = this.offset;
    }
  }

  void resetSize() {
    this.w = defaultW;
    this.h = defaultH;
  }

  void updateStateSize() {
    if ((this.key as GlobalKey).currentState != null) {
      (this.key as GlobalKey<_NewRobotBodypartState>).currentState
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
  State createState() => _NewRobotBodypartState();

}

class _NewRobotBodypartState extends State<NewRobotBodyPart> {

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