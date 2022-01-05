import 'package:flutter/material.dart';

class EditUserDesktopPage extends StatefulWidget {
  const EditUserDesktopPage({Key? key}) : super(key: key);

  @override
  _EditUserDesktopPageState createState() => _EditUserDesktopPageState();
}

class _EditUserDesktopPageState extends State<EditUserDesktopPage> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 850,
        ),
        child: Text('edit user'),
      ),
    );
  }
}