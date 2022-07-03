import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrouter/vrouter.dart';

import '../constants.dart' as constants;
import '../widgets/navigation_bar_widget.dart';
import '/providers/auth_providers/user_state_notifier.dart';
import '/widgets/footer_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  final String languageId;

  const HomePage({
    required this.languageId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    MyUserData? user = ref.watch(constants.userStateProvider);
    // TODO -- create loading splashcreen
    if (user == null) return const Center(child: SizedBox(height: 50, width: 50, child: CircularProgressIndicator()));

    return Scaffold(
        appBar: webNavigationBar(
          context: context,
          user: user,
          nav: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Practice Mode',
                    style: TextStyle(fontSize: 21),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Assignment Mode',
                    style: TextStyle(fontSize: 21),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Stack(
            children: [
              FittedBox(
                child: Text(
                  'How it works',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        'Pick a mode from the menu above...\nSelect your level and topics...\nStart learning!',
                        style: Theme.of(context).textTheme.headline3,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: const WebFooter()); // const WidgetTree());
  }
}
