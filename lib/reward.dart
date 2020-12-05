import 'dart:convert';

import 'package:color_matching_game/BalloonsGame.dart';
import 'package:color_matching_game/stats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'menu.dart';

class Reward extends StatelessWidget {

  Stats stats;
  Map<String, double> dataMap = Map();
  List<Color> colorList;

  Reward(this.stats) {
    colorList = [
      Colors.green[600],
      Colors.redAccent[200],
      Colors.yellow[400]
    ];
    dataMap.putIfAbsent('OK', () => stats.correct.toDouble());
    dataMap.putIfAbsent('NOT OK', () => stats.answers.where((e) => e.answer != e.correct && e.answer != ANSWER.NO ).length.toDouble());
    dataMap.putIfAbsent(lang == 'ru' ? 'Пропущенно' : 'Missed', () => stats.answers.where((e) =>  e.answer == ANSWER.NO && e.answer != e.correct ).length.toDouble());
  }



  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;

    if (s.width < MIN_WIDTH || s.height < MIN_HEIGHT) {
      return smallScreen();
    }

    var sluchai;
    if (stats.correct % 10 == 1) {
      sluchai = 'случае';
    } else {
      sluchai = 'случаях';
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
                                        lang == 'ru' ? 'Поздравляем!' : 'Congratulations!',
                                        style: TextStyle(
                                            color: Colors.lightBlue,
                                            fontSize: 50,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Container(
                                        child: Text(
                                          lang == 'ru' ?
                                          (
                                              stats.correct == 0 ? "Шарик, ты балбес" :
                                              'Вы правильно ответили в ${stats.correct} ${sluchai} из ${stats.total}')
                                              :
                                              'You got ${stats.correct} out of ${stats.total}'
                                        ),
                                      ),
                                    ),
                                  ),
                                  PieChart(
                                    dataMap: dataMap,
                                    animationDuration: Duration(milliseconds: 1500),
                                    chartLegendSpacing: 32.0,
                                    chartRadius: constrains.maxWidth * 0.8,
                                    showChartValuesInPercentage: false,
                                    showChartValues: true,
                                    showChartValuesOutside: false,
                                    chartValueBackgroundColor: Colors.transparent,
                                    colorList: colorList,
                                    showLegends: true,
                                    legendPosition: LegendPosition.bottom,
                                    decimalPlaces: 0,
                                    showChartValueLabel: true,
                                    initialAngle: 20,
                                    chartValueStyle: defaultChartValueStyle.copyWith(
                                      color: Colors.blueGrey[900].withOpacity(0.9),
                                    ),
                                    chartType: ChartType.disc,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: MaterialButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (c) => Menu()),
                                        );},
                                      disabledColor: Colors.grey,
                                      color: Colors.lightBlueAccent,
                                      child: Text(
                                        lang == 'ru' ? 'В меню' : 'Back to menu',
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