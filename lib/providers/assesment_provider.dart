import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../models/question_model.dart';

class AssessmentProvider extends ChangeNotifier {
  bool _complete = false;
  bool _shuffled = false;
  final Map<dynamic, List<dynamic>> _usedQuestions = {};
  int _index = Random().nextInt(1);
  Map<String, List<Question>>? _topicMap;
  String _question = '';

  AssessmentProvider();

  bool getShuffledStatus() {
    return _shuffled;
  }

  void setShuffledStatus(val) {
    _shuffled = val;
  }

  bool getCompleteStatus() {
    return _complete;
  }

  void setCompleteStatus(bool val) {
    _complete = val;
    notifyListeners();
  }

  Map<dynamic, List<dynamic>> getUsedQuestions() {
    return _usedQuestions;
  }

  void setUsedQuestions(key, val) {
    _usedQuestions.update(
      key,
      (list) => list..add(val),
      ifAbsent: () => [val],
    );
  }

  String getQuestion() {
    return _question;
  }

  void nextQuestion(List<Question> topic) {
    Random rnd = Random();
    _question = '';
    int? index;
    while (_question == '') {
      index = rnd.nextInt(topic.length);
      if (_usedQuestions[topic[index].topic] != null) {
        if (!_usedQuestions[topic[index].topic]!.contains(topic[index].question)) {
          _question = topic[index].question;
        }
      } else {
        _question = topic[index].question;
      }
    }
    setUsedQuestions(topic[index!].topic, topic[index].question);
    notifyListeners();
  }

  void setIndex() {
    _index = Random().nextInt(1);
  }

  int getIndex() {
    return _index ?? 0;
  }

  void reset() {
    print('resetting');
    _index = Random().nextInt(1);
    _usedQuestions.clear();
    _topicMap?.clear();
    _complete = false;
    _shuffled = false;
    _question = '';
  }
}
