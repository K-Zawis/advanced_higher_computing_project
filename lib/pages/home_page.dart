import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../constants.dart';
import '../widget_tree.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _multiKey = GlobalKey<FormFieldState>();
  var _selectedTopics = [];
  bool _assignment = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectedTopics = context.read(topicProvider).getTopics();
    return Container(
      color: Colors.black,
      child: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Stack(
                children: [
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/learn-languages-71bed.appspot.com/o/pexels-lilartsy-1925536.jpg?alt=media&token=df33a026-149b-46fb-b291-d57eb5e8c0d3',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      height: 80,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 0, 0, 0),
                            Color.fromARGB(150, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: SizedBox(
                            height: 52,
                            width: 100,
                            child: Consumer(builder: (context, watch, child) {
                              watch(languageProvider);
                              var language = context.read(languageProvider).getLanguage();
                              return FormBuilderDropdown(
                                name: 'language',
                                initialValue: language == '' ? null : language,
                                items: context.read(languageProvider.notifier).getDropdownItems(context),
                                iconEnabledColor: Colors.white,
                                decoration: const InputDecoration(
                                  fillColor: Color(0x451C1C1C),
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: dropdownFillColour,
                                      width: 2,
                                    ),
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
                                  context.read(topicProvider).setTopics([]);
                                  context.read(languageProvider.notifier).setLanguage(val.toString());
                                },
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                //height: MediaQuery.of(context).size.height - 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Container(
                  decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
                  padding: const EdgeInsets.only(right: 10, top: 50),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      //height: MediaQuery.of(context).size.height - 250,
                      padding: const EdgeInsets.only(right: 40, left: 50),
                      constraints: const BoxConstraints(
                        maxWidth: 850,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Level of Study:',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Consumer(builder: (context, watch, child) {
                                    var level = context.read(qualificationProvider).getLevel();
                                    return FormBuilderDropdown(
                                      initialValue: level == '' ? null : level,
                                      iconEnabledColor: Theme.of(context).colorScheme.secondary,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                                          borderSide: BorderSide(
                                              width: 3, color: Theme.of(context).colorScheme.secondary),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                                          borderSide: BorderSide(
                                              width: 3, color: Theme.of(context).colorScheme.secondary),
                                        ),
                                      ),
                                      name: 'level',
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(context),
                                      ]),
                                      items:
                                          context.read(qualificationProvider.notifier).getDropdownItems(context),
                                      onChanged: (value) {
                                        _multiKey.currentState?.save();
                                        _multiKey.currentState?.didChange(null);
                                        setState(() {
                                          _selectedTopics = [];
                                        });
                                        context.read(topicProvider).setTopics([]);
                                        context.read(qualificationProvider.notifier).setLevel(value.toString());
                                      },
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          const Text(
                            'Topics:',
                            style: TextStyle(
                              fontSize: 20,
                              //color: scaffoldColour,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, right: 10),
                            child: MultiSelectChipDisplay(
                              items: context
                                  .read(topicProvider)
                                  .getTopics()
                                  .map(
                                    (e) => (MultiSelectItem(e, e)),
                                  )
                                  .toList(),
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
                                  _selectedTopics.remove(value);
                                });
                                context.read(topicProvider).setTopics(_selectedTopics);
                              },
                            ),
                          ),
                          Center(
                            child: Visibility(
                              visible: !(_selectedTopics.length == 2),
                              child: FittedBox(
                                child: Consumer(builder: (context, watch, child) {
                                  var topics = watch(topicProvider);
                                  if (topics.items.isNotEmpty) {
                                    return MultiSelectBottomSheetField(
                                      key: _multiKey,
                                      initialValue: topics.getTopics().isEmpty? null : topics.getTopics(),
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
                                        } else if (_assignment) {
                                          if (values.length != 2){
                                            return '2 topics required for Assignment Mode';
                                          }
                                        }
                                        return null;
                                      },
                                      items: context.read(topicProvider).getMultiSelectItems(),
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
                          Container(
                            //height: 100,
                            width: MediaQuery.of(context).size.width,
                            constraints: const BoxConstraints(
                              maxHeight: 100,
                              minHeight: 50,
                            ),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Wrap(
                                  spacing: 50,
                                  runSpacing: 10,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          _assignment = false;
                                          _formKey.currentState?.save();
                                          _multiKey.currentState?.save();
                                          if (_formKey.currentState!.validate()) {
                                            selectPage(context, 'Practice Mode');
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 15.0, /*horizontal: 10*/),
                                          child: Text(
                                            'PRACTICE MODE',
                                            softWrap: false,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                              side: BorderSide(width: 3, color: Theme.of(context).colorScheme.primary),
                                            ),
                                          ),
                                          backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                          elevation: MaterialStateProperty.all(0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _assignment = true;
                                          _formKey.currentState?.save();
                                          _multiKey.currentState?.save();
                                          if (_formKey.currentState!.validate()) {
                                            if (_selectedTopics.length == 2) {
                                              selectPage(context, 'Assignment Mode');
                                            } else {
                                            }
                                          }
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 15.0, /*horizontal: 10*/),
                                          child: Text(
                                            'ASSIGNMENT MODE',
                                            softWrap: false,
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                          ),
                                          elevation: MaterialStateProperty.all(0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
