import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:learn_languages/models/question_model.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../constants.dart';

class MyQuestionsPage extends ConsumerStatefulWidget {
  const MyQuestionsPage({Key? key}) : super(key: key);

  @override
  _MyQuestionsPageState createState() => _MyQuestionsPageState();
}

class _MyQuestionsPageState extends ConsumerState<MyQuestionsPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormBuilderState>();
  final _multiKey = GlobalKey<FormFieldState>();
  List? _selectedTopics = [];
  double _bottom = 16.0;

  @override
  void initState() {
    _selectedTopics = ref.read(topicProvider).getTopics();
    super.initState();
  }

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
    return Consumer(builder: (context, ref, child) {
      ref.watch(languageProvider);
      ref.watch(questionProvider);
      var topics = ref.watch(topicProvider).items;
      var language = ref.watch(languageProvider).getLanguage();
      var level = ref.watch(qualificationProvider).getLevel();
      var questions = ref.watch(questionProvider).getAssignmentLists();
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
                  padding: const EdgeInsets.all(25),
                  clipBehavior: Clip.hardEdge,
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          'My Questions And Answers',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
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
                                  _multiKey.currentState?.save();
                                  _multiKey.currentState?.didChange(null);
                                  setState(() {
                                    _selectedTopics = [];
                                  });
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
                                  _multiKey.currentState?.save();
                                  _multiKey.currentState?.didChange(null);
                                  setState(() {
                                    _selectedTopics = [];
                                  });
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 85,
                              child: Text(
                                'Topics: ',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Flexible(
                                child: Column(
                              children: [
                                MultiSelectChipDisplay(
                                  items: _selectedTopics != null
                                      ? _selectedTopics!
                                          .map(
                                            (e) => MultiSelectItem(e, e),
                                          )
                                          .toList()
                                      : [],
                                  chipWidth: double.infinity,
                                  chipColor: Colors.transparent,
                                  textStyle: TextStyle(
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontSize: 18,
                                  ),
                                  icon: Icon(
                                    Icons.clear,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    side: BorderSide(width: 3, color: Theme.of(context).colorScheme.secondary),
                                  ),
                                  onTap: (value) {
                                    setState(() {
                                      _selectedTopics?.remove(value);
                                      if (_selectedTopics?.isEmpty ?? true) {
                                        _selectedTopics = null;
                                        _multiKey.currentState!.didChange(null);
                                      }
                                    });
                                    ref.read(topicProvider).setTopics(_selectedTopics);
                                  },
                                ),
                                Center(
                                  child: Visibility(
                                    visible: !(_selectedTopics?.length == 2),
                                    child: FittedBox(
                                      child: Consumer(builder: (context, ref, child) {
                                        var topics = ref.watch(topicProvider);
                                        if (topics.items.isNotEmpty) {
                                          return MultiSelectBottomSheetField(
                                            key: _multiKey,
                                            initialValue: _selectedTopics,
                                            title: const Text(
                                              'Topics:',
                                              style: TextStyle(
                                                fontSize: 20,
                                                //color: scaffoldColour,
                                              ),
                                            ),
                                            itemsTextStyle: const TextStyle(
                                              color: textColour,
                                            ),
                                            selectedItemsTextStyle: const TextStyle(
                                              color: textColour,
                                            ),
                                            buttonText: Text(
                                              'ADD TOPIC ',
                                              style: TextStyle(
                                                  color: Theme.of(context).colorScheme.secondary,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(2)),
                                            ),
                                            buttonIcon: Icon(
                                              Icons.add,
                                              color: Theme.of(context).colorScheme.secondary,
                                            ),
                                            onSelectionChanged: (values) {
                                              if (values.length > 2) {
                                                values.removeLast();
                                              }
                                              _multiKey.currentState!.setState(() {});
                                            },
                                            onConfirm: (List<dynamic> values) {
                                              topics.setTopics(values);
                                              setState(() {
                                                _selectedTopics = values;
                                              });
                                            },
                                            validator: (values) {
                                              if (values == null || values.isEmpty) {
                                                return 'Field cannot be empty';
                                              }
                                              return null;
                                            },
                                            items: ref.read(topicProvider).getMultiSelectItems(),
                                            chipDisplay: MultiSelectChipDisplay.none(),
                                          );
                                        } else {
                                          return Text(
                                            'Please select Language and Level of Study',
                                            style: TextStyle(
                                              color: Theme.of(context).hintColor,
                                            ),
                                          );
                                        }
                                      }),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: _selectedTopics?.length ?? 0,
                          itemBuilder: (context, index) {
                            String? topicId;
                            topics.forEach((key, value) {
                              if (value.name == _selectedTopics![index]) {
                                topicId = value.id;
                              }
                            });
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Divider(
                                  color: Theme.of(context).colorScheme.primary,
                                  thickness: 2,
                                  endIndent: 50,
                                  indent: 50,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    _selectedTopics?[index],
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                // fix this
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(bottom: 20),
                                  itemCount: questions[topicId]?.length ?? 0,
                                  itemBuilder: (context, i) {
                                    if (questions.isNotEmpty) {
                                      Question question = questions[topicId]![i];
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              question.question,
                                              style: const TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          FormBuilderTextField(
                                            name: question.id,
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                borderSide: BorderSide(
                                                    width: 2, color: Theme.of(context).colorScheme.secondary),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                borderSide: BorderSide(
                                                    width: 2, color: Theme.of(context).colorScheme.secondary),
                                              ),
                                            ),
                                            maxLines: 4,
                                            minLines: 2,
                                            style: const TextStyle(
                                              color: textColour,
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ],
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
                _formKey.currentState!.save();
                if (_formKey.currentState!.validate()) {
                  questions.forEach((key, value) {
                    for (var question in value) {
                      print(_formKey.currentState!.value[question.id]);
                    }
                  });
                }
              },
              tooltip: 'save',
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.check),
            ),
          ),
        ],
      );
    });
  }
}
