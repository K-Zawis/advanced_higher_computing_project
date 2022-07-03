import 'package:flutter/material.dart';

import 'package:vrouter/vrouter.dart';

import '../providers/auth_providers/user_state_notifier.dart';

AppBar webNavigationBar({
  required BuildContext context,
  required MyUserData user,
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
          child: IconButton(
            onPressed: () {},
            iconSize: 35,
            splashRadius: 23,
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.account_circle_outlined,
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
