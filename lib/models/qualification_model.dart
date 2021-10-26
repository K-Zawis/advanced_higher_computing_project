import 'package:cloud_firestore/cloud_firestore.dart';

class Qualification {
  final String id;
  final String level;

  Qualification({required this.id, required this.level});

  factory Qualification.fromFirestore(DocumentSnapshot doc, id) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Qualification(
      id: id,
      level: data['level']?? '',
    );
  }
}