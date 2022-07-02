import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../constants.dart';
import '../../../models/question_model.dart';
import '../../../models/topic_model.dart';

class QuestionDesktopPage extends ConsumerStatefulWidget {
  const QuestionDesktopPage({Key? key}) : super(key: key);

  @override
  _EditQuestionPageState createState() => _EditQuestionPageState();
}

class _EditQuestionPageState extends ConsumerState<QuestionDesktopPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    var language = ref.watch(languageProvider).getLanguage();
    var level = ref.watch(qualificationProvider).getLevel();
    Topic? topic = ref.watch(topicProvider).currentTopic;
    Question? question = ref.watch(questionProvider).currentQuestion;
    var topics = ref.watch(topicProvider).items;
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
                              FormBuilderValidators.required(),
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
                            child: FormBuilderDropdown(
                              initialValue: level == '' ? null : level,
                              iconEnabledColor: Theme.of(context).colorScheme.secondary,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                  borderSide:
                                  BorderSide(width: 3, color: Theme.of(context).colorScheme.secondary),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                  borderSide:
                                  BorderSide(width: 3, color: Theme.of(context).colorScheme.secondary),
                                ),
                              ),
                              name: 'level',
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              items: ref.read(qualificationProvider.notifier).getDropdownItems(context),
                              onChanged: (value) {
                                ref.read(topicProvider).setTopics([]);
                                ref.read(qualificationProvider.notifier).setLevel(value.toString());
                              },
                            )
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
                            'Topic: ',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          child: FormBuilderDropdown(
                            initialValue: ref.read(topicProvider).getTopics()!.isEmpty ? null : ref.read(topicProvider).getTopics()!.first,
                            iconEnabledColor: Theme.of(context).colorScheme.secondary,
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
                            name: 'topic',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            items: topics.values
                                .map(
                                  (topic) => DropdownMenuItem(
                                value: topic.name,
                                child: Text(
                                  topic.name,
                                  style: const TextStyle(
                                    color: textColour,
                                  ),
                                ),
                              ),
                            )
                                .toList(),
                            onChanged: (value) {
                              ref.read(topicProvider).setTopics([value]);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FormBuilderTextField(
                      name: 'question',
                      initialValue: question?.question,
                      style: const TextStyle(color: textColour),
                      decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        hintText: 'Question (use special characters)',
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
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
            onPressed: () async {
              _formKey.currentState!.save();
              if (_formKey.currentState!.validate()) {
                Map data = {};
                Map ids = await ref.read(topicProvider).getTopicIds();
                var id = ids.values.first;
                data.putIfAbsent('question', () => _formKey.currentState!.value['question']);
                data.putIfAbsent('topic', () => id);
                if (question != null) {
                  ref.read(questionProvider).updateDocument(Map<String, dynamic>.from(data), question.id);
                } else {
                  ref.read(questionProvider).addDocument(Map<String, dynamic>.from(data));
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