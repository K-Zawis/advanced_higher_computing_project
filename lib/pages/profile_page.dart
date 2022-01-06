import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_languages/widgets/expanded_animation_widget.dart';

import '/constants.dart';

enum Page { screenQuestions, screenAnalytics, manageUsers, editUser, language, topic, question, level }

extension on Page {
  String get route => describeEnum(this);
}

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final layerLink = LayerLink();
  bool expanded = true;

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
                    onPressed: () {
                      setState(() {
                        expanded = !expanded;
                      });
                    },
                    icon: const Icon(
                      Icons.account_circle_outlined,
                      color: iconColour,
                      size: 40,
                    ),
                    tooltip: 'Profile',
                  ),
                ),
                if (ref.read(userStateProvider).userData.isAdmin)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: const Icon(
                        Icons.menu,
                        color: iconColour,
                        size: 40,
                      ),
                      tooltip: 'Menu',
                    ),
                  )
                else
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
                if (!ref.read(userStateProvider).userData.isAdmin)
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
                  )
                else
                  SizedBox(),
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
            child: Column(
              children: [
                Consumer(builder: (context, ref, child) {
                  var user = ref.watch(userStateProvider);
                  return Align(
                    alignment: Alignment.topCenter,
                    child: CompositedTransformTarget(
                      link: layerLink,
                      child: ExpandedSection(
                        expand: expanded,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: expanded ? MediaQuery.of(context).size.height * 0.3 : 0,
                          width: double.infinity,
                          child: expanded
                              ? CompositedTransformFollower(
                                  link: layerLink,
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 20, right: 40),
                                      constraints: const BoxConstraints(
                                        maxWidth: 850,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.account_circle,
                                            color: Theme.of(context).colorScheme.primary,
                                            size: 150,
                                          ),
                                          Flexible(
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    user.userData.isAdmin ? 'Admin' : 'Student',
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    user.authData.email.substring(0, user.authData.email.indexOf('@')),
                                                    overflow: TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                  );
                }),
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                  height: 2,
                ),
                Expanded(
                  child: Navigator(
                    key: navigatorKey,
                    initialRoute: ref.read(userStateProvider).userData.isAdmin ? Page.manageUsers.route : Page.screenQuestions.route,
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
