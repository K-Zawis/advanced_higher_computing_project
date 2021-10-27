import 'package:flutter/material.dart';

import '../widget_tree.dart';

class PracticeMode extends StatefulWidget {
  const PracticeMode({Key? key}) : super(key: key);

  @override
  _PracticeModeState createState() => _PracticeModeState();
}

class _PracticeModeState extends State<PracticeMode> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
      icon: const Icon(
        Icons.home_filled,
        color: Colors.white,
        size: 25,
      ),
      onPressed: () {
        selectPage(context, 'Home Page');
      },
    );
  }
}
