import 'package:cloud_firestore/cloud_firestore.dart';

class Language {
  final String id;
  final String language;
  final String ISOcode;
  final List icon;

  Language({
    required this.id,
    required this.language,
    required this.icon,
    required this.ISOcode,
  });

  factory Language.fromFirestore(DocumentSnapshot doc, id) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Language(
      id: id,
      language: data['language']?? '',
      ISOcode: data['ISOLanguageCode']?? '',
      icon: data['icon']?? [],
    );
  }
}
