import 'package:flutter/material.dart';

class QuestionEditPage extends StatefulWidget {
  const QuestionEditPage({Key? key}) : super(key: key);

  @override
  _QuestionEditPageState createState() => _QuestionEditPageState();
}

class _QuestionEditPageState extends State<QuestionEditPage> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 850,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          clipBehavior: Clip.hardEdge,
          child: Text('Question'),
        ),
      ),
    );
  }
}