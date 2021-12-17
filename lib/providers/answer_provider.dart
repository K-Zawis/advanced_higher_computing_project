import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:learn_languages/models/answer_model.dart';


class Answers extends ChangeNotifier {
  final _questions = FirebaseFirestore.instance.collection("users");
  // https://stackoverflow.com/questions/63884633/unhandled-exception-a-changenotifier-was-used-after-being-disposed
  bool _disposed = false;

  final Map<String, Answer> items = {};

  Answers(uid) {
    _listenToData(uid);
  }

  _listenToData(uid) async {
    if (uid.isNotEmpty) {
      try {
        _questions.doc(uid).collection('answers').snapshots().listen((snap) {
          {
            snap.docChanges.forEach((change) {
              switch (change.type) {
                case (DocumentChangeType.added):
                  {
                    print("added: " + change.doc.data().toString());
                    items.putIfAbsent(change.doc.id, () => Answer.fromFirestore(change.doc));
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
                    items.update(change.doc.id, (value) => Answer.fromFirestore(change.doc));
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


  Future<void> removeDocument(String id, uid) {
    return _questions.doc(uid).collection('answers').doc(id).delete();
  }

  Future<DocumentReference> addDocument(Map data, uid) {
    return _questions.doc(uid).collection('answers').add(data as Map<String, dynamic>);
  }

  Future<void> updateDocument(Map data, String id, uid) {
    return _questions.doc(uid).collection('answers').doc(id).update(data as Map<String, dynamic>);
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