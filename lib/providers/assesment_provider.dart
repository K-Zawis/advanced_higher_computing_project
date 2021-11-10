import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../models/question_model.dart';

class AssessmentProvider extends ChangeNotifier {
  bool _complete = false;
  final Map<dynamic, List<dynamic>> _usedQuestions = {};
  int? _index = null;
  Map<String, List<Question>>? _topicMap;
  String _question = '';

  AssessmentProvider();

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

  void resetIndex() {
    print('resetting');
    _index = Random().nextInt(1);
    print(_index);
  }
}
