import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import '../../providers/topic_provider.dart';

enum Page { manageUsers, language, topic, question, level }

extension on Page {
  String get route => describeEnum(this);
}

class ProfileAdminOptions extends ConsumerWidget {
  const ProfileAdminOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () => navigatorKey.currentState!.pushNamed(Page.manageUsers.route),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(
                              'Manage Users',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            elevation: MaterialStateProperty.all(0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: SizedBox(
                          width: 250,
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            collapsedBackgroundColor: Theme.of(context).colorScheme.primary,
                            collapsedTextColor: textColour,
                            collapsedIconColor: textColour,
                            iconColor: Theme.of(context).colorScheme.primary,
                            textColor: Theme.of(context).colorScheme.primary,
                            title: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                'Data Admin',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            children: [
                              SizedBox(
                                width: 250,
                                child: ElevatedButton(
                                  onPressed: () => navigatorKey.currentState!.pushNamed(Page.language.route),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15.0),
                                    child: Text(
                                      'Language',
                                      softWrap: false,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                    ),
                                    elevation: MaterialStateProperty.all(0),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                width: 250,
                                child: ElevatedButton(
                                  onPressed: () => navigatorKey.currentState!.pushNamed(Page.level.route),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15.0),
                                    child: Text(
                                      'Level',
                                      softWrap: false,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                    ),
                                    elevation: MaterialStateProperty.all(0),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                width: 250,
                                child: ElevatedButton(
                                  onPressed: () => navigatorKey.currentState!.pushNamed(Page.topic.route),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15.0),
                                    child: Text(
                                      'Topic',
                                      softWrap: false,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                    ),
                                    elevation: MaterialStateProperty.all(0),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                width: 250,
                                child: ElevatedButton(
                                  onPressed: () {
                                    //Topics topicProv = ref.read(topicProvider);
                                    //var topics = topicProv.getTopics();
                                    //ref.read(usersProvider).setCustom(false);
                                    //if (topics?.length == 2) {
                                    //  topicProv.setTopics([topics![0]]);
                                    //}
                                    //navigatorKey.currentState!.pushNamed(Page.question.route);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15.0),
                                    child: Text(
                                      'Question',
                                      softWrap: false,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                    ),
                                    elevation: MaterialStateProperty.all(0),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () async {
                           _showDialog(ref, context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(
                              'Delete Account',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).errorColor,
                              ),
                            ),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: BorderSide(width: 3, color: Theme.of(context).errorColor),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(Colors.transparent),
                            elevation: MaterialStateProperty.all(0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 250,
            child: ElevatedButton(
              onPressed: () => selectPage(ref, context, 'Home Page'),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  'Home',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(width: 3, color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(0),
              ),
            ),
          ),
        ],
      ),
    );
  }


  _showDialog(WidgetRef ref, BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Warning!"),
          content: const Text('You are about to permanently delete your account!'
              '\n\nContinue?'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(Theme.of(context).brightness == Brightness.light ? Colors.transparent : Colors.black.withOpacity(0.2)),
                elevation: MaterialStateProperty.all(0),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text('Yes'),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.currentUser!.delete().then((value) => selectPage(ref, context, 'Home Page'));
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'requires-recent-login') {
                    print('The user must re-authenticate before this operation can be executed.');
                  }
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
