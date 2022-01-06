import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../constants.dart';
import '../../../models/langauge_model.dart';

class LanguagePage extends ConsumerStatefulWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends ConsumerState<LanguagePage> {
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
    Language? language = ref.read(languageProvider).currentLanguage;
    return Row(
      children: [
        Container(
          color: Theme.of(context).canvasColor,
          width: 70,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 15),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 40,
                  ),
                  tooltip: 'Back',
                  onPressed: () {
                    selectPage(ref, context, 'Profile Page');
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 850,
                  ),
                  child: FormBuilder(
                    key: _formKey,
                    child: NotificationListener(
                      onNotification: _handleScrollNotification,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            FormBuilderTextField(
                              name: 'language',
                              initialValue: language?.language,
                              style: const TextStyle(
                                  color: textColour
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                hintText: 'Language',
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
                            const SizedBox(
                              height: 30,
                            ),
                            FormBuilderTextField(
                              name: 'ISOLanguageCode',
                              initialValue: language?.ISOcode,
                              style: const TextStyle(
                                color: textColour
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                hintText: 'Language ISO Code',
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
                                FormBuilderValidators.maxLength(context, 2),
                              ]),
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
                      if (language != null) {
                        ref.read(languageProvider).updateDocument(_formKey.currentState!.value, language.id);
                      } else {
                        ref.read(languageProvider).addDocument(_formKey.currentState!.value);
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
          ),
        ),
      ],
    );
  }
}
