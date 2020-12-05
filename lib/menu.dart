import 'dart:math';
import 'dart:ui';

import 'package:color_matching_game/BalloonsGame.dart';
import 'package:color_matching_game/HowManyLevels.dart';
import 'package:color_matching_game/registration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var lang = 'ru';
enum GAMES { BALLOONS, ROBOT, CLOWN}

const MIN_WIDTH = 600;
const MIN_HEIGHT = 600;

class Menu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MenuState();
}

Widget smallScreen() {
  return Scaffold(
    body: SafeArea(
      child: Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        color: Colors.lightBlueAccent,
        child: LayoutBuilder(builder: (context, constrains) {
          return Card(
            elevation: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                    color: Colors.white,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            'Please open the window to fullscreen\n'
                            'Пожалуйста разверните окно на весь экран',
                            style: TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 50,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                      ),
                    ])),
              ),
            ),
          );
        }),
      ),
    ),
  );
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;

    print(s);

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
            return LimitedBox(
              maxWidth: constrains.maxWidth / 5,
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: Card(
                  elevation: 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                          color: Colors.white,
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  lang == 'ru' ? 'Игры' : 'Games',
                                  style: TextStyle(
                                      color: Colors.lightBlue,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              child: getGameButton(
                                  lang == 'ru' ? 'Обучение' : 'Tutorial',
                                  'question_pattern2.jpg', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TutorialInfo()),
                                );
                              }, Colors.white.withOpacity(0.1)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              child: getGameButton(
                                  lang == 'ru' ? 'Шарики' : 'Balloons',
                                  'balloons-pattern.jpg', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HowManyLevels(GAMES.BALLOONS)),
                                );
                              }, Colors.yellowAccent.withOpacity(0.1)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              child: getGameButton(
                                  lang == 'ru' ? 'Робот' : 'Robot',
                                  'robot-pattern.jpg', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HowManyLevels(GAMES.ROBOT)),
                                );
                              }, Colors.white.withOpacity(0.1)),
                            ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  child: getGameButton(
                                      lang == 'ru' ? 'Клоун' : 'Clown',
                                      'clown-pattern.jpg', () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HowManyLevels(GAMES.CLOWN)),
                                    );
                                  }, Colors.white.withOpacity(0.1)),
                                ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegistrationForm()),
                                        );
                                      },
                                      child: ClipRect(
                                        child: Material(
                                          color: Colors.lightBlueAccent,
                                          elevation: 20,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          child: Container(
                                            height: 40,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 8),
                                            child: AnimatedSwitcher(
                                              duration:
                                                  Duration(milliseconds: 500),
                                              child: max(
                                                          constrains.maxWidth /
                                                              5,
                                                          constrains.maxHeight *
                                                              9 /
                                                              16) >
                                                      310
                                                  ? Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        4),
                                                            child: Icon(
                                                              Icons
                                                                  .account_circle,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                        Text(
                                                          lang == 'ru'
                                                              ? 'Регистрация '
                                                              : 'Registration',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      ],
                                                    )
                                                  : Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4),
                                                      child: Icon(
                                                        Icons.account_circle,
                                                        color: Colors.white,
                                                      )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    languageRaw()
                                  ],
                                ),
                              ),
                            )
                          ])),
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

  Widget getGameButton(text, image, pressed, color,
      {textColor = Colors.white}) {
    var blur = 0.5;

    var planetThumbnail = new Container(
      alignment: FractionalOffset.centerLeft,
      child: ClipOval(
        child: new Image(
          image: AssetImage('images/'+image),
          height: 48.0,
          width: 48.0,
        ),
      ),
    );

    final planetCard = new Container(
      alignment: Alignment.center,
      margin: new EdgeInsets.only(left: 24.0),
      decoration: new BoxDecoration(
        color: Colors.lightBlueAccent,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            offset: new Offset(0.0, 6.0),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 50),
          ),
        ),
      ),
    );

    return InkWell(
      onTap: pressed,
      child: new Container(
          height: 60.0,
          margin: const EdgeInsets.symmetric(
            vertical: 12.0,
          ),
          child: new Stack(
            children: <Widget>[
              planetCard,
              planetThumbnail,
            ],
          )),
    );
  }

  Widget languageRaw() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: InkWell(
            onTap: () {
              setState(() {
                lang = 'ru';
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(48)),
                  boxShadow: [
                    BoxShadow(
                        color:
                            lang == 'ru' ? Colors.black26 : Colors.transparent,
                        blurRadius: 10.0,
                        offset: Offset(0, 0.0))
                  ]),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: lang == 'ru' ? 1 : 0.4,
                child: Image(
                  image: AssetImage('images/ru_flag.png'),
                  width: 48,
                  height: 48,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: InkWell(
            onTap: () {
              setState(() {
                lang = 'en';
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(48)),
                  boxShadow: [
                    BoxShadow(
                        color:
                            lang == 'en' ? Colors.black26 : Colors.transparent,
                        blurRadius: 10.0,
                        offset: Offset(0, 0.0))
                  ]),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: lang == 'en' ? 1 : 0.4,
                child: Image(
                  image: AssetImage('images/uk_flag.png'),
                  width: 48,
                  height: 48,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
