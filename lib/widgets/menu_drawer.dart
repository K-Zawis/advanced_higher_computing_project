import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_languages/constants.dart';
import 'package:learn_languages/widget_tree.dart';

class MenuDrawer extends StatelessWidget {
  final double elevation;

  const MenuDrawer({required this.elevation, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: elevation,
      child: Column(
        children: [
          Consumer(builder: (context, watch, child) {
            var user = watch(userStateProvider);
            if (user != null) {
              return SizedBox(
                height: 250,
                width: double.infinity,
                child: user.isAnonymous
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 249,
                            child: Center(
                              child: SizedBox(
                                width: 100,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (Scaffold.of(context).isDrawerOpen) {
                                      Navigator.pop(context);
                                    }
                                    selectPage(context, 'LogIn Page');
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
                              selectPage(context, 'LogIn Page');
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
                              user.email.substring(0, user.email.indexOf('@')),
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
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: const [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Assignment Data:',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
