import 'package:flutter/material.dart';

class LevelEditPage extends StatefulWidget {
  const LevelEditPage({Key? key}) : super(key: key);

  @override
  _LevelEditPageState createState() => _LevelEditPageState();
}

class _LevelEditPageState extends State<LevelEditPage> {
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
          child: Text('Level'),
        ),
      ),
    );
  }
}