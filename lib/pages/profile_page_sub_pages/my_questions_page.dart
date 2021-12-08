import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyQuestionsPage extends StatefulWidget {
  const MyQuestionsPage({Key? key}) : super(key: key);

  @override
  _MyQuestionsPageState createState() => _MyQuestionsPageState();
}

class _MyQuestionsPageState extends State<MyQuestionsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Text('Questions');
      }
    );
  }
}