import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:learn_languages/models/topic_model.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class Topics extends ChangeNotifier {
  final _topics = FirebaseFirestore.instance.collection("topic");
  // https://stackoverflow.com/questions/63884633/unhandled-exception-a-changenotifier-was-used-after-being-disposed
  bool _disposed = false;

  final Map<String, Topic> items = {};
  Topic? currentTopic;
  List? _selectedTopics = [];
  Map<String, String> _topicIds = {};

  Topics(lan, level) {
    _listenToData(lan, level);
  }

  _listenToData(lan, level) async {
    try {
      _topics.where('qualification', arrayContains: level).where('language', isEqualTo: lan).snapshots().listen((snap) {
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
    } catch (e) {}
  }

  void setCurrentTopic(Topic? topic) {
    currentTopic = topic;
    notifyListeners();
  }

  Future<void> removeDocument(String id) {
    FirebaseFirestore.instance.collection("questions").where('topic', isEqualTo: id).get().then(
          (questions) => questions.docs.forEach(
            (doc) {
              FirebaseFirestore.instance.collection("questions").doc(doc.id).delete();
            },
          ),
        );
    return _topics.doc(id).delete();
  }

  Future<DocumentReference> addDocument(Map data) {
    return _topics.add(data as Map<String, dynamic>);
  }

  Future<void> updateDocument(Map data, String id) {
    return _topics.doc(id).update(data as Map<String, dynamic>);
  }

  List<dynamic>? getTopics() {
    return _selectedTopics;
  }

  void setTopics(values) {
    _selectedTopics = values;
    notifyListeners();
  }

  Future<Map<String, String>> getTopicIds() async {
    _topicIds = {};
    if (items.isEmpty || _selectedTopics!.isEmpty) {
      return _topicIds;
    }
    var ids = await _topics.where('topic', whereIn: _selectedTopics).get();
    ids.docs.forEach((element) {
      _topicIds.putIfAbsent(element.id, () => element.id);
    });
    return _topicIds;
  }

  List<MultiSelectItem<dynamic>> getMultiSelectItems() {
    return items.values
        .toList()
        .map(
          (e) => MultiSelectItem(e.name, e.name),
        )
        .toList();
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
