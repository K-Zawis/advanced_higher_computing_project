import 'package:flutter/material.dart';

class LanguageEditPage extends StatefulWidget {
  const LanguageEditPage({Key? key}) : super(key: key);

  @override
  _LanguageEditPageState createState() => _LanguageEditPageState();
}

class _LanguageEditPageState extends State<LanguageEditPage> {
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
          child: Text('Language'),
        ),
      ),
    );
  }
}