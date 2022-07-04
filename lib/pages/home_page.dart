import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:vrouter/vrouter.dart';

import '../constants.dart' as constants;
import '../models/topic_model.dart';
import '../widgets/navigation_bar_widget.dart';
import '/providers/auth_providers/user_state_notifier.dart';
import '/widgets/footer_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  final String languageId;
  final String levelId;

  const HomePage({
    required this.languageId,
    required this.levelId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<HomePage> {
  late String ids;

  @override
  void initState() {
    ids = "${widget.languageId}-${widget.levelId}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
    MyUserData? user = ref.watch(constants.userStateProvider);
    // TODO -- create loading splashcreen
    if (user == null) return const Center(child: SizedBox(height: 50, width: 50, child: CircularProgressIndicator()));

    Map<String, Topic> topics = ref.watch(constants.topicStateProvider(ids));

    return Scaffold(
      appBar: webNavigationBar(
        context: context,
        user: user,
        ref: ref,
        nav: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.saveAndValidate()) {}
              },
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
              onPressed: () {
                if (_formKey.currentState!.saveAndValidate()) {
                  if (_formKey.currentState!.value['topic2'] == null) {
                    _formKey.currentState!.fields['topic2']!.invalidate('This field cannot be empty for this mode.');
                  } else {
                    print(_formKey.currentState!.value);
                  }
                }
                if (_formKey.currentState!.value['topic2'] == null) {
                  _formKey.currentState!.fields['topic2']!.invalidate('This field cannot be empty for this mode.');
                }
              },
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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              constraints: const BoxConstraints(minHeight: 973 - 208),
              height: MediaQuery.of(context).size.height - 208,
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                FormBuilderDropdown<String>(
                                  name: 'topic1',
                                  initialValue: (VRouter.of(context).historyState['topic1']?.isEmpty ?? true)
                                      ? null
                                      : VRouter.of(context).historyState['topic1'],
                                  decoration: const InputDecoration(hintText: 'Topic 1'),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    (topic) {
                                      if (VRouter.of(context).historyState['topic2']?.isNotEmpty ?? false) {
                                        if (VRouter.of(context).historyState['topic2'] == topic) {
                                          return 'Topics muct not be the same';
                                        }
                                      }
                                      return null;
                                    }
                                  ]),
                                  items: topics.values
                                      .map(
                                        (item) => DropdownMenuItem<String>(
                                          value: item.id,
                                          child: Text(
                                            item.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (topic) {
                                    VRouter.of(context).to(
                                      context.vRouter.url,
                                      isReplacement: true, // We use replacement to override the history entry
                                      historyState: {
                                        'topic1': topic ?? '',
                                        'topic2': VRouter.of(context).historyState['topic2'] ?? ''
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                FormBuilderDropdown<String>(
                                  name: 'topic2',
                                  initialValue: (VRouter.of(context).historyState['topic2']?.isEmpty ?? true)
                                      ? null
                                      : VRouter.of(context).historyState['topic2'],
                                  validator: (topic) {
                                    if (VRouter.of(context).historyState['topic1']?.isNotEmpty ?? false) {
                                      if (VRouter.of(context).historyState['topic1'] == topic) {
                                        return 'Topics muct not be the same';
                                      }
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(hintText: 'Topic 2'),
                                  items: topics.values
                                      .map(
                                        (item) => DropdownMenuItem<String>(
                                          value: item.id,
                                          child: Text(
                                            item.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (topic) {
                                    VRouter.of(context).to(
                                      context.vRouter.url,
                                      isReplacement: true, // We use replacement to override the history entry
                                      historyState: {
                                        'topic2': topic ?? '',
                                        'topic1': VRouter.of(context).historyState['topic1'] ?? ''
                                      },
                                    );
                                  },
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
                                  child: const Text(
                                    'Clear selections',
                                    style: TextStyle(fontSize: 21),
                                  ),
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
          ),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: WebFooter(),
            ),
          ),
        ],
      ),
    );
  }
}
