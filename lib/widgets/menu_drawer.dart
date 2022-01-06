import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_languages/widgets/menu_drawer_widgets/form_options.dart';
import 'package:learn_languages/widgets/menu_drawer_widgets/profile_admin_options.dart';
import 'package:learn_languages/widgets/menu_drawer_widgets/profile_options.dart';

import '/constants.dart';

class MenuDrawer extends ConsumerWidget {
  final double elevation;

  const MenuDrawer({required this.elevation, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      elevation: elevation,
      child: Column(
        children: [
          Consumer(builder: (context, ref, child) {
            var user = ref.watch(userStateProvider);
            if (user != null) {
              return SizedBox(
                height: 250,
                width: double.infinity,
                child: user.authData?.isAnonymous
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            //height: 249,
                            child: Center(
                              child: SizedBox(
                                width: 100,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (Scaffold.of(context).isDrawerOpen) {
                                      Navigator.pop(context);
                                    }
                                    selectPage(ref, context, 'LogIn Page');
                                  },
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
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15.0,
                                    ),
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (Scaffold.of(context).isDrawerOpen) {
                                Navigator.pop(context);
                              }
                              selectPage(ref, context, 'Profile Page');
                            },
                            child: Text('profilePge'),
                          ),
                        ],
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (Scaffold.of(context).isDrawerOpen) {
                                Navigator.pop(context);
                              }
                              selectPage(ref, context, 'Profile Page');
                            },
                            icon: Icon(
                              Icons.account_circle,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            iconSize: 150,
                          ),
                          Positioned(
                            top: 200,
                            child: Text(
                              user.authData.email.substring(0, user.authData.email.indexOf('@')),
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
              );
            } else {
              return const SizedBox(
                height: 250,
                width: double.infinity,
                child: Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                    height: 50,
                    width: 50,
                  ),
                ),
              );
            }
          }),
          Divider(
            height: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
          // TODO -- make this dependant on the page (different page, different buttons)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              child: Consumer(
                builder: (context, ref, child) {
                  var page = ref.watch(selectedPageNameProvider.state).state;
                  switch (page) {
                    case 'Home Page':
                      break;
                    case 'Practice Mode':
                      break;
                    case 'Assessment Mode':
                      break;
                    case 'LogIn Page':
                      break;
                    case 'Profile Page':
                      if (ref.read(userStateProvider).userData.isAdmin) {
                        return const ProfileAdminOptions();
                      } else {
                        return const ProfileOptions();
                      }
                    case 'User Page':
                    case 'Language Page':
                    case 'Qualification Page':
                      return const FormOptions();
                  }
                  return Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
