import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';

enum Page { screenQuestions, screenAnalytics }

extension on Page {
  String get route => describeEnum(this);
}

class ProfileOptions extends ConsumerWidget {
  const ProfileOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 300,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 250,
            child: ElevatedButton(
              onPressed: () => navigatorKey.currentState!.pushNamed(Page.screenQuestions.route),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  'Questions',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                elevation: MaterialStateProperty.all(0),
              ),
            ),
          ),
          /*const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 250,
            child: ElevatedButton(
              onPressed: () => navigatorKey.currentState!.pushNamed(Page.screenAnalytics.route),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  'Analytics',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                elevation: MaterialStateProperty.all(0),
              ),
            ),
          ),*/
          const Spacer(),
          SizedBox(
            width: 250,
            child: ElevatedButton(
              onPressed: () => selectPage(ref, context, 'Home Page'),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  'Home',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
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
            ),
          ),
        ],
      ),
    );
  }
}
