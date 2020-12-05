import 'dart:math';

import 'package:color_matching_game/BalloonsGame.dart';
import 'package:color_matching_game/ClownGame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'RobotGame.dart';
import 'menu.dart';

class HowManyLevels extends StatefulWidget {

  var game;

  HowManyLevels(this.game);

  @override
  State<StatefulWidget> createState() => _HowManyLevelsState();
}

class _HowManyLevelsState extends State<HowManyLevels> {
  var _currentHorizontalIntValue = 5;
  int levels = 5;
  List<dynamic> colors = [
    Colors.green,
    Colors.blue,
    Colors.red[600],
    Colors.amberAccent,
    Colors.orange[600],
    Colors.brown[600],
    Colors.deepPurple[600],
    Colors.purpleAccent[100],
    Colors.grey[600],
    Colors.cyanAccent[200],
  ];

  Widget builder(context) {
    print(levels);
    var choosed = colors.where((element) => element[1]).map((e) => e[0]).toList();
    if (widget.game == GAMES.BALLOONS) {
      return BalloonsGame(choosed, levels: levels,);
    } else if (widget.game == GAMES.ROBOT) {
      return RobotsGame(choosed, levels: levels);
    } else if (widget.game == GAMES.CLOWN) {
      return ClownsGame(choosed, levels: levels);
    }
  }

  @override
  void initState() {

    if (widget.game != GAMES.ROBOT) {
      colors.remove(Colors.cyanAccent[200]);
    }

    colors = colors.map((e) => [e, true]).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;

    levels = min(max(levels, 1), 10);

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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        lang == 'ru' ? 'Сколько уровней?' : 'How many levels?',
                                        style: TextStyle(
                                            color: Colors.lightBlue,
                                            fontSize: 50,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: InkWell(
                                            onTap: levels < 2 ? null : () {
                                              setState(() {
                                                if (levels > 1)
                                                  --levels;
                                              });
                                            },
                                            child: Icon(
                                              Icons.keyboard_arrow_left,
                                              color: levels < 2 ? Colors.grey : Colors.lightBlueAccent,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Text(
                                            levels.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 40, color: Colors.lightBlue),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: InkWell(
                                            onTap: levels > 9 ? null : () {
                                              setState(() {
                                                ++levels;
                                              });
                                            },
                                            child: Icon(
                                              Icons.keyboard_arrow_right,
                                              color: levels > 9 ? Colors.grey : Colors.lightBlueAccent,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 16.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          lang == 'ru' ?
                                          'Возможные цвета:' :
                                          'Possible colors',
                                          style: TextStyle(
                                              color: Colors.lightBlue,
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GridView.count(
                                      childAspectRatio: 1,
                                      shrinkWrap: true,
                                      crossAxisCount: 4,
                                      children: colors.map((e) {
                                        return Container(
                                          margin: EdgeInsets.all(1.5),
                                          decoration: BoxDecoration(
                                              color: e[0],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        widget.game == GAMES.ROBOT ? (lang == 'ru' ?
                                        'Голова и \'металлические\' части всегда одного цвета' :
                                        'Head and \'metal\' parts are always the same color') : ' ',
                                        style: TextStyle(
                                            color: Colors.lightBlue,
                                            fontSize: 50,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: MaterialButton(
                                      onPressed: () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Menu()),
                                      ),
                                      color: Colors.lightBlueAccent,
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: MaterialButton(
                                      onPressed: (colors.where((e) => e[1]).length < 2 + levels~/2) ? null : () {
                                        Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: builder),
                                      );},
                                      disabledColor: Colors.grey,
                                      color: Colors.lightBlueAccent,
                                      child: Text(
                                        lang == 'ru' ? 'Поехали' : 'Start',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
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
