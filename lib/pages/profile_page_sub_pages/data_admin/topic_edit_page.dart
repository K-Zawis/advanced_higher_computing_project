import 'package:flutter/material.dart';

class TopicEditPage extends StatefulWidget {
  const TopicEditPage({Key? key}) : super(key: key);

  @override
  _TopicEditPageState createState() => _TopicEditPageState();
}

class _TopicEditPageState extends State<TopicEditPage> {
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
          child: Text('Topic'),
        ),
      ),
    );
  }
}