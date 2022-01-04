import 'package:flutter/material.dart';

class ManageUserPage extends StatefulWidget {
  const ManageUserPage({Key? key}) : super(key: key);

  @override
  _ManageUserPageState createState() => _ManageUserPageState();
}

class _ManageUserPageState extends State<ManageUserPage> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 850,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          clipBehavior: Clip.hardEdge,
          child: Text('Manage Users'),
        ),
      ),
    );
  }
}