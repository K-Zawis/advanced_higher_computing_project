import 'package:cloud_firestore/cloud_firestore.dart';

class Answer {
  final String questionId;
  final String id;
  final String text;


  Answer({
    required this.questionId,
    required this.id,
    required this.text,
  });

  factory Answer.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Answer(
      questionId: data['questionId'] ?? '',
      id: doc.id,
      text: doc['answer']?? '',
    );
  }
}