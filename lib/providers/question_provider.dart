import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/question_model.dart';

class Questions extends ChangeNotifier {
  final _questions = FirebaseFirestore.instance.collection("questions");
  // https://stackoverflow.com/questions/63884633/unhandled-exception-a-changenotifier-was-used-after-being-disposed
  bool _disposed = false;

  final Map<String, Question> items = {};
  bool _visible = false;

  Questions(topics) {
    _listenToData(topics);
  }

  _listenToData(topics) async {
    if (topics != null) {
      var temp = await topics;
      var topicIds = temp.values.toList();
      if (topicIds.isNotEmpty) {
        try {
          _questions.where('topic', whereIn: topicIds.isEmpty ? ['null'] : topicIds).snapshots().listen((snap) {
            {
              snap.docChanges.forEach((change) {
                switch (change.type) {
                  case (DocumentChangeType.added):
                    {
                      print("added: " + change.doc.data().toString());
                      items.putIfAbsent(change.doc.id, () => Question.fromFirestore(change.doc));
                      break;
                    }
                  case (DocumentChangeType.removed):
                    {
                      print("removed: " + change.doc.data().toString());
                      items.remove(change.doc.id);
                      break;
                    }
                  case (DocumentChangeType.modified):
                    {
                      print("modified: " + change.doc.data().toString());
                      items.update(change.doc.id, (value) => Question.fromFirestore(change.doc));
                      break;
                    }
                }
              });
              notifyListeners();
            }
          });
        } catch (e) {}
      }
    } else {
      try {
        _questions.snapshots().listen((snap) {
          {
            snap.docChanges.forEach((change) {
              switch (change.type) {
                case (DocumentChangeType.added):
                  {
                    items.putIfAbsent(change.doc.id, () => Question.fromFirestore(change.doc));
                    break;
                  }
                case (DocumentChangeType.removed):
                  {
                    items.remove(change.doc.id);
                    break;
                  }
                case (DocumentChangeType.modified):
                  {
                    items.update(change.doc.id, (value) => Question.fromFirestore(change.doc));
                    break;
                  }
              }
            });
            notifyListeners();
          }
        });
      } catch (e) {}
    }
  }

  Map<String, List<Question>> getAssignmentLists() {
    final Map<String, List<Question>> out = {};
    List<Question> topic1 = [];
    List<Question> topic2 = [];
    Question? _question;

    if (items.isEmpty) {
      return {};
    }

    items.values.forEach((question) {
      // print(question.topic);
      if (_question == null) {
        _question = question;
        topic1.add(question);
      } else {
        if (question.topic == _question!.topic) {
          topic1.add(question);
        } else {
          topic2.add(question);
        }
      }
    });
    print(topic2);
    if (topic1.isNotEmpty) {
      out.putIfAbsent(topic1[0].topic, () => topic1);
    }
    if (topic2.isNotEmpty) {
      out.putIfAbsent(topic2[0].topic, () => topic2);
    }
    return out;
  }

  void setVisible(bool val){
    _visible = val;
    notifyListeners();
  }

  bool getVisible(){
    return _visible;
  }

  Future<void> removeDocument(String id) {
    return _questions.doc(id).delete();
  }

  Future<DocumentReference> addDocument(Map data) {
    return _questions.add(data as Map<String, dynamic>);
  }

  Future<void> updateDocument(Map data, String id) {
    return _questions.doc(id).update(data as Map<String, dynamic>);
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}