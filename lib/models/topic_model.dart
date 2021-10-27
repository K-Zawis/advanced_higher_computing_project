import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  final String id;
  final List level;
  final String language;
  final String name;

  Topic({
    required this.id,
    required this.level,
    required this.language,
    required this.name,
  });

  factory Topic.fromFirestore(DocumentSnapshot doc, id) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Topic(
      id: id,
      level: data['qualification']?? [],
      language: data['language']?? '',
      name: data['topic']?? '',
    );
  }
}
