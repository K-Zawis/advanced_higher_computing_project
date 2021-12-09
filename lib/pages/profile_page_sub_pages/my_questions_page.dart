import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyQuestionsPage extends StatefulWidget {
  const MyQuestionsPage({Key? key}) : super(key: key);

  @override
  _MyQuestionsPageState createState() => _MyQuestionsPageState();
}

class _MyQuestionsPageState extends State<MyQuestionsPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'My Questions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      );
    });
  }
}
