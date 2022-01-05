import 'package:cloud_firestore/cloud_firestore.dart';

class Answer {
  final String questionId;
  final String languageId;
  final String levelId;
  final String topicId;
  final String id;
  final String text;


  Answer({
    required this.questionId,
    required this.id,
    required this.text,
    required this.topicId,
    required this.languageId,
    required this.levelId,
  });

  factory Answer.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Answer(
      questionId: data['questionId'] ?? '',
      topicId: data['topicId'] ?? '',
      languageId: data['languageId'] ?? '',
      levelId:  data['levelId'] ?? '',
      id: doc.id,
      text: doc['answer']?? '',
    );
  }
}