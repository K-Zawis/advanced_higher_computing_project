import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants.dart';

enum Page { screenQuestions, screenAnalytics }

extension on Page {
  String get route => describeEnum(this);
}

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (navigatorKey.currentState!.canPop()) {
          navigatorKey.currentState?.pop();
          return false;
        }
        return true;
      },
      child: Row(
        children: [
          Container(
            color: Theme.of(context).canvasColor,
            width: 70,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.account_circle_outlined,
                      color: iconColour,
                      size: 40,
                    ),
                    tooltip: 'Profile',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => navigatorKey.currentState!.pushNamed(Page.screenQuestions.route),
                    icon: const Icon(
                      Icons.chat_outlined,
                      color: iconColour,
                      size: 40,
                    ),
                    tooltip: 'Questions',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => navigatorKey.currentState!.pushNamed(Page.screenAnalytics.route),
                    icon: const Icon(
                      Icons.analytics_outlined,
                      color: iconColour,
                      size: 40,
                    ),
                    tooltip: 'Analytics',
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.home_filled,
                      color: Colors.white,
                      size: 40,
                    ),
                    tooltip: 'Home',
                    onPressed: () {
                      selectPage(ref, context, 'Home Page');
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Navigator(
              key: navigatorKey,
              initialRoute: Page.screenQuestions.route,
              onGenerateRoute: (settings) {
                final pageName = settings.name;

                final page = fragments.keys.firstWhere((element) => describeEnum(element) == pageName);

                return MaterialPageRoute(settings: settings, builder: (context) => fragments[page]!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
