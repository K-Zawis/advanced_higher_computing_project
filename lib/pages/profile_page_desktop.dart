import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';

enum Page { screenQuestions, screenAnalytics, manageUsers, editUser, language, topic, question, level }

extension on Page {
  String get route => describeEnum(this);
}

class ProfilePageDesktop extends ConsumerStatefulWidget {
  const ProfilePageDesktop({Key? key}) : super(key: key);

  @override
  _ProfilePageDesktopState createState() => _ProfilePageDesktopState();
}

class _ProfilePageDesktopState extends ConsumerState<ProfilePageDesktop> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: ref.read(userStateProvider)!.isAdmin ? Page.manageUsers.route : Page.screenQuestions.route,
      onGenerateRoute: (settings) {
        final pageName = settings.name;

        final page = fragments.keys.firstWhere((element) => describeEnum(element) == pageName);

        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, _, __) => fragments[page]!,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.fastLinearToSlowEaseIn;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: child,
              ),
            );
          },
        );
      },
    );
  }
}
