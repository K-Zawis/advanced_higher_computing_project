import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learn_languages/constants.dart';
import 'package:learn_languages/models/qualification_model.dart';

class Qualifications extends ChangeNotifier {
  final languages = FirebaseFirestore.instance.collection("qualification");

  final Map<String, Qualification> items = {};
  Qualification? qualification;
  var _level = '';

  Qualifications() {
    _listenToData();
  }

  _listenToData() async {
    languages.snapshots().listen((snap) {
      {
        snap.docChanges.forEach((change) {
          switch (change.type) {
            case (DocumentChangeType.added):
              {
                print("added: " + change.doc.data().toString());
                items.putIfAbsent(change.doc.id, () => Qualification.fromFirestore(change.doc, change.doc.id));
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
                items.update(change.doc.id, (value) => Qualification.fromFirestore(change.doc, change.doc.id));
                break;
              }
          }
        });
        notifyListeners();
      }
    });
  }

  void setQualification(Qualification? level) {
    qualification = level;
    notifyListeners();
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

  void setLevel (String val) {
    _level = val;
    notifyListeners();
  }

  String getLevel () {
    return _level;
  }

  List<DropdownMenuItem<String>> getDropdownItems(context) {
    return items.values
        .map(
          (item) => DropdownMenuItem<String>(
        value: item.id,
        child: Text(
          item.level,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: textColour,
          ),
        ),
      ),
    )
        .toList();
  }
}