import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:vrouter/vrouter.dart';

import '../constants.dart' as constants;
import '../providers/auth_providers/auth_helper.dart';

class LogInPage extends ConsumerStatefulWidget {
  final String state;

  const LogInPage({required this.state, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends ConsumerState<LogInPage> {
  String errorMessage = '';
  TextEditingController password = TextEditingController(text: '');
  // create form key
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  initState() {
    super.initState();
  }

  Future<User?> loginUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
    required GlobalKey<FormBuilderState> formKey,
  }) async {
    setState((() => errorMessage = ''));
    FirebaseAuth auth = ref.read(constants.firebaseAuthProvider);
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      String response = AuthExceptionHandler.generateExceptionMessage(AuthExceptionHandler.handleException(e));
      switch (AuthExceptionHandler.handleException(e)) {
        case AuthResultStatus.invalidEmail:
        case AuthResultStatus.userDisabled:
        case AuthResultStatus.userNotFound:
          formKey.currentState!.fields['email']!.invalidate(response);
          break;
        case AuthResultStatus.wrongPassword:
          formKey.currentState!.fields['password']!.invalidate(response);
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

    return user;
  }

  Future<User?> registerUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
    required GlobalKey<FormBuilderState> formKey,
  }) async {
    setState((() => errorMessage = ''));
    FirebaseAuth auth = ref.read(constants.firebaseAuthProvider);
    User? user;
    try {
      final credential = EmailAuthProvider.credential(email: email, password: password);
      UserCredential userCredential = await auth.currentUser!.linkWithCredential(credential);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      String response = AuthExceptionHandler.generateExceptionMessage(AuthExceptionHandler.handleException(e));
      switch (AuthExceptionHandler.handleException(e)) {
        case AuthResultStatus.invalidEmail:
        case AuthResultStatus.emailAlreadyExists:
          formKey.currentState!.fields['email']!.invalidate(response);
          break;
        case AuthResultStatus.weakPassword:
          formKey.currentState!.fields['password']!.invalidate(response);
          break;
        default:
          setState((() => errorMessage = response));
          break;
      }
    }
    if (user != null) FirebaseFirestore.instance.collection('users').doc(user.uid).update({'email': user.email});
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Theme(
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
                      widget.state == 'login' ? 'Sign in' : 'Register',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    widget.state == 'login'
                        ? RichText(
                            text: TextSpan(
                              children: [
                                const WidgetSpan(
                                    child: Padding(
                                  padding: EdgeInsets.only(top: 8, bottom: 8),
                                  child: Text(
                                    "Don't have an account?",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                WidgetSpan(
                                  child: TextButton(
                                    child: const Text('Register'),
                                    onPressed: () {
                                      context.vRouter.toSegments(['auth', 'register']);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RichText(
                            text: TextSpan(
                              children: [
                                const WidgetSpan(
                                    child: Padding(
                                  padding: EdgeInsets.only(top: 8, bottom: 8),
                                  child: Text(
                                    "Already have an account?",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                WidgetSpan(
                                  child: TextButton(
                                    child: const Text('Sign in'),
                                    onPressed: () {
                                      context.vRouter.toSegments(['auth', 'login']);
                                      //context.vRouter.toNamed('auth', pathParameters: {'state': 'login'});
                                    },
                                  ),
                                ),
                              ],
                            ),
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
                    FormBuilderTextField(
                      name: 'password',
                      controller: password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    if (widget.state == 'register')
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FormBuilderTextField(
                            name: 'confrim_password',
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              hintText: 'Confirm password',
                            ),
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(),
                                FormBuilderValidators.match(
                                  password.text,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    if (widget.state == 'login')
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              child: const Text('Forgot password?'),
                              onPressed: () {
                                context.vRouter.to('forgot-password');
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    SizedBox(
                      width: double.maxFinite,
                      child: TextButton(
                        onPressed: widget.state == 'login'
                            ? () async {
                                if (_formKey.currentState?.saveAndValidate() ?? false) {
                                  print(_formKey.currentState!.value);
                                  User? user = await loginUsingEmailPassword(
                                    context: context,
                                    email: _formKey.currentState!.value['email'],
                                    password: _formKey.currentState!.value['password'],
                                    formKey: _formKey,
                                  );
                                  print(user);
                                  if (user != null) {
                                    context.vRouter.pop();
                                  }
                                }
                              }
                            : () async {
                                print(password.text);
                                if (_formKey.currentState?.saveAndValidate() ?? false) {
                                  print(_formKey.currentState!.value);
                                  User? user = await registerUsingEmailPassword(
                                    context: context,
                                    email: _formKey.currentState!.value['email'],
                                    password: _formKey.currentState!.value['password'],
                                    formKey: _formKey,
                                  );
                                  print(user);
                                  if (user != null) {
                                    context.vRouter.pop();
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Theme.of(context).focusColor),
                        ),
                        child: widget.state == 'login' ? const Text('Sign in') : const Text('Register'),
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
    );
  }
}
