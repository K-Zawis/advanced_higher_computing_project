import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  final double elevation;

  const MenuDrawer({required this.elevation, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: elevation,
      child: Column(
        children: [
          SizedBox(
            height: 250,
            child: Stack(
              alignment: Alignment.center,
              children: const [],
            ),
          ),
          Expanded(
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
        ],
      ),
    );
  }
}
