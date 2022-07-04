import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:vrouter/vrouter.dart';

import '../providers/auth_providers/auth_helper.dart';
import '../widgets/footer_widget.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String errorMessage = '';
  // create form key
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  Future<void> sendPasswordResetEmail({
    required String email,
    required GlobalKey<FormBuilderState> formKey,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.sendPasswordResetEmail(email: email).then((value) => context.vRouter.pop());
    } on FirebaseAuthException catch (e) {
      String response = AuthExceptionHandler.generateExceptionMessage(AuthExceptionHandler.handleException(e));
      switch (AuthExceptionHandler.handleException(e)) {
        case AuthResultStatus.invalidEmail:
        case AuthResultStatus.userDisabled:
        case AuthResultStatus.userNotFound:
          formKey.currentState!.fields['email']!.invalidate(response);
          break;
        case AuthResultStatus.tooManyRequests:
        case AuthResultStatus.operationNotAllowed:
          setState((() => errorMessage = response));
          break;
        default:
          // undefined
          setState((() => errorMessage = response));
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              constraints: const BoxConstraints(minHeight: 973 - 208),
              height: MediaQuery.of(context).size.height - 208,
              width: double.infinity,
              child: Theme(
                data: ThemeData.dark().copyWith(
                  primaryColorDark: Colors.amber,
                  colorScheme: const ColorScheme.dark().copyWith(
                    primary: Colors.amber,
                    secondary: Colors.amberAccent,
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 350),
                    child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Forgot password',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text(
                            "Provide your email and we will send you a link to reset your password",
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          FormBuilderTextField(
                            name: 'email',
                            decoration: const InputDecoration(
                              hintText: 'Enter your email',
                            ),
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.email(),
                                FormBuilderValidators.required(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: double.maxFinite,
                            child: TextButton(
                              onPressed: () async {
                                if (_formKey.currentState?.saveAndValidate() ?? false) {
                                  sendPasswordResetEmail(
                                    email: _formKey.currentState!.value['email'],
                                    formKey: _formKey,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(color: Theme.of(context).focusColor),
                              ),
                              child: const Text('Reset password'),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Center(
                            child: TextButton(
                              child: const Text('Go back'),
                              onPressed: () => context.vRouter.pop(),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Visibility(
                            visible: errorMessage.isNotEmpty,
                            child: Text(
                              errorMessage,
                              style: TextStyle(color: Theme.of(context).errorColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: WebFooter(),
            ),
          ),
        ],
      ),
    );
  }
}
