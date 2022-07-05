import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:vrouter/vrouter.dart';

import '../models/topic_model.dart';
import '../providers/auth_providers/user_state_notifier.dart';
import '../widgets/footer_widget.dart';
import '../widgets/navigation_bar_widget.dart';
import '/constants.dart' as constants;

// enum Page { screenQuestions, screenAnalytics, manageUsers, editUser, language, topic, question, level }

// extension on Page {
//   String get route => describeEnum(this);
// }

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    MyUserData? user = ref.watch(constants.userStateProvider);
    // TODO -- create loading splashcreen
    if (user == null) return const Center(child: SizedBox(height: 50, width: 50, child: CircularProgressIndicator()));

    ref.watch(constants.languageStateProvider);
    ref.watch(constants.qualificationStateProvider);

    return Scaffold(
      appBar: webNavigationBar(
        context: context,
        user: user,
        ref: ref,
        nav: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                // if (_formKey.currentState!.saveAndValidate()) {}
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Practice Mode',
                  style: TextStyle(fontSize: 21),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // if (_formKey.currentState!.saveAndValidate()) {
                //   if (_formKey.currentState!.value['topic2'] == null) {
                //     _formKey.currentState!.fields['topic2']!.invalidate('This field cannot be empty for this mode.');
                //   } else {
                //     print(_formKey.currentState!.value);
                //   }
                // }
                // if (_formKey.currentState!.value['topic2'] == null) {
                //   _formKey.currentState!.fields['topic2']!.invalidate('This field cannot be empty for this mode.');
                // }
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Assignment Mode',
                  style: TextStyle(fontSize: 21),
                ),
              ),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              constraints: const BoxConstraints(minHeight: 973 - 208),
              height: MediaQuery.of(context).size.height - 208,
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: Text(
                          user.email,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          user.isAdmin ? 'Admin' : 'Student',
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).disabledColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 32,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: FormBuilderDropdown<String>(
                              name: 'level',
                              decoration: const InputDecoration(hintText: 'Level'),
                              initialValue: VRouter.of(context).historyState['level'] != null
                                  ? VRouter.of(context).historyState['level']!.isNotEmpty
                                      ? VRouter.of(context).historyState['level']
                                      : null
                                  : null,
                              validator: FormBuilderValidators.required(),
                              items: ref.read(constants.qualificationStateProvider.notifier).getDropdownItems(context),
                              onChanged: (value) {
                                VRouter.of(context).to(
                                  context.vRouter.url,
                                  isReplacement: true, // We use replacement to override the history entry
                                  historyState: {
                                    'level': value ?? '',
                                    'language': VRouter.of(context).historyState['language'] ?? ''
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Flexible(
                            child: FormBuilderDropdown(
                              name: 'language',
                              initialValue: VRouter.of(context).historyState['language'] != null
                                  ? VRouter.of(context).historyState['language']!.isNotEmpty
                                      ? VRouter.of(context).historyState['language']
                                      : null
                                  : null,
                              decoration: const InputDecoration(hintText: 'Language'),
                              items: ref.read(constants.languageStateProvider.notifier).getDropdownItems(context),
                              validator: FormBuilderValidators.required(),
                              onChanged: (String? id) {
                                VRouter.of(context).to(
                                  context.vRouter.url,
                                  isReplacement: true, // We use replacement to override the history entry
                                  historyState: {
                                    'language': id ?? '',
                                    'level': VRouter.of(context).historyState['level'] ?? ''
                                  },
                                );
                              },
                            ),
                          ),
                          Consumer(builder: (context, ref, child) {
                            if ((VRouter.of(context).historyState['language']?.isEmpty ?? true) ||
                                (VRouter.of(context).historyState['level']?.isEmpty ?? true)) return const SizedBox();

                            String ids = "${VRouter.of(context).historyState['language']}-${VRouter.of(context).historyState['level']}";

                            Map<String, Topic> topics = ref.watch(constants.topicStateProvider(ids));

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                FormBuilderDropdown<String>(
                                  name: 'topic1',
                                  initialValue: (VRouter.of(context).historyState['topic1']?.isEmpty ?? true)
                                      ? null
                                      : VRouter.of(context).historyState['topic1'],
                                  decoration: const InputDecoration(hintText: 'Topic 1'),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    (topic) {
                                      if (VRouter.of(context).historyState['topic2']?.isNotEmpty ?? false) {
                                        if (VRouter.of(context).historyState['topic2'] == topic) {
                                          return 'Topics muct not be the same';
                                        }
                                      }
                                      return null;
                                    }
                                  ]),
                                  items: topics.values
                                      .map(
                                        (item) => DropdownMenuItem<String>(
                                          value: item.id,
                                          child: Text(
                                            item.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (topic) {
                                    VRouter.of(context).to(
                                      context.vRouter.url,
                                      isReplacement: true, // We use replacement to override the history entry
                                      historyState: {
                                        'topic': topic ?? '',
                                        'language': VRouter.of(context).historyState['language'] ?? '',
                                        'level': VRouter.of(context).historyState['level'] ?? ''
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: WebFooter(),
            ),
          ),
        ],
      ),
    );
  }
}
/* 
  WillPopScope(
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
                if (ref.read(userStateProvider)!.isAdmin)
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
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                      size: 40,
                    ),
                    tooltip: 'Delete Account',
                    onPressed: () {
                      _showDialog(ref, context);
                    },
                  ),
                ),
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
                                                    user!.isAdmin ? 'Admin' : 'Student',
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    user.authData.email!.substring(0, user.authData.email!.indexOf('@')),
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
  */

/*_showDialog(WidgetRef ref, BuildContext context) {
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
*/
