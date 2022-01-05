import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants.dart';
import '../../../models/answer_model.dart';
import '../../../models/user_model.dart';
import '../../../widgets/expanded_animation_widget.dart';

class EditUserDesktopPage extends ConsumerStatefulWidget {
  const EditUserDesktopPage({Key? key}) : super(key: key);

  @override
  _EditUserDesktopPageState createState() => _EditUserDesktopPageState();
}

class _EditUserDesktopPageState extends ConsumerState<EditUserDesktopPage> {
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
    MyUser user = ref.read(usersProvider).currentUser!;
    return Stack(
      children: [
        FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, right: 40),
                      constraints: const BoxConstraints(
                        maxWidth: 850,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_circle,
                            color: Theme.of(context).colorScheme.primary,
                            size: 150,
                          ),
                          Flexible(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: FormBuilderDropdown(
                                      name: 'isAdmin',
                                      initialValue: user.isAdmin,
                                      items: const [
                                        DropdownMenuItem(
                                          value: true,
                                          child: Text(
                                            'Admin',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: textColour,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: false,
                                          child: Text(
                                            'Student',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: textColour,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    user.email.substring(0, user.email.indexOf('@')),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.primary,
                height: 2,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Available Answers:',
                style: TextStyle(fontSize: 21, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: Consumer(builder: (context, ref, child) {
                  var answers = ref.watch(answerProvider(true)).items.values.toList();
                  var questions = ref.watch(questionProvider).items;
                  answers.sort((a, b) => a.topicId.compareTo(b.topicId));
                  if (questions.isNotEmpty) {
                    return Container(
                      constraints: const BoxConstraints(
                        maxWidth: 850,
                      ),
                      child: NotificationListener(
                        onNotification: _handleScrollNotification,
                        child: ListView.builder(
                          controller: ScrollController(),
                          itemCount: answers.length,
                          itemBuilder: (context, index) {
                            Answer answer = answers[index];
                            return ListTile(
                              title: Text(
                                questions[answer.questionId]!.question,
                                style: const TextStyle(
                                  color: textColour,
                                ),
                              ),
                              subtitle: Text(
                                '- ${answer.text}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox(
                      height: 50,
                      width: 50,
                      child: FittedBox(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                }),
              ),
            ],
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
                print(_formKey.currentState!.value);
                if (_formKey.currentState!.value['isAdmin']) {
                  _showDialog(ref, context, user);
                } else {
                  ref.read(usersProvider).updateDocument(_formKey.currentState!.value, user.uid);
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

  _showDialog(WidgetRef ref, BuildContext context, MyUser user) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Warning!"),
          content: const Text('Are you sure you want to give this user Administrative Rights?'
              '\n\n   They will be able to manage all data.'
              '\n   View all users.'
              '\n   And give out Administrative Rights.'
              '\n\nContinue?'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).brightness == Brightness.light ? Colors.transparent : Colors.black.withOpacity(0.2)),
                elevation: MaterialStateProperty.all(0),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
              onPressed: () {
                _formKey.currentState!.fields['isAdmin']!.reset();
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text('Yes'),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
              onPressed: () {
                ref.read(usersProvider).updateDocument(_formKey.currentState!.value, user.uid);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
