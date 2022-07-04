import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:multiselect/multiselect.dart';
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
    final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
    MyUserData? user = ref.watch(constants.userStateProvider);
    // TODO -- create loading splashcreen
    if (user == null) return const Center(child: SizedBox(height: 50, width: 50, child: CircularProgressIndicator()));

    return Scaffold(
      appBar: webNavigationBar(
        context: context,
        user: user,
        ref: ref,
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
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: FittedBox(
                child: Text(
                  'How it works',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Text(
                      'Select your topics...\nPick a mode from the menu above...\nStart learning!',
                      style: Theme.of(context).textTheme.headline3,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 32,
                          ),
                          FormBuilderDropdown(
                            name: 'topic1',
                            decoration: const InputDecoration(hintText: 'Topic 1'),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            items: [],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          FormBuilderDropdown<String>(
                            name: 'topic2',
                            validator: (topic) {},
                            decoration: const InputDecoration(hintText: 'Topic 2'),
                            items: [],
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          TextButton(
                            onPressed: () {
                              VRouter.of(context).to(
                                context.vRouter.url,
                                isReplacement: true, // We use replacement to override the history entry
                                historyState: {},
                              );
                            },
                            child: Text('Clear selections'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const WebFooter(),
    );
  }
}
