import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrouter/vrouter.dart';

import '../constants.dart' as constants;
import '/providers/auth_providers/user_state_notifier.dart';
import '/providers/language_provider.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    MyUserData? user = ref.watch(constants.userStateProvider);
    // TODO -- create loading splashcreen
    if (user == null) return const Center(child: SizedBox(height: 50, width: 50, child: CircularProgressIndicator()));

    Languages languageProvider = ref.watch(constants.languageProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('Learn Languages'),
            const Spacer(),
            Visibility(
              visible: !user.authData.isAnonymous,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    iconSize: 35,
                    splashRadius: 23,
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.account_circle_outlined,
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: user.authData.isAnonymous,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      context.vRouter.toNamed(
                        'auth',
                        pathParameters: {'state': 'register'},
                      );
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  TextButton(
                    onPressed: () async {
                      context.vRouter.toNamed(
                        'auth',
                        pathParameters: {'state': 'login'},
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                    ),
                    child: const Text(
                      'Log in',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: FormBuilder(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: FormBuilderDropdown(
                              name: 'language',
                              initialValue: languageProvider.currentLanguage?.id,
                              items: languageProvider.getDropdownItems(context),
                              onChanged: (String? id) {
                                if (id != null) languageProvider.setCurrentLanguage(languageProvider.items[id]);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 32,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Padding(
                              padding: EdgeInsets.all(16),
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
      bottomNavigationBar: Container(
        width: double.maxFinite,
        height: 108,
        color: Theme.of(context).dialogBackgroundColor,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Contact me at zawistowska.kasia@outlook.com',
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              const Divider(
                indent: 64,
                endIndent: 64,
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => launchUrl(Uri.parse('https://github.com/K-Zawis')),
                    child: const Text(
                      'Github',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        launchUrl(Uri.parse('https://www.linkedin.com/in/katarzyna-zawistowska-843302196')),
                    child: const Text(
                      'LinkedIn',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  TextButton(
                    onPressed: () => launchUrl(Uri.parse('https://www.buymeacoffee.com/zawistowskQ')),
                    child: const Text(
                      'Buy Me a Coffee',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ); // const WidgetTree());
  }
}

/*class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _multiKey = GlobalKey<FormFieldState>();
  List? _selectedTopics = [];
  bool _assignment = false;

  @override
  void initState() {
    _selectedTopics = ref.read(topicProvider).getTopics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
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
                          tooltip: 'Menu',
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
                            child: Consumer(builder: (context, ref, child) {
                              ref.watch(languageProvider);
                              var language = ref.read(languageProvider).getLanguage();
                              return FormBuilderDropdown(
                                name: 'language',
                                initialValue: language == '' ? null : language,
                                items: ref.read(languageProvider.notifier).getDropdownItems(context),
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
                                  FormBuilderValidators.required(),
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
                              );
                            }),
                          ),
                        ),
                        const Spacer(),
                        Consumer(
                          builder: (context, ref, child) {
                            var user = ref.watch(userStateProvider);
                            if (user != null) {
                              if (!user.authData.isAnonymous) {
                                return IconButton(
                                  onPressed: () {
                                    setState(() {
                                      ref.read(userStateProvider.notifier).signOut();
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ),
                                  iconSize: 30,
                                );
                              } else {
                                return const SizedBox(
                                  height: double.minPositive,
                                );
                              }
                            } else {
                              return const SizedBox(
                                height: double.minPositive,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
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
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  constraints: const BoxConstraints(
                                    minWidth: 100,
                                  ),
                                  child: Consumer(builder: (context, ref, child) {
                                    var level = ref.read(qualificationProvider).getLevel();
                                    return FormBuilderDropdown(
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
                                        _multiKey.currentState?.save();
                                        _multiKey.currentState?.didChange(null);
                                        setState(() {
                                          _selectedTopics = [];
                                        });
                                        ref.read(topicProvider).setTopics([]);
                                        ref.read(qualificationProvider.notifier).setLevel(value.toString());
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
                              items: _selectedTopics != null
                                  ? _selectedTopics!
                                      .map(
                                        (e) => (MultiSelectItem(e, e)),
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
                          ),
                          Center(
                            child: Visibility(
                              visible: !(_selectedTopics?.length == 2),
                              child: FittedBox(
                                child: Consumer(builder: (context, ref, child) {
                                  var topics = ref.watch(topicProvider);
                                  if (topics.items.isNotEmpty) {
                                    print(topics.getTopics());
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
                                        } else if (_assignment) {
                                          if (values.length != 2) {
                                            return '2 topics required for Assignment Mode';
                                          }
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
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
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
                              ref.read(usersProvider).setCustom(false);
                              selectPage(ref, context, 'Practice Mode');
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
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
                              if (_selectedTopics?.length == 2) {
                                ref.read(usersProvider).setCustom(false);
                                selectPage(ref, context, 'Assignment Mode');
                              }
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 15.0,
                            ),
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
          ],
        ),
      ),
    );
  }
}*/
