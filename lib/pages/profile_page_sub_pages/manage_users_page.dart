import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants.dart';

class ManageUserPage extends ConsumerStatefulWidget {
  const ManageUserPage({Key? key}) : super(key: key);

  @override
  _ManageUserPageState createState() => _ManageUserPageState();
}

class _ManageUserPageState extends ConsumerState<ManageUserPage> {
  @override
  Widget build(BuildContext context) {
    var users = ref.watch(usersProvider).items.values.toList();
    // admin users will be shown first
    users.sort((a, b) {
      if (a.isAdmin) {
        return -1;
      } else {
        return 1;
      }
    });
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 850,
        ),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(25),
          itemCount: users.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                users[index].email,
                style: const TextStyle(
                  color: textColour,
                ),
              ),
              subtitle: Text(
                users[index].isAdmin ? 'Admin' : 'Student',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              trailing: IconButton(
                color: iconColour,
                onPressed: () {
                  // TODO -- Add edit user form page
                },
                icon: const Icon(
                  Icons.edit,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
