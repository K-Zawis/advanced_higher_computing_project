import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';

class FormOptions extends ConsumerWidget {
  const FormOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 300,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(),
          SizedBox(
            width: 250,
            child: ElevatedButton(
              onPressed: () => selectPage(ref, context, 'Profile Page'),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  'Back',
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