import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '/models/qualification_model.dart';
import '../../../constants.dart';

class QualificationDesktopPage extends ConsumerStatefulWidget {
  const QualificationDesktopPage({Key? key}) : super(key: key);

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends ConsumerState<QualificationDesktopPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    Qualification? qualification = ref.read(qualificationProvider).qualification;
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
                padding: const EdgeInsets.symmetric(horizontal: 50),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    FormBuilderTextField(
                      name: 'level',
                      initialValue: qualification?.level,
                      style: const TextStyle(
                          color: textColour
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        hintText: 'Qualification',
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
                if (qualification != null) {
                  ref.read(qualificationProvider).updateDocument(_formKey.currentState!.value, qualification.id);
                } else {
                  ref.read(qualificationProvider).addDocument(_formKey.currentState!.value);
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