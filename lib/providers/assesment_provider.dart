import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../models/question_model.dart';

class AssessmentProvider extends ChangeNotifier {
  bool _complete = false;
  bool _shuffled = false;
  final Map<dynamic, List<dynamic>> _usedQuestions = {};
  int _index = Random().nextInt(1);
  final Map<String, List<Question>>? _topicMap;
  List<Question> _topic1 = [];
  List<Question> _topic2 = [];
  String _question = '';
  String _id = '';
  // statistics
  final Map<dynamic, dynamic> _skipped = {};
  final Map<dynamic, dynamic> _played = {};

  AssessmentProvider(this._topicMap) {
    if (_topicMap?.isNotEmpty ?? false) {
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

  Map getPlayed() {
    return _played;
  }

  void setPlayed() {
    _played.update(_id, (value) => value + 1, ifAbsent: () => 1);
    notifyListeners();
  }

  Map getSkipped() {
    return _skipped;
  }

  void setSkipped() {
    _skipped.putIfAbsent(_id, () => _question);
  }

  String getQuestion() {
    return _question;
  }

  void nextQuestion(List<Question> topic, bool initial) {
    Random rnd = Random();
    _question = '';
    int? index;
    if (topic.isNotEmpty) {
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
      _id = topic[index].id;
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
    _index = Random().nextInt(1);
    _usedQuestions.clear();
    _topicMap?.clear();
    _complete = false;
    _shuffled = false;
    _question = '';
    _topic2.shuffle();
    _topic1.shuffle();
  }
}
