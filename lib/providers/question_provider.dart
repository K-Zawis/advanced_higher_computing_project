import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/question_model.dart';

class Questions extends ChangeNotifier {
  final _questions = FirebaseFirestore.instance.collection("questions");

  final Map<String, Question> items = {};
  bool _visible = false;

  Questions(topics) {
    _listenToData(topics);
  }

  _listenToData(topics) async {
    var topicIds = await topics;
    _questions.where('topic', whereIn: topicIds.values.toList()).snapshots().listen((snap) {
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
}