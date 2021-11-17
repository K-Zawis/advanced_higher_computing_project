import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String question;
  final String topic;
  final String id;
  bool skipped;
  int played;


  Question({
    this.played = 0,
    this.skipped = false,
    required this.question,
    required this.topic,
    required this.id,
  });

  factory Question.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Question(
      question: data['question'] ?? '',
      topic: data['topic'] ?? '',
      id: doc.id,
    );
  }

  void increasePlayed() {
    played += 1;
  }

  void setSkipped(bool value) {
    skipped = value;
  }

  void reset() {
    played = 0;
    skipped = false;
  }
}
