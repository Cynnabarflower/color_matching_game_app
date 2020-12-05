import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:color_matching_game/Balloon.dart';
import 'package:color_matching_game/registration.dart';
import 'package:color_matching_game/reward.dart';
import 'package:color_matching_game/stats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'menu.dart';

enum ANSWER { SAME, DIFF, NO }

class BalloonsGame extends StatefulWidget {
  bool tutorial = false;
  var colors;
  int levels;

  BalloonsGame(this.colors, {this.tutorial = false, this.levels});

  @override
  State<StatefulWidget> createState() => _BalloonsGameState();
}

class _BalloonsGameState extends State<BalloonsGame> {
  List<Balloon> balloons;
  List<Balloon> previous = [];
  var colors;
  ANSWER currentAnswer = ANSWER.NO;
  Timer timer;
  bool showPlus = false;
  int level = 1;
  int levelStep = 0;
  int step = 0;
  bool tutorial = true;
  var tutorialBalloons = [
    [0, 0, 0, 0, 2, 0, 0, 0, 0, -1],
    [1, 1, 1, 1, 1, 2, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 3, 1, 1, 1, 2],
    [0, 0, 0, 0, 3, 0, 0, 0, 0, 1],
    [0, 0, 0, 0, 4, 2, 0, 0, 0, 2],
    [1, 1, 1, 3, 1, 2, 1, 1, 1, 2],
    [3, 0, 0, 0, 0, 0, 0, 2, 0, 1],
  ];
  bool lightCorrect = false;
  AnswerButton different, same;
  DateTime startTime = DateTime.now();
  int countdown = 3;
  bool showInfo = true;
  Stats stats = Stats();

  @override
  void initState() {
    tutorial = widget.tutorial;
    if (tutorial) levelStep = 1;
    colors = widget.colors;
    var c = colors[Random().nextInt(2)];
    balloons = List.generate(
        9,
        (index) => Balloon(
              c,
              key: GlobalKey(),
            ));
    super.initState();

    different = AnswerButton(
        Colors.redAccent[200],
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
                    lang == 'ru' ? 'Q или ' : 'Q or ',
                    style: TextStyle(color: Colors.redAccent[100]),
                  ),
                  Icon(
                    Icons.arrow_back,
                    color: Colors.redAccent[100],
                  )
                ],
              ),
            )
          ],
        ),
        true,
        () => answerGiven(ANSWER.DIFF));
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
                    lang == 'ru' ? 'W или ' : 'W or ',
                    style: TextStyle(color: Colors.green[200]),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.green[200],
                  )
                ],
              ),
            )
          ],
        ),
        false,
        () => answerGiven(ANSWER.SAME));
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
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          alignment: Alignment.center,
          color: Colors.lightBlueAccent,
          child: LayoutBuilder(builder: (context, constrains) {
            return RawKeyboardListener(
              onKey: (value) {
                if (showPlus || (currentAnswer == ANSWER.NO)) return;
                if (value.logicalKey.keyId == 0x100070050 ||
                    value.data.keyLabel == 'q') {
                  answerGiven(ANSWER.DIFF);
                } else if (value.logicalKey.keyId == 0x10007004f ||
                    value.data.keyLabel == 'w') {
                  answerGiven(ANSWER.SAME);
                }
              },
              autofocus: true,
              focusNode: FocusNode(),
              child: Stack(
                children: [
                  Visibility(
                    visible: tutorial,
                    child: AnimatedPositioned(
                      duration: Duration(milliseconds: 600),
                      left: (s.aspectRatio < 1
                          ? (0)
                          :  -constrains.maxHeight*9/16 / 2 - 40 - 110 + MediaQuery.of(context).size.width / 2),
                      top: 16,
                      child: SizedBox(
                        width: 110,
                        height: 170,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 1000),
                          child: previous.isEmpty
                              ? Container()
                              : Material(
                                  elevation: 20,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  child: Center(
                                      child:
                                          createMainWidget(100, 160, previous)),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: tutorial,
                    child: AnimatedPositioned(
                      duration: Duration(milliseconds: 600),
                      left: (s.aspectRatio < 1
                          ? (0)
                          :  -constrains.maxHeight*9/16 / 2 - 40 - 110 + MediaQuery.of(context).size.width / 2),
                      top: 16 + 170 + 16.0,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 1000),
                        child: previous.isEmpty
                            ? Container()
                            : SizedBox(
                                width: 110,
                                height: 110,
                                child: previous.isEmpty
                                    ? Container()
                                    : Material(
                                        elevation: 20,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        child: Center(
                                            child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            countdown == 0
                                                ? '?'
                                                : countdown.toString(),
                                            style: TextStyle(
                                                color: Colors.lightBlueAccent,
                                                fontSize: 100),
                                          ),
                                        )),
                                      ),
                              ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 600),
                    left: (s.aspectRatio < 1
                        ? (0)
                        : -constrains.maxHeight*9/16 / 2 - 40 - 110 + MediaQuery.of(context).size.width / 2),
                    bottom: 4,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 1000),
                      child: SizedBox(
                        width: 110,
                        height: 110,
                        child: Material(
                          elevation: 20,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          child: Center(
                              child: InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Menu()),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(Icons.keyboard_arrow_left,
                                        color: Colors.lightBlueAccent),
                                    Text(
                                      lang == 'ru' ? 'Меню' : 'Menu',
                                      style: TextStyle(
                                          color: Colors.lightBlueAccent),
                                    )
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
                    alignment: s.aspectRatio < 1
                        ? Alignment.centerRight
                        : Alignment.center,
                    child: LimitedBox(
                      maxWidth: constrains.maxWidth / 5,
                      child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: Card(
                          elevation: 20,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                  color: Colors.white,
                                ),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                          flex: 70,
                                          child: LayoutBuilder(
                                              builder: (context, constraints) =>
                                                  showPlus
                                                      ? Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: constrains
                                                                      .maxWidth /
                                                                  5 /
                                                                  2,
                                                              child: Image(
                                                                image: AssetImage(
                                                                    'images/plus.png'),
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : createMainWidget(
                                                          constrains.maxWidth,
                                                          constrains.maxHeight *
                                                              0.66,
                                                          balloons))),
                                      Flexible(
                                          flex: 10,
                                          child: AnimatedSwitcher(
                                            duration:
                                                Duration(milliseconds: 800),
                                            child: lightCorrect
                                                ? Container(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                          currentAnswer ==
                                                                  ANSWER.SAME
                                                              ? lang == 'ru'
                                                                  ? 'Не изменились'
                                                                  : 'Same colors'
                                                              : lang == 'ru'
                                                                  ? 'Цвета изменились'
                                                                  : 'Different',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .lightBlueAccent,
                                                              fontSize: 100),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                          )),
                                      Flexible(
                                        flex: 20,
                                        child: Stack(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(child: different),
                                                Expanded(child: same),
                                              ],
                                            ),
                                            Visibility(
                                              visible: showPlus ||
                                                  (currentAnswer == ANSWER.NO),
                                              child: ClipRect(
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaX: 0.8, sigmaY: 0.8),
                                                  child: Container(
                                                    color: Colors.white
                                                        .withOpacity(0.3),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ])),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  static Widget createMainWidget(num w, num h, balloons) {
    if (balloons.isEmpty) return Container();
    List<Widget> elements = [];
    var stackWidth = 0.0;
    var stackHeight = 0.0;
    double xOverlap = 0.15;
    double yOverlap = -0.15;
    double scaleFactor = 0.1;
    double k = min(w / 16, h / 30);

    double imageW = (k * 16) / (2 * (1 + xOverlap) + scaleFactor / 2 + 1);
    double imageH = (k * 30) / (2 * (1 + yOverlap) + scaleFactor / 2 + 1);
    balloons[0]
      ..dx = 0
      ..dy = 0;
    for (int i = 0; i < 9; i++) {
      if (true) {
        balloons[i].w = imageW;
        balloons[i].h = imageH;
        elements.add(Positioned(
            left: (i % 3) * imageW * (1 + xOverlap) +
                imageW * (scaleFactor / 2 + balloons[i].dx) +
                imageW * 0.18,
            top: (i ~/ 3) * imageH * (1 + yOverlap) +
                imageH * (scaleFactor / 2 + balloons[i].dy),
            child: balloons[i]));
      }
    }
    stackWidth =
        (2 * ((1 + xOverlap) + scaleFactor / 2) * imageW + imageW) * 1.1;
    stackHeight = (2 * ((1 + yOverlap) + scaleFactor / 2) * imageH + imageH);
    return Container(
      width: stackWidth,
      height: stackHeight,
      child: Stack(
        alignment: Alignment.center,
        children: elements,
      ),
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
      if (tutorial) {
        var diff = getDifferent();
        diff[0].forEach((e) {
          (previous[e].key as GlobalKey<dynamic>).currentState.startAnimation();
        });
        diff[1].forEach((e) {
          (balloons[e].key as GlobalKey<dynamic>).currentState.startAnimation();
        });
        timer = Timer(Duration(seconds: 3), () => answerGiven(ANSWER.NO));
        lightCorrect = true;
        setState(() {});
        return;
      }
    }
    stats.add(Answer(step, currentAnswer, answer, time));
    lightCorrect = false;
    balloons.forEach((element) {
      if ((element.key as GlobalKey).currentState != null)
        (element.key as GlobalKey<dynamic>).currentState.stopAnimation();
    });

    timer = Timer(Duration(seconds: 1), () {
      showNext();
    });

    showPlus = true;
    setState(() {});

    previous = List.of(balloons);
    balloons = balloons.map((e) => Balloon.from(e)).toList();
  }

  void showNext() {
    if (levelStep == 0) {
      generateBalloons(answer: ANSWER.DIFF);
      currentAnswer = ANSWER.NO;
    } else if (levelStep == 5) {
      var c = colors[Random().nextInt(2)];
      balloons = List.generate(
          9,
          (index) => Balloon(
                c,
                key: GlobalKey(),
              ));
      currentAnswer = ANSWER.NO;
      levelStep = -1;
      print('${level} ${widget.levels}');
      if (level == widget.levels) {
        finishGame();
      }
      level++;
    } else
      generateBalloons();
    levelStep++;
    step++;

    lightCorrect = false;
    showPlus = false;
    startTime = DateTime.now();
    setState(() {});

    if (timer != null) timer.cancel();
    countdown = 3;
    gameTimer();
  }

  @override
  void dispose() {
    if (timer != null) timer.cancel();
    super.dispose();
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
          'Balloons-' +
          DateTime.now().toString() +
          '.txt',
      'data': stats.toString()
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Reward(stats)),
    );
  }

  void generateBalloons({ANSWER answer}) {
    if (tutorial) {
      if (tutorialBalloons.isEmpty) {
        finishGame();
        return;
      }
      levelStep = 1;
      for (int i = 0; i < balloons.length; i++) {
        balloons[i].color = colors[tutorialBalloons[0][i] % colors.length];
      }
      currentAnswer = tutorialBalloons[0].last == -1
          ? ANSWER.NO
          : tutorialBalloons[0].last == 1 ? ANSWER.SAME : ANSWER.DIFF;
      tutorialBalloons.removeAt(0);
      return;
    }

    answer = answer ?? (Random().nextBool() ? ANSWER.SAME : ANSWER.DIFF);

    print(answer);
    currentAnswer = answer;

    if (answer == ANSWER.SAME) {
      generateSame();
    } else if (answer == ANSWER.DIFF) {
      generateSame();
      var colorsToChange = min(level ~/ 2 + 1, 3);
      var usedColors = [];
      var moreThanOnce = [];
      var changedColors = [];
      balloons.forEach((e) {
        if (e.color != colors[0] && e.color != colors[1]) {
          if (usedColors.contains(e.color))
            moreThanOnce.add(e.color);
          else
            usedColors.add(e.color);
        }
      });
      var newColors = List.of(colors)
        ..removeWhere(
            (e) => usedColors.contains(e) || e == colors[0] || e == colors[1]);
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
          balloons.forEach((e) {
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
          balloons.forEach((e) {
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
            balloons[1].color = newColor;
            for (int i = 2; i < 9; i++)
              if (Random().nextBool()) balloons[i].color = newColor;
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
          balloons.forEach((e) {
            if (moreThanOnce.contains(e.color)) {
              moreThanOnce.remove(e.color);
              if (gotOne && Random().nextBool()) return;
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
      generateSame();
    }
  }

  void generateSame() {
    var neutralColor = colors[Random().nextInt(2)];
    var usedColors = [];
    var moreThanOnce = [];
    balloons.forEach((e) {
      if (e.color == colors[0] || e.color == colors[1]) return;
      if (usedColors.contains(e.color)) {
        moreThanOnce.add(e.color);
      } else
        usedColors.add(e.color);
    });

    var chooseFrom = List.of(usedColors)..add(neutralColor);
    balloons.forEach((e) {
      if (moreThanOnce.contains(e.color) ||
          e.color == colors[0] ||
          e.color == colors[1]) {
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
      if (e.color == colors[0] || e.color == colors[1]) e.color = neutralColor;
    });
    balloons.shuffle();
  }

  List<dynamic> getDifferent() {
    if (previous.isEmpty) return [[], []];

    var prevBalloons = [];
    var currBalloons = [];

    if (currentAnswer == ANSWER.DIFF) {
      var prevColors = {colors[0], colors[1]};
      var currColors = {colors[0], colors[1]};
      for (int i = 0; i < 9; i++) {
        prevColors.add(previous[i].color);
        currColors.add(balloons[i].color);
      }
      for (int i = 0; i < 9; i++) {
        if (!currColors.contains(previous[i].color)) prevBalloons.add(i);
        if (!prevColors.contains(balloons[i].color)) currBalloons.add(i);
      }
    } else {
      for (int i = 0; i < 9; i++) {
        if (previous[i].color != colors[0] && previous[i].color != colors[1]) {
          prevBalloons.add(i);
        }
        if (balloons[i].color != colors[0] && balloons[i].color != colors[1]) {
          currBalloons.add(i);
        }
      }
    }
    return [prevBalloons, currBalloons];
  }
}

class AnswerButton extends StatefulWidget {
  Color color;
  Widget child;
  bool left;
  Function pressed;

  AnswerButton(this.color, this.child, this.left, this.pressed)
      : super(key: GlobalKey());

  @override
  State createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {
  double spread = 1;
  bool animate = false;

  void startAnimation() {
    animate = true;
    setState(() {});
  }

  void stopAnimation() {
    animate = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return TweenAnimationBuilder(
        duration: Duration(milliseconds: 2000),
        tween: Tween(begin: 0, end: animate ? pi : 0),
        key: GlobalKey(),
        builder: (context, value, child) {
          spread = cos(value).abs();
          return Container(child: child);
        },
        onEnd: () {
          spread = 1;
          setState(() {});
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: widget.left
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    topLeft: Radius.circular(16))
                : BorderRadius.only(
                    bottomRight: Radius.circular(16),
                    topRight: Radius.circular(16)),
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
    });
  }
}

class TutorialInfo extends StatefulWidget {


  @override
  State createState() => _TutorialInfoState();
}

class _TutorialInfoState extends State<TutorialInfo> {


  var infoTextEN = RichText(
    text: TextSpan(
      text: "You have to define if the balloon's colors have changed."
    "If colors are same - press the ",
      style: TextStyle(color: Colors.black87, fontSize: 20),
      children: <TextSpan>[
        TextSpan(text: 'green', style: TextStyle(color: Colors.green[600])),
        TextSpan(text: ' button, otherwise -'),
        TextSpan(text: 'red', style: TextStyle(color: Colors.redAccent)),
        TextSpan(text: " Ignore "),
        TextSpan(text: 'зеленую', style: TextStyle(color: Colors.green[600])),
        TextSpan(text: ' and '),
        TextSpan(text: 'blue', style: TextStyle(color: Colors.blue)),
        TextSpan(text: ' balloons\n'),
        TextSpan(text: "Every level consists of 5 tests. First two don't require any answer. "
          "You will have 3 seconds to answer for each test."),
      ],
    ),
  );

  var infoTextRU = RichText(
    text: TextSpan(
      text: "Вам надо определить изменились ли цвета шариков. ",
      style: TextStyle(color: Colors.black87, fontSize: 20),
      children: <TextSpan>[
        TextSpan(text: 'Зеленый', style: TextStyle(color: Colors.green[600])),
        TextSpan(text: ' и '),
        TextSpan(text: 'синий', style: TextStyle(color: Colors.blue)),
        TextSpan(text: " цвета учитывать не надо."
            " Если цвета не изменились, то нажмите на "),
        TextSpan(text: 'зеленую', style: TextStyle(color: Colors.green[600])),
        TextSpan(text: ' кнопку, иначе - на '),
        TextSpan(text: 'красную\n', style: TextStyle(color: Colors.redAccent)),
        TextSpan(text: "Один уровень состоит из 5 тестов, на первые два отвечать не надо. "
            "Каждый раз у вас будет 3 секунды на ответ. Если ответ не был дан, тест считается пропущенным."),
      ],
    ),
  );


  var balloons1 = List.generate(
      9,
          (index) => Balloon(
        Colors.green,
        key: GlobalKey(),
      ));

  var balloons2 = List.generate(
      9,
          (index) => Balloon(
        Colors.blue,
            key: GlobalKey()
      ));

  var balloons3 = List.generate(
      9,
          (index) => Balloon(
        Colors.blue,
        key: GlobalKey(),
      ));

  var balloons4 = List.generate(
      9,
          (index) => Balloon(
        Colors.blue,
            key: GlobalKey(),
      ));

  var page = 1;

  @override
  void initState() {

    balloons1[3].color = Colors.red[600];
    balloons2[5].color = Colors.red[600];
    balloons3[2].color = Colors.amberAccent;
    balloons4[5].color = Colors.red[600];

    WidgetsBinding.instance.addPostFrameCallback((_) {

      void shakeBalloons() {
        if ((balloons1[3].key as GlobalKey<dynamic>).currentState != null) {
          (balloons1[3].key as GlobalKey<dynamic>).currentState
              .startAnimation();
          (balloons2[5].key as GlobalKey<dynamic>).currentState
              .startAnimation();
          (balloons3[2].key as GlobalKey<dynamic>).currentState
              .startAnimation();
          (balloons4[5].key as GlobalKey<dynamic>).currentState
              .startAnimation();
        }
        Future.delayed(Duration(milliseconds: 2500), shakeBalloons);
      }
      shakeBalloons();
    });

    super.initState();
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
          child: LayoutBuilder(builder: (context, constrains) {
            var exampleHeight = constrains.maxHeight/5;
            var exampleWidth = constrains.maxWidth/4;

            var same = Container(
              height: exampleHeight / 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(12),
                    topRight: Radius.circular(12)),
                color: Colors.green[500],
              ),
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(8),
                child:   FittedBox(
                  fit:  BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.done_outline,
                    color: Colors.green[200],
                  ),
                ),
              ),
            );

            var different = Container(
              height: exampleHeight/4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    topLeft: Radius.circular(16)),
                color: Colors.redAccent[200],
              ),
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child:   FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.redAccent[100],
                    ),
                  ),
                ),
              ),
            );


            return Align(
              alignment: Alignment.center,
              child: LimitedBox(
                maxWidth: constrains.maxWidth / 5,
                child: AspectRatio(
                  aspectRatio: 9 / 16,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              page == 1 ?
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        lang == 'ru' ? 'Правила' : 'Rules',
                                        style: TextStyle(
                                            color: Colors.lightBlue,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  (lang == 'ru' ? infoTextRU : infoTextEN),
                                ],
                              ) :
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        lang == 'ru' ?
                                        'Например здесь цвета одинаковые\n(кроме синего и зеленого)'
                                            : 'Here colors are same\n (except blue and green)',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black87, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            _BalloonsGameState.createMainWidget(
                                                exampleWidth,
                                                exampleHeight,
                                                balloons1),
                                            _BalloonsGameState.createMainWidget(
                                                exampleWidth,
                                                exampleHeight,
                                                balloons2)
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(child: Opacity(opacity: 0.4,child: different)),
                                            Expanded(
                                              child: same,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        lang == 'ru' ?
                                        'А здесь разные'
                                            : 'Here are different',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black87, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            _BalloonsGameState.createMainWidget(
                                                exampleWidth,
                                                exampleHeight,
                                                balloons4),
                                            _BalloonsGameState.createMainWidget(
                                                exampleWidth,
                                                exampleHeight,
                                                balloons3)
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(child: different),
                                            Expanded(
                                              child: Opacity(
                                                opacity: 0.4,
                                                child: same,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: MaterialButton(
                                      onPressed: () {
                                        if (page == 2) {
                                          setState(() {
                                            page = 1;
                                          });
                                          return;
                                        }

                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Menu()),
                                          );
                                      },
                                      color: Colors.lightBlueAccent,
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: MaterialButton(
                                      onPressed: () {
                                        if (page == 1) {
                                          setState(() {
                                            page = 2;
                                          });
                                          return;
                                        }

                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => BalloonsGame(
                                                  [
                                                    Colors.green,
                                                    Colors.blue,
                                                    Colors.red[600],
                                                    Colors.amberAccent,
                                                    Colors.deepOrangeAccent,
                                                    Colors.brown,
                                                    Colors.purpleAccent[100]
                                                  ],
                                                  tutorial: true,
                                                )),
                                          );},
                                      color: Colors.lightBlueAccent,
                                      child: Text(
                                        page == 2 ? (lang == 'ru'
                                            ? 'Начать обучение'
                                            : 'Start tutorial game') : (lang == 'ru'
                                            ? 'Дальше'
                                            : 'Next'),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );

  }
}
