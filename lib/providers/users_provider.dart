import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/user_model.dart';

class Users extends ChangeNotifier {
  final languages = FirebaseFirestore.instance.collection("users");

  final Map<String, MyUser> items = {};

  Users() {
    _listenToData();
  }

  _listenToData() async {
    languages.orderBy('email').snapshots().listen((snap) {
      {
        for (var change in snap.docChanges) {
          switch (change.type) {
            case (DocumentChangeType.added):
              {
                print("added: " + change.doc.data().toString());
                items.putIfAbsent(change.doc.id, () => MyUser.fromFirestore(change.doc, change.doc.id));
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
                items.update(change.doc.id, (value) => MyUser.fromFirestore(change.doc, change.doc.id));
                break;
              }
          }
        }
        notifyListeners();
      }
    });
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
}