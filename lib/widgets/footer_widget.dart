import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class WebFooter extends StatelessWidget {
  const WebFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 108,
      color: Theme.of(context).dialogBackgroundColor,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contact me at zawistowska.kasia@outlook.com',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            const Divider(
              indent: 64,
              endIndent: 64,
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () => launchUrl(Uri.parse('https://github.com/K-Zawis')),
                  child: const Text(
                    'Github',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                TextButton(
                  onPressed: () => launchUrl(Uri.parse('https://www.linkedin.com/in/katarzyna-zawistowska-843302196')),
                  child: const Text(
                    'LinkedIn',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                TextButton(
                  onPressed: () => launchUrl(Uri.parse('https://www.buymeacoffee.com/zawistowskQ')),
                  child: const Text(
                    'Buy Me a Coffee',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
