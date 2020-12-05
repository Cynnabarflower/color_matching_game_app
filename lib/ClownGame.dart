import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:color_matching_game/Clown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BalloonsGame.dart';
import 'menu.dart';
import 'registration.dart';
import 'package:http/http.dart' as http;

import 'reward.dart';
import 'stats.dart';


class ClownsGame extends StatefulWidget {

  var colors;
  int levels;

  @override
  State<StatefulWidget> createState() => _ClownsGameState();

  ClownsGame(this.colors, {this.levels = 3});
}

class _ClownsGameState extends State<ClownsGame> {

  Clown robot;
  Clown previous;
  ANSWER currentAnswer = ANSWER.NO;
  var colors;
  Timer timer;
  bool showPlus = false;
  int levelStep = 0;
  int level = 1;
  bool tutorial = true;
  bool lightCorrect = false;
  AnswerButton different, same;
  DateTime startTime = DateTime.now();
  Stats stats = Stats();
  var countdown = 3;

  @override
  void initState() {

    colors = widget.colors;
    robot = Clown(partColors: List.generate(7, (index) =>PartColor(Colors.purpleAccent)));

    super.initState();

    different = AnswerButton(Colors.redAccent[200],
        Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.remove_circle_outline,
                color: Colors.redAccent[100],
                size: 30,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Q or ',
                    style: TextStyle(
                        color: Colors.redAccent[100]
                    ),
                  ),
                  Icon(Icons.arrow_back, color: Colors.redAccent[100],)
                ],
              ),
            )
          ],
        ), true, () => answerGiven(ANSWER.DIFF));
    same = AnswerButton(
        Colors.green[500],
        Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.done_outline,
                color: Colors.green[200],
                size: 30,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'W or ',
                    style: TextStyle(
                        color: Colors.green[200]
                    ),
                  ),
                  Icon(Icons.arrow_forward, color: Colors.green[200],)
                ],
              ),
            )
          ],
        )
        ,false , () => answerGiven(ANSWER.SAME));

    countdown = 3;
    gameTimer();

  }

  void gameTimer() {
    if (countdown > 0) {
      setState(() {});
      timer = Timer(Duration(seconds: 1), () {
        countdown--;
        gameTimer();
      });
    } else {
      answerGiven(ANSWER.NO);
    }
  }

  @override
  void dispose() {
    if (timer != null)
      timer.cancel();
    if (robot != null && (robot.key as GlobalKey).currentState != null)
      (robot.key as GlobalKey).currentState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var s = MediaQuery.of(context).size;

    if (s.width < MIN_WIDTH || s.height < MIN_HEIGHT) {
      return smallScreen();
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          alignment: Alignment.center,
          color: Colors.lightBlueAccent,
          child: LayoutBuilder(
              builder: (context, constraints) {
                return RawKeyboardListener(
                  onKey: (value) {
                    if (showPlus || (currentAnswer == ANSWER.NO))
                      return;
                    if (value.logicalKey.keyId == 0x100070050 || value.data.keyLabel == 'q') {
                      answerGiven(ANSWER.DIFF);
                    } else if (value.logicalKey.keyId == 0x10007004f || value.data.keyLabel == 'w') {
                      answerGiven(ANSWER.SAME);
                    }
                  },
                  autofocus: true,
                  focusNode: FocusNode(),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left:
                  -constraints.maxHeight*9/16 / 2 - 40 - 110 + MediaQuery.of(context).size.width / 2,
                        bottom: 4,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 1000),
                          child: SizedBox(
                            width: 110,
                            height: 110,
                            child: Material(
                              elevation: 20,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Menu()),
                                      );
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Icon(Icons.keyboard_arrow_left, color: Colors.lightBlueAccent),
                                            Text(lang == 'ru' ? 'Меню':'Menu', style: TextStyle(color: Colors.lightBlueAccent),)
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: LimitedBox(
                          maxWidth: constraints.maxWidth/5,
                          child: AspectRatio(
                            aspectRatio: 9/16,
                            child: Card(
                              elevation: 20,
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(16)),
                                      color: Colors.white,
                                    ),

                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                              flex: 70,
                                              child: LayoutBuilder(builder: (context, constraints) =>
                                              showPlus ?
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: constraints.maxWidth / 5,
                                                    child: Image(
                                                      image: AssetImage('images/plus.png'),
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                  ),
                                                ],
                                              )
                                                  :
                                              createMainWidget(constraints.maxWidth, constraints.maxHeight))),
                                          Flexible(
                                              flex: 10,
                                              child: AnimatedSwitcher(
                                                duration: Duration(milliseconds: 800),
                                                child: lightCorrect ? Container(
                                                  alignment: Alignment.bottomCenter,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(currentAnswer == ANSWER.SAME ?
                                                      'Same' : 'Different', style: TextStyle(color: Colors.lightBlueAccent, fontSize: 100),),
                                                    ),
                                                  ),
                                                ) : Container(),
                                              )),
                                          Flexible(
                                            flex: 20,
                                            child: Stack(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                        child: different),
                                                    Expanded(
                                                        child: same),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: showPlus || (currentAnswer == ANSWER.NO),
                                                  child: ClipRect(
                                                    child: BackdropFilter(
                                                      filter:  ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                                                      child: Container(
                                                        color: Colors.white.withOpacity(0.3),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ]
                                    )
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
          ),
        ),
      ),
    );
  }



  Widget createMainWidget(num w, num h) {
    return Stack(
      alignment: Alignment.center,
      children: [
        robot
        ..w = w
        ..h = h
//        Clown(w: w, h: h, partColors: List.generate(10, (index) => colors[0])),
      ],
    );
  }

  void answerGiven(ANSWER answer) {
    var time = DateTime.now().difference(startTime).inMicroseconds;
    if (timer != null) {
      timer.cancel();
    }
    if (answer == currentAnswer) {
      print('correct');
    } else {
      print('incorrect');
    }
    stats.add(Answer(levelStep, currentAnswer, answer, time));
    lightCorrect = false;

    timer = Timer(Duration(seconds: 1), () {
      showNext();
    });

    showPlus = true;
    setState(() {});
  }

  void finishGame() {
    const String BOT_URL =
        "https://color-matching-game-server.herokuapp.com/bot";
    http.Client().post(BOT_URL, body: {
      'name': username +
          '-' +
          birthday +
          '-' +
          gender +
          '-' +
          'Clown-' +
          DateTime.now().toString() +
          '.txt',
      'data': stats.toString()
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Reward(stats)),
    );
  }


  void showNext() {
    if (levelStep == 0) {
      generateClowns(answer: ANSWER.DIFF);
      currentAnswer = ANSWER.NO;
    }
    else if (levelStep == 5) {
      currentAnswer = ANSWER.NO;
      levelStep = -1;
      print('${level} ${widget.levels}');
      if (level == widget.levels) {
        finishGame();
      }
      var c = colors[Random().nextInt(2)];
      robot.partColors.forEach((e) {
        e.color = c;
      });


      level++;
    } else
      generateClowns();

    levelStep++;

    lightCorrect = false;
    showPlus = false;
    startTime = DateTime.now();
    setState(() {});

    if (timer != null)
      timer.cancel();
    timer = Timer(Duration(seconds: 3), () {
      answerGiven(ANSWER.NO);
    });
  }

  void generateClowns({ANSWER answer}) {
    answer = answer ?? (Random().nextBool() ? ANSWER.SAME : ANSWER.DIFF);

    print(answer);
    currentAnswer = answer;

    if (answer == ANSWER.SAME) {
      generateSame();
    } else if (answer == ANSWER.DIFF) {
      //generateSame();
      var colorsToChange = min(level ~/ 2 + 1, 3);
      var usedColors = [];
      var moreThanOnce = [];
      var changedColors = [];
      robot.partColors.forEach((e) {
        if (e.color != colors[0] && e.color != colors[1]) {
          if (usedColors.contains(e.color))
            moreThanOnce.add(e.color);
          else
            usedColors.add(e.color);
        }
      });
      var newColors = List.of(colors)
        ..removeWhere((e) => usedColors.contains(e) || e == colors[0] || e == colors[1]);
      while (colorsToChange > 0) {
        var removeColor;
        var newColor;

        var r = Random().nextInt(100);
        if (usedColors.length < 2) {
          r = 99;
        } else if (newColors.isEmpty) {
          r = min(r, 69);
        }

        if (r < 30) {
          //replace
          removeColor = usedColors[Random().nextInt(usedColors.length)];
          newColor = newColors[Random().nextInt(newColors.length)];
          if (changedColors.contains(newColor))
            continue;
          else
            changedColors.add(newColor);
          bool gotOne = false;
          robot.partColors.forEach((e) {
            if (e.color == removeColor) {
              if (gotOne && Random().nextInt(100) < 10) {
                e.color = colors[0];
              } else
                e.color = newColor;
              gotOne = true;
            }
          });
        } else if (r < 70) {
          //remove
          removeColor = usedColors[Random().nextInt(usedColors.length)];
          if (changedColors.contains(removeColor))
            continue;
          else
            changedColors.add(removeColor);
          newColor = usedColors[Random().nextInt(usedColors.length)];
          bool gotOne = false;
          robot.partColors.forEach((e) {
            if (e.color == removeColor) {
              if (gotOne && Random().nextInt(100) < 10) {
                e.color = colors[0];
              } else
                e.color = newColor;
              gotOne = true;
            }
          });
        } else {
          //new
          if (moreThanOnce.isEmpty) {
            newColor = newColors[Random().nextInt(newColors.length)];
            robot.partColors[1].color = newColor;
            for (int i = 2; i < 6; i++)
              if (Random().nextBool())
                robot.partColors[i].color = newColor;
            colorsToChange--;
            changedColors.add(newColor);
            continue;
          }
          newColor = newColors[Random().nextInt(newColors.length)];
          if (changedColors.contains(newColor))
            continue;
          else
            changedColors.add(newColor);
          bool gotOne = false;
          robot.partColors.forEach((e) {
            if (moreThanOnce.contains(e.color)) {
              moreThanOnce.remove(e.color);
              if (gotOne && Random().nextBool())
                return;
              if (gotOne && Random().nextInt(100) < 5) {
                e.color = colors[0];
              } else
                e.color = newColor;
              gotOne = true;
            }
          });
        }
        colorsToChange--;
      }
    //  generateSame();
    }
  }

  void generateSame() {
    var neutralColor = colors[Random().nextInt(2)];
    var usedColors = [];
    var moreThanOnce = [];
    robot.partColors.forEach((e) {
      if (e.color == colors[0] || e.color == colors[1])
        return;
      if (usedColors.contains(e.color)) {
        moreThanOnce.add(e.color);
      } else
        usedColors.add(e.color);
    });

    var chooseFrom = List.of(usedColors)
      ..add(neutralColor);
    robot.partColors.forEach((e){
      if (moreThanOnce.contains(e.color) || e.color == colors[0] || e.color == colors[1]) {
        if (Random().nextBool()) {
          moreThanOnce.remove(e.color);
          e.color = chooseFrom[Random().nextInt(chooseFrom.length)];
        } else if (Random().nextInt(100) < 1000) {
          moreThanOnce.remove(e.color);
          e.color = neutralColor;
        }
      } else {
        e.color = usedColors[Random().nextInt(usedColors.length)];
        usedColors.remove(e.color);
      }
      if (e.color == colors[0] || e.color == colors[1])
        e.color = neutralColor;
    });
    robot.partColors.shuffle();
  }


  List<dynamic> getDifferent() {
    return [[], []];
  }

}

class AnswerButton extends StatefulWidget {

  Color color;
  Widget child;
  bool left;
  Function pressed;


  AnswerButton(this.color, this.child, this.left, this.pressed) : super(key: GlobalKey());

  @override
  State createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {

  double spread = 1;
  bool animate = false;

  void startAnimation() {
    animate = true;
    setState(() {

    });
  }

  void stopAnimation() {
    animate = false;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (context, setState) {
          return TweenAnimationBuilder(
            duration: Duration(milliseconds: 2000),
            tween: Tween(begin: 0, end: animate ? pi : 0),
            key: GlobalKey(),
            builder: (context, value, child) {
              spread = cos(value).abs();
              return Container(
                  child: child);
            },
            onEnd: () {
              spread = 1;
              setState((){});
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: widget.left ? BorderRadius.only(bottomLeft: Radius.circular(16), topLeft: Radius.circular(16))
                    : BorderRadius.only(bottomRight: Radius.circular(16), topRight: Radius.circular(16)),
                color: widget.color,
              ),
              child: FlatButton(
                onPressed: widget.pressed,
                child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}