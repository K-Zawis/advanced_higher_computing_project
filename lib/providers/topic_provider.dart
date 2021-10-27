import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:learn_languages/models/topic_model.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class Topics extends ChangeNotifier {
  final languages = FirebaseFirestore.instance.collection("topic");

  final Map<String, Topic> items = {};
  var _selectedTopics = [];

  Topics(lan, level) {
    _listenToData(lan, level);
  }

  _listenToData(lan, level) async {
    try {
      languages.where('qualification', arrayContains: level).where('language', isEqualTo: lan).snapshots().listen((snap) {
        {
          snap.docChanges.forEach((change) {
            switch (change.type) {
              case (DocumentChangeType.added):
                {
                  print("added: " + change.doc.data().toString());
                  items.putIfAbsent(change.doc.id, () => Topic.fromFirestore(change.doc, change.doc.id));
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
                  items.update(change.doc.id, (value) => Topic.fromFirestore(change.doc, change.doc.id));
                  break;
                }
            }
          });
          notifyListeners();
        }
      });
    } catch (e){}
  }

  Future<void> removeDocument(String id) {
    return languages.doc(id).delete();
  }

  Future<DocumentReference> addDocument(Map data) {
    return languages.add(data as Map<String, dynamic>);
  }

  Future<void> updateDocument(Map data, String id) {
    return languages.doc(id).update(data as Map<String, dynamic>);
  }

  List<dynamic> getTopics() {
    return _selectedTopics;
  }

  void setTopics(values) {
    _selectedTopics = values;
    notifyListeners();
  }

  List<MultiSelectItem<dynamic>> getMultiSelectItems() {
    return items.values.toList().map(
          (e) => MultiSelectItem(e.name, e.name),
    )
        .toList();
  }
}