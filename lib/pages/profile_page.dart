import 'package:flutter/material.dart';

import '/constants.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
                  onPressed: () {},
                  icon: const Icon(
                    Icons.account_circle_outlined,
                    color: iconColour,
                    size: 40,
                  ),
                  tooltip: 'Profile',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.chat_outlined,
                    color: iconColour,
                    size: 40,
                  ),
                  tooltip: 'Questions',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.analytics_outlined,
                    color: iconColour,
                    size: 40,
                  ),
                  tooltip: 'Analytics',
                ),
              ),
              const Spacer(),
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
                    selectPage(context, 'Home Page');
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }
}
