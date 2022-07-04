import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:learn_languages/widgets/navigation_bar_widget.dart';
import 'package:vrouter/vrouter.dart';

import '../constants.dart' as constants;
import '/providers/auth_providers/user_state_notifier.dart';
import '/widgets/footer_widget.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<WelcomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
    MyUserData? user = ref.watch(constants.userStateProvider);

    // TODO -- create loading splashcreen
    if (user == null) return const Center(child: SizedBox(height: 50, width: 50, child: CircularProgressIndicator()));

    ref.watch(constants.languageStateProvider);
    ref.watch(constants.qualificationStateProvider);

    return Scaffold(
        appBar: webNavigationBar(context: context, user: user, ref: ref),
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Stack(
            children: [
              FittedBox(
                child: Text(
                  'Welcome!',
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
                        'I want to practice...',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: FormBuilder(
                        key: _formKey,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: FormBuilderDropdown<String>(
                                name: 'level',
                                decoration: const InputDecoration(hintText: 'Level'),
                                initialValue: VRouter.of(context).historyState['level'],
                                validator: FormBuilderValidators.required(),
                                items:
                                    ref.read(constants.qualificationStateProvider.notifier).getDropdownItems(context),
                                onChanged: (value) {
                                  VRouter.of(context).to(
                                    context.vRouter.url,
                                    isReplacement: true, // We use replacement to override the history entry
                                    historyState: {
                                      'level': value ?? '',
                                      'language': VRouter.of(context).historyState['language'] ?? ''
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: FormBuilderDropdown(
                                name: 'language',
                                initialValue: VRouter.of(context).historyState['language'],
                                items: ref.read(constants.languageStateProvider.notifier).getDropdownItems(context),
                                validator: FormBuilderValidators.required(),
                                onChanged: (String? id) {
                                  VRouter.of(context).to(
                                    context.vRouter.url,
                                    isReplacement: true, // We use replacement to override the history entry
                                    historyState: {
                                      'language': id ?? '',
                                      'level': VRouter.of(context).historyState['level'] ?? ''
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.saveAndValidate()) {
                                  context.vRouter.toNamed(
                                    'home',
                                    queryParameters: {
                                      'language': VRouter.of(context).historyState['language'] ?? '',
                                      'level': VRouter.of(context).historyState['level'] ?? ''
                                    },
                                  );
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  'Lets go!',
                                  style: TextStyle(fontSize: 21),
                                ),
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
        bottomNavigationBar: const WebFooter()); // const WidgetTree());
  }
}
