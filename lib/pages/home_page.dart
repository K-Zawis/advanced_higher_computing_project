import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:learn_languages/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _multiKey = GlobalKey<FormFieldState>();
  var _selectedTopics = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: FormBuilder(
        key: _formKey,
        child: Column(
          //mainAxisSize: MainAxisSize.min,
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
                          colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(150, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 48,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
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
                              child: FormBuilderDropdown(
                                name: 'language',
                                initialValue: 'ES',
                                items: ['ES', 'FR']
                                    .map(
                                      (item) => DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(fontSize: 14, color: Colors.white),
                                        ),
                                      ),
                                    )
                                    .toList(),
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
                                onChanged: (val) {
                                  _multiKey.currentState?.save();
                                  _multiKey.currentState?.didChange(null);
                                  setState(() {
                                    _selectedTopics = [];
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
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
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(top: 50, right: 50, left: 50),
                        constraints: const BoxConstraints(
                          maxWidth: 850,
                        ),
                        decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
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
                                      child: FormBuilderDropdown(
                                        dropdownColor: dropdownFillColour,
                                        decoration: const InputDecoration(
                                          fillColor: dropdownFillColour,
                                          filled: true,
                                          border: OutlineInputBorder(),
                                        ),
                                        name: 'level',
                                        items: ['test', 'values']
                                            .map(
                                              (item) => DropdownMenuItem(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          _multiKey.currentState?.save();
                                          _multiKey.currentState?.didChange(null);
                                          setState(() {
                                            _selectedTopics = [];
                                          });
                                        },
                                      ),
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
                                  items: _selectedTopics
                                      .map(
                                        (e) => (MultiSelectItem(e, e)),
                                      )
                                      .toList(),
                                  chipWidth: double.infinity,
                                  chipColor: Colors.transparent,
                                  textStyle: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: 18,
                                  ),
                                  icon: const Icon(Icons.clear),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    side: BorderSide(width: 3, color: Theme.of(context).colorScheme.primary),
                                  ),
                                  onTap: (value) {
                                    setState(() {
                                      _selectedTopics.remove(value);
                                    });
                                  },
                                ),
                              ),
                              Center(
                                child: Visibility(
                                  visible: !(_selectedTopics.length == 2),
                                  child: FittedBox(
                                    child: MultiSelectBottomSheetField(
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
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(2)),
                                      ),
                                      buttonIcon: Icon(
                                        Icons.add,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      onSelectionChanged: (values) {
                                        if (values.length > 2) {
                                          values.removeLast();
                                        }
                                      },
                                      onConfirm: (List<dynamic> values) {
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
                                      items: ['the aksjdfkasjbdasdf', 'test SfSDASAsdDA SfSDF', 'value SLHAkdQDLHVSAdbIGDs']
                                          .map(
                                            (e) => MultiSelectItem(e, e),
                                          )
                                          .toList(),
                                      chipDisplay: MultiSelectChipDisplay.none(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        child: Wrap(
                          spacing: 50,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            SizedBox(
                              width: 250,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    'PRACTICE MODE',
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
                                onPressed: () {},
                                child: const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text(
                                    'ASSIGNMENT MODE',
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
