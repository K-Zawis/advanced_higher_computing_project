import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:learn_languages/models/topic_model.dart';

import '../../../constants.dart';

class TopicEditPage extends ConsumerStatefulWidget {
  const TopicEditPage({Key? key}) : super(key: key);

  @override
  _TopicEditPageState createState() => _TopicEditPageState();
}

class _TopicEditPageState extends ConsumerState<TopicEditPage> {
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
                      ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: topics.length,
                        itemBuilder: (context, index) {
                          Topic topic = topics.values.toList()[index];
                          return ListTile(
                            title: Text(
                              topic.name,
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
                                    ref.read(topicProvider).removeDocument(topic.id);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                  ),
                                ),
                                IconButton(
                                  color: iconColour,
                                  tooltip: 'Edit',
                                  onPressed: () {
                                    ref.read(topicProvider).setCurrentTopic(topic);
                                    selectPage(ref, context, 'Topic Page');
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
              ref.read(topicProvider).setCurrentTopic(null);
              selectPage(ref, context, 'Topic Page');
            },
            tooltip: 'Add Qualification',
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}