import 'package:flutter/material.dart';

import '../constants.dart';

class PracticeMode extends StatefulWidget {
  const PracticeMode({Key? key}) : super(key: key);

  @override
  _PracticeModeState createState() => _PracticeModeState();
}

class _PracticeModeState extends State<PracticeMode> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        selectPage(context, 'Home Page', '');
        return true;
      },
      child: Container(),
    );
  }
}
