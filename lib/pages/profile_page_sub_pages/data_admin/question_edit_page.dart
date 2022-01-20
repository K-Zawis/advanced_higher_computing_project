import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:learn_languages/models/question_model.dart';

import '../../../constants.dart';
import '../../../models/topic_model.dart';

class QuestionEditPage extends ConsumerStatefulWidget {
  const QuestionEditPage({Key? key}) : super(key: key);

  @override
  _QuestionEditPageState createState() => _QuestionEditPageState();
}

class _QuestionEditPageState extends ConsumerState<QuestionEditPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  double _bottom = 16.0;

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent != userScroll.metrics.minScrollExtent) {
              setState(() {
                _bottom = 16.0;
              });
            }
            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent != userScroll.metrics.minScrollExtent) {
              setState(() {
                _bottom = -100.0;
              });
            }
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var language = ref.watch(languageProvider).getLanguage();
    var level = ref.watch(qualificationProvider).getLevel();
    var topics = ref.watch(topicProvider).items;
    var questions = ref.watch(questionProvider).items;
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 850,
            ),
            child: NotificationListener(
              onNotification: _handleScrollNotification,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(50),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                                _bottom = 16.0;
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
                                  borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.secondary),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.secondary),
                                ),
                              ),
                              name: 'level',
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                              ]),
                              items: ref.read(qualificationProvider.notifier).getDropdownItems(context),
                              onChanged: (value) {
                                _bottom = 16.0;
                                ref.read(topicProvider).setTopics([]);
                                ref.read(qualificationProvider.notifier).setLevel(value.toString());
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
                                FormBuilderValidators.required(context),
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
                                _bottom = 16.0;
                                ref.read(topicProvider).setTopics([value]);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          Question question = questions.values.toList()[index];
                          return ListTile(
                            title: Text(
                              question.question,
                              style: const TextStyle(
                                color: textColour,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  color: hintColour,
                                  tooltip: 'Delete',
                                  onPressed: () {
                                    ref.read(questionProvider).removeDocument(question.id);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                  ),
                                ),
                                IconButton(
                                  color: iconColour,
                                  tooltip: 'Edit',
                                  onPressed: () {
                                    ref.read(questionProvider).setCurrentQuestion(question);
                                    selectPage(ref, context, 'Question Page');
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          bottom: _bottom,
          right: 20,
          duration: const Duration(milliseconds: 500),
          child: FloatingActionButton(
            onPressed: () {
              ref.read(questionProvider).setCurrentQuestion(null);
              selectPage(ref, context, 'Question Page');
            },
            tooltip: 'Add Question',
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
