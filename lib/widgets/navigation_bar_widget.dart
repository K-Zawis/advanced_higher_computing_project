import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';
import 'package:vrouter/vrouter.dart';

import '../constants.dart' as constants;
import '../providers/auth_providers/user_state_notifier.dart';

AppBar webNavigationBar({
  required BuildContext context,
  required MyUserData user,
  required WidgetRef ref,
  Widget? nav,
}) {
  return AppBar(
    elevation: 0,
    title: Padding(
      padding: const EdgeInsets.only(left: 32),
      child: SizedBox(
        width: double.maxFinite,
        height: kToolbarHeight,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FittedBox(
            child: SizedBox(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4, right: 8),
                    child: Text('Learn Languages'),
                  ),
                  if (nav != null) nav,
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    actions: [
      Visibility(
        visible: !user.authData.isAnonymous,
        child: Padding(
          padding: const EdgeInsets.only(right: 32),
          child: user.isAdmin
              ? QudsPopupButton(
                  radius: 23,
                  items: [
                    QudsPopupMenuItem(
                      title: const Text('Profile page'),
                      onPressed: () => context.vRouter.toNamed('profile'),
                    ),
                    QudsPopupMenuItem(
                      title: const Text('Manage users'),
                      onPressed: () {},
                    ),
                    QudsPopupMenuSection(
                      titleText: 'Data admin',
                      subItems: [
                        QudsPopupMenuItem(
                          title: const Text('Languages'),
                          onPressed: () {},
                        ),
                        QudsPopupMenuItem(
                          title: const Text('Levels'),
                          onPressed: () {},
                        ),
                        QudsPopupMenuItem(
                          title: const Text('Topics'),
                          onPressed: () {},
                        ),
                        QudsPopupMenuItem(
                          title: const Text('Questions'),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    QudsPopupMenuItem(
                      title: const Text('Sign out'),
                      onPressed: () async => await ref.read(constants.firebaseAuthProvider).signInAnonymously(),
                    ),
                  ],
                  child: const Icon(
                    Icons.account_circle_outlined,
                    size: 35,
                  ),
                )
              : QudsPopupButton(
                  radius: 23,
                  items: [
                    QudsPopupMenuItem(
                      title: const Text('Profile page'),
                      onPressed: () => context.vRouter.toNamed('profile'),
                    ),
                    QudsPopupMenuItem(
                      title: const Text('Sign out'),
                      onPressed: () async => await ref.read(constants.firebaseAuthProvider).signInAnonymously(),
                    ),
                  ],
                  child: const Icon(
                    Icons.account_circle_outlined,
                    size: 35,
                  ),
                ),
        ),
      ),
      Visibility(
        visible: user.authData.isAnonymous,
        child: Padding(
          padding: const EdgeInsets.only(right: 32),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('|'),
              TextButton(
                onPressed: () {
                  context.vRouter.toNamed(
                    'auth',
                    pathParameters: {'state': 'register'},
                  );
                },
                child: const Text(
                  'Sign up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              TextButton(
                onPressed: () async {
                  context.vRouter.toNamed(
                    'auth',
                    pathParameters: {'state': 'login'},
                  );
                },
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                ),
                child: const Text(
                  'Log in',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
