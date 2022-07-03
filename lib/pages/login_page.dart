import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:learn_languages/providers/auth_providers/auth_helper.dart';
import 'package:vrouter/vrouter.dart';

class LogInPage extends ConsumerStatefulWidget {
  final String state;

  const LogInPage({required this.state, Key? key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends ConsumerState<LogInPage> {
  String errorMessage = '';
  String password = '';
  // create form key
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  initState() {
    super.initState();
  }

  Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context,
      required GlobalKey<FormBuilderState> formKey}) async {
    setState((() => errorMessage = ''));
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      String response = AuthExceptionHandler.generateExceptionMessage(
          AuthExceptionHandler.handleException(e));
      switch (AuthExceptionHandler.handleException(e)) {
        case AuthResultStatus.invalidEmail:
        case AuthResultStatus.emailAlreadyExists:
        case AuthResultStatus.userDisabled:
        case AuthResultStatus.userNotFound:
          formKey.currentState!.fields['email']!.invalidate(response);
          break;
        case AuthResultStatus.wrongPassword:
        case AuthResultStatus.weakPassword:
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

  @override
  Widget build(BuildContext context) {
    print(widget.state);
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
                      decoration: InputDecoration(
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
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
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
                            decoration: InputDecoration(
                              hintText: 'Confirm password',
                            ),
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(),
                                FormBuilderValidators.match(
                                  _formKey.currentState?.value['password'] ??
                                      'no-match',
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
                              onPressed: () {},
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
                                if (_formKey.currentState?.saveAndValidate() ??
                                    false) {
                                  print(_formKey.currentState!.value);
                                  User? user = await loginUsingEmailPassword(
                                    context: context,
                                    email:
                                        _formKey.currentState!.value['email'],
                                    password: _formKey
                                        .currentState!.value['password'],
                                    formKey: _formKey,
                                  );
                                  print(user);
                                  if (user != null) {
                                    context.vRouter.to('/');
                                  }
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Theme.of(context).focusColor),
                        ),
                        child: widget.state == 'login'
                            ? const Text('Sign in')
                            : const Text('Register'),
                      ),
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
