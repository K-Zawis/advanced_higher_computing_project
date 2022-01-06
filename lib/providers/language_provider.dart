import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learn_languages/models/langauge_model.dart';

class Languages extends ChangeNotifier {
  final _languages = FirebaseFirestore.instance.collection("language");
  var _language = '';

  final Map<String, Language> items = {};
  Language? currentLanguage;

  Languages() {
    _listenToData();
  }

  _listenToData() async {
    _languages.snapshots().listen((snap) {
      {
        snap.docChanges.forEach((change) {
          switch (change.type) {
            case (DocumentChangeType.added):
              {
                print("added: " + change.doc.data().toString());
                items.putIfAbsent(change.doc.id, () => Language.fromFirestore(change.doc, change.doc.id));
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
                items.update(change.doc.id, (value) => Language.fromFirestore(change.doc, change.doc.id));
                break;
              }
          }
        });
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
    return _languages.doc(id).delete();
  }

  Future<DocumentReference> addDocument(Map data) {
    return _languages.add(data as Map<String, dynamic>);
  }

  Future<void> updateDocument(Map data, String id) {
    return _languages.doc(id).update(data as Map<String, dynamic>);
  }

  void setLanguage (String val) {
    _language = val;
    notifyListeners();
  }

  String getLanguage () {
    return _language;
  }

  List<DropdownMenuItem<String>> getDropdownItems(context) {
    return items.values
        .map(
          (item) => DropdownMenuItem<String>(
            value: item.id,
            child: Text(
              item.ISOcode,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        )
        .toList();
  }
}
