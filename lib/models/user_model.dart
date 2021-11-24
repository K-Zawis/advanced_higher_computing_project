import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String uid;
  final String displayName;
  final bool isAdmin;
  final bool filterFavourites;

  MyUser({required this.uid, required this.displayName, required this.isAdmin, required this.filterFavourites});

  factory MyUser.fromFirestore(DocumentSnapshot doc, String id) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MyUser(
      uid: id,
      displayName: data['displayName'] ?? '',
      isAdmin: data['isAdmin'] ?? false,
      filterFavourites: data['filterFavourites']?? false,
    );
  }
}
