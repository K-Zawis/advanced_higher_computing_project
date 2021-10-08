import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String question;
  final String topic;
  final String id;

  const Question({
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
}
