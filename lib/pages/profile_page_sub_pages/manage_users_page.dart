import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants.dart';

class ManageUserPage extends ConsumerStatefulWidget {
  const ManageUserPage({Key? key}) : super(key: key);

  @override
  _ManageUserPageState createState() => _ManageUserPageState();
}

class _ManageUserPageState extends ConsumerState<ManageUserPage> {
  //Our search / filter data
  Map<String, String> filterData = {};
  String _query = '';

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => setState(() {
                _query = value;
              }),
              style: const TextStyle(
                color: textColour,
              ),
              decoration: const InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.all(8),
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(25),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  //populate our search
                  filterData.putIfAbsent(users[index].uid,
                      () => '${users[index].email.isEmpty ? 'Anonymous' : users[index].email} - ${users[index].isAdmin ? 'Admin' : 'Student'}');
                  // return either an empty row or a list tile if the query search is found
                  if (filterData[users[index].uid]!.toLowerCase().contains(_query.toLowerCase())) {
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
                          selectPage(ref, context, 'User Page');
                        },
                        icon: const Icon(
                          Icons.edit,
                        ),
                      ),
                    );
                  } else {
                    return Row();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
