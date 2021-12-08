import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

enum Page { screenQuestions, screenAnalytics }

extension on Page {
  String get route => describeEnum(this);
}

class ProfilePageDesktop extends StatefulWidget {
  const ProfilePageDesktop({Key? key}) : super(key: key);

  @override
  _ProfilePageDesktopState createState() => _ProfilePageDesktopState();
}

class _ProfilePageDesktopState extends State<ProfilePageDesktop> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: Page.screenQuestions.route,
      onGenerateRoute: (settings) {
        final pageName = settings.name;

        final page = fragments.keys.firstWhere((element) => describeEnum(element) == pageName);

        return MaterialPageRoute(settings: settings, builder: (context) => fragments[page]!);
      },
    );
  }
}