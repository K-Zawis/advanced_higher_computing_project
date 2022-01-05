import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String uid;
  final bool isAdmin;
  final String email;

  MyUser({required this.uid, required this.isAdmin, required this.email});

  factory MyUser.fromFirestore(DocumentSnapshot doc, String id) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MyUser(
      uid: id,
      email: data['email'] ?? 'Anonymous',
      isAdmin: data['isAdmin'] ?? false,
    );
  }
}
