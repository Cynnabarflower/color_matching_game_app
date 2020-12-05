import 'BalloonsGame.dart';

class Stats {
  var colors = [];
  List<Answer> answers = [];
  int correct = 0;
  int total = 0;

  void add(Answer answer) {
    if (answers.isNotEmpty) {
      if (answers.last.step != answer.step && answer.correct != ANSWER.NO) {
        total++;
        if (answer.answer == answer.correct)
          correct++;
      }
    }
    answers.add(answer);
  }

  @override
  String toString() {
    var s = '';
    var prevStep = 0;
    for (var a in answers) {
      if (a.step != prevStep)
        s += '\n';
      s += a.answer.toString().replaceAll('ANSWER.', '') + '-' + (a.answer == a.correct).toString() + '-' + a.time.toString();
    }
    return s;
  }

}

class Answer {
  ANSWER answer;
  ANSWER correct;
  int step;
  int time;

  Answer(this.step, this.correct, this.answer, this.time);
}