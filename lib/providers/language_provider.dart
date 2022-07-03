import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_languages/models/langauge_model.dart';

class Languages extends StateNotifier<Map<String, Language>> {
  final _languages = FirebaseFirestore.instance.collection("language");
  final Map<String, Language> items = {};

  Languages() : super({}) {
    _listenToData();
  }

  _listenToData() async {
    _languages.snapshots().listen((snap) {
      {
        for (var change in snap.docChanges) {
          switch (change.type) {
            case (DocumentChangeType.added):
              {
                items.putIfAbsent(change.doc.id, () => Language.fromFirestore(change.doc, change.doc.id));
                break;
              }
            case (DocumentChangeType.removed):
              {
                items.remove(change.doc.id);
                break;
              }
            case (DocumentChangeType.modified):
              {
                items.update(change.doc.id, (value) => Language.fromFirestore(change.doc, change.doc.id));
                break;
              }
          }
        }
        state = Map.from(items);
      }
    });
  }

  // * Firebase 
  Future<void> removeDocument(String id) {
    FirebaseFirestore.instance.collection('topic').where('language', isEqualTo: id).get().then(
          (topics) => topics.docs.forEach(
            (doc) {
              FirebaseFirestore.instance.collection('questions').where('topic', isEqualTo: doc.id).get().then(
                    (questions) => questions.docs.forEach(
                      (doc2) {
                        FirebaseFirestore.instance.collection('questions').doc(doc2.id).delete();
                      },
                    ),
                  );
              FirebaseFirestore.instance.collection('topic').doc(doc.id).delete();
            },
          ),
        );
    return _languages.doc(id).delete();
  }

  Future<DocumentReference> addDocument(Map data) {
    return _languages.add(data as Map<String, dynamic>);
  }

  Future<void> updateDocument(Map data, String id) {
    return _languages.doc(id).update(data as Map<String, dynamic>);
  }

  // * Other
  List<DropdownMenuItem<String>> getDropdownItems(context) {
    return items.values
        .map(
          (item) => DropdownMenuItem<String>(
            value: item.id,
            child: Text(
              item.language,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        )
        .toList();
  }
}

class Languages2 extends ChangeNotifier {
  final _languages = FirebaseFirestore.instance.collection("language");
  var _language = '';

  final Map<String, Language> items = {};
  Language? currentLanguage;

  Languages2() {
    _listenToData();
  }

  _listenToData() async {
    _languages.snapshots().listen((snap) {
      {
        for (var change in snap.docChanges) {
          switch (change.type) {
            case (DocumentChangeType.added):
              {
                items.putIfAbsent(change.doc.id, () => Language.fromFirestore(change.doc, change.doc.id));
                break;
              }
            case (DocumentChangeType.removed):
              {
                items.remove(change.doc.id);
                break;
              }
            case (DocumentChangeType.modified):
              {
                items.update(change.doc.id, (value) => Language.fromFirestore(change.doc, change.doc.id));
                break;
              }
          }
        }
        notifyListeners();
      }
    });
  }

  void setCurrentLanguage(Language? language) {
    currentLanguage = language;
    notifyListeners();
  }

  Future<Language> getDocumentById(String id) async {
    var doc = await _languages.doc(id).get();
    return Language.fromFirestore(doc, doc.id);
  }

  Future<void> removeDocument(String id) {
    currentLanguage = null;
    _language = '';
    FirebaseFirestore.instance.collection('topic').where('language', isEqualTo: id).get().then(
          (topics) => topics.docs.forEach(
            (doc) {
              FirebaseFirestore.instance.collection('questions').where('topic', isEqualTo: doc.id).get().then(
                    (questions) => questions.docs.forEach(
                      (doc2) {
                        FirebaseFirestore.instance.collection('questions').doc(doc2.id).delete();
                      },
                    ),
                  );
              FirebaseFirestore.instance.collection('topic').doc(doc.id).delete();
            },
          ),
        );
    return _languages.doc(id).delete();
  }

  Future<DocumentReference> addDocument(Map data) {
    return _languages.add(data as Map<String, dynamic>);
  }

  Future<void> updateDocument(Map data, String id) {
    return _languages.doc(id).update(data as Map<String, dynamic>);
  }

  void setLanguage(String val) {
    _language = val;
    notifyListeners();
  }

  String getLanguage() {
    return _language;
  }

  List<DropdownMenuItem<String>> getDropdownItems(context) {
    return items.values
        .map(
          (item) => DropdownMenuItem<String>(
            value: item.id,
            child: Text(
              item.language,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        )
        .toList();
  }
}
