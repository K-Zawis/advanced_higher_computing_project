import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../models/question_model.dart';

class AssessmentProvider extends ChangeNotifier {
  bool _complete = false;
  bool _shuffled = false;
  final Map<dynamic, List<Question>> _usedQuestions = {};
  int _index = Random().nextInt(1);
  final Map<String, List<Question>>? _topicMap;
  List<Question> _topic1 = [];
  List<Question> _topic2 = [];
  Question? _question;

  AssessmentProvider(this._topicMap) {
    print(_topicMap);
    if (_topicMap!.isNotEmpty) {
      _topic1 = _topicMap?.values.toList()[0] ?? [];
      _topic2 = _topicMap?.values.toList()[1] ?? [];
    }
    _topic2.shuffle();
    _topic1.shuffle();
  }

  bool getShuffledStatus() {
    return _shuffled;
  }

  void setShuffledStatus(val) {
    _shuffled = val;
  }

  List<Question> getTopic() {
    if (!(_usedQuestions[_topic1[0].topic]?.length == _topic1.length &&
        _usedQuestions[_topic2[0].topic]?.length == _topic2.length)) {
      if (_index == 0) {
        if (_usedQuestions[_topic1[0].topic]?.length == _topic1.length) {
          return _topic2;
        } else {
          return _topic1;
        }
      } else {
        if (_usedQuestions[_topic2[0].topic]?.length == _topic2.length) {
          return _topic1;
        } else {
          return _topic2;
        }
      }
    } else {
      setCompleteStatus(true);
      return [];
    }
  }

  bool getCompleteStatus() {
    return _complete;
  }

  void setCompleteStatus(bool val) {
    _complete = val;
    notifyListeners();
  }

  Map<dynamic, List<Question>> getUsedQuestions() {
    return _usedQuestions;
  }

  void setUsedQuestions(key, Question val) {
    _usedQuestions.update(
      key,
      (list) => list..add(val),
      ifAbsent: () => [val],
    );
  }

  void setPlayed() {
    _question!.increasePlayed();
    notifyListeners();
  }

  // * insert sort
  List<Question> getSortedPlayed() {
    // initially
    List<Question> sorted = [];
    for (var value in _usedQuestions.values) {
      for (var element in value) {
        sorted.add(element);
      }
    }
    var value;
    var index = 0;
    for (var i = 1; i <= sorted.length - 1; i++) {
      value = sorted[i];
      index = i;
      while (index > 0 && value.played > sorted[index - 1].played) {
        sorted[index] = sorted[index - 1];
        index = index - 1;
      }
      sorted[index] = value;
    }

    return sorted;
  }

  List getSkipped() {
    List out = [];
    print(_topicMap!.values);
    for (var element in _topicMap!.values) {
      for (var question in element) {
        print('value: ${question.skipped}');
        if (question.skipped) {
          out.add(question);
        }
      }
      print(out);
    }
    return out;
  }

  void setSkipped() {
    _question!.setSkipped(true);
    print('set: ${_question!.skipped}');
    notifyListeners();
  }

  Question? getQuestion() {
    return _question;
  }

  void nextQuestion(List<Question> topic, bool initial) {
    Random rnd = Random();
    _question = null;
    int? index;
    if (topic.isNotEmpty) {
      while (_question == null) {
        index = rnd.nextInt(topic.length);
        if (_usedQuestions[topic[index].topic] != null) {
          if (!_usedQuestions[topic[index].topic]!.contains(topic[index])) {
            _question = topic[index];
          }
        } else {
          _question = topic[index];
        }
      }
      setUsedQuestions(topic[index!].topic, topic[index]);
      if (!initial) {
        notifyListeners();
      }
    }
  }

  void setIndex() {
    _index = Random().nextInt(1);
  }

  int getIndex() {
    return _index;
  }

  void reset() {
    print('resetting');
    for (var topic in _topicMap!.values) {
      topic.forEach((element) {
        element.played = 0;
        element.skipped = false;
      });
    }
    _index = Random().nextInt(1);
    _usedQuestions.clear();
    _complete = false;
    _shuffled = false;
    _question = null;
    _topic2.shuffle();
    _topic1.shuffle();
  }
}
