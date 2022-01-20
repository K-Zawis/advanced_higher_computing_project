import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../models/topic_model.dart';
import '../../../constants.dart';

class TopicDesktopPage extends ConsumerStatefulWidget {
  const TopicDesktopPage({Key? key}) : super(key: key);

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends ConsumerState<TopicDesktopPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    var language = ref.watch(languageProvider).getLanguage();
    var level = ref.watch(qualificationProvider).getLevel();
    Topic? topic = ref.watch(topicProvider).currentTopic;
    var initialValue = topic == null
        ? level == ''
            ? null
            : [level]
        : topic.level;
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 850,
            ),
            child: FormBuilder(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(50),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 85,
                          child: Text(
                            'Language: ',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          child: FormBuilderDropdown(
                            name: 'language',
                            initialValue: language == '' ? null : language,
                            items: ref.read(languageProvider.notifier).getDropdownItems(context),
                            iconEnabledColor: Colors.white,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.secondary),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.secondary),
                              ),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ]),
                            onChanged: (val) {
                              ref.read(topicProvider).setTopics([]);
                              ref.read(languageProvider.notifier).setLanguage(val.toString());
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 85,
                          child: Text(
                            'Level: ',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          child: FormBuilderCheckboxGroup<String?>(
                            name: 'qualification',
                            initialValue: initialValue?.cast<String?>(),
                            activeColor: Theme.of(context).colorScheme.primary,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ]),
                            options: ref
                                .read(qualificationProvider)
                                .items
                                .values
                                .toList()
                                .map(
                                  (value) => FormBuilderFieldOption(
                                    value: value.id,
                                    child: Text(value.level),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FormBuilderTextField(
                      name: 'topic',
                      initialValue: topic?.name,
                      style: const TextStyle(color: textColour),
                      decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        hintText: 'Topic (use special characters)',
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              _formKey.currentState!.save();
              if (_formKey.currentState!.validate()) {
                if (topic != null) {
                  ref.read(topicProvider).updateDocument(_formKey.currentState!.value, topic.id);
                } else {
                  ref.read(topicProvider).addDocument(_formKey.currentState!.value);
                  selectPage(ref, context, 'Profile Page');
                }
              }
            },
            tooltip: 'save',
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.check),
          ),
        ),
      ],
    );
  }
}
