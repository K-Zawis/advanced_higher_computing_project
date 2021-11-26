import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_languages/constants.dart';
import 'package:learn_languages/providers/auth_providers/auth_helper.dart';

import '../main.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  late FocusNode _focusNode;
  late FocusNode _focusNode2;

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _focusNode2.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onOnFocusNodeEvent);
    _focusNode2 = FocusNode();
    _focusNode2.addListener(_onOnFocusNodeEvent);
  }

  _onOnFocusNodeEvent() {
    setState(() {});
  }

  //This will change the color of the icon based upon the focus on the field
  Color getPrefixIconColor2() {
    return _focusNode2.hasFocus ? Theme.of(context).colorScheme.primary : Colors.white;
  }

  //This will change the color of the icon based upon the focus on the field
  Color getPrefixIconColor() {
    return _focusNode.hasFocus ? Theme.of(context).colorScheme.primary : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      var auth = watch(userStateProvider.notifier);
      var state = watch(loginProvider);
      return Scaffold(
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            constraints: const BoxConstraints(
              maxWidth: 850,
            ),
            child: Card(
              color: const Color(0xFF23252D),
              elevation: 10,
              child: FormBuilder(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50),
                  child: Column(
                    children: [
                      Text(
                        state.isLogin() ? 'LOG IN' : 'SIGN UP',
                        style: const TextStyle(color: textColour, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FormBuilderTextField(
                                  name: 'email',
                                  style: const TextStyle(
                                    color: textColour,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    hintText: 'E-mail address',
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
                                    FormBuilderValidators.email(context),
                                  ]),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                FormBuilderTextField(
                                  name: 'password',
                                  obscureText: !state.isPasswordVisible(),
                                  focusNode: _focusNode,
                                  style: const TextStyle(
                                    color: textColour,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    hintText: 'Password',
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                          state.setPasswordVisible();
                                      },
                                      icon: Icon(
                                        !state.isPasswordVisible() ? Icons.visibility : Icons.visibility_off,
                                        color: getPrefixIconColor(),
                                      ),
                                    ),
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(context),
                                  ]),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                !state.isLogin()
                                    ? FormBuilderTextField(
                                        name: 'confirm_password',
                                        obscureText: !state.isConfirmPasswordVisible(),
                                        focusNode: _focusNode2,
                                        style: const TextStyle(
                                          color: textColour,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),
                                          hintText: 'Password',
                                          enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(15)),
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 1,
                                            ),
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              state.setConfirmPasswordVisible();
                                            },
                                            icon: Icon(
                                              !state.isConfirmPasswordVisible() ? Icons.visibility : Icons.visibility_off,
                                              color: getPrefixIconColor2(),
                                            ),
                                          ),
                                        ),
                                        validator: FormBuilderValidators.compose([
                                          FormBuilderValidators.required(context),
                                          FormBuilderValidators.match(context, _formKey.currentState?.value['password'] ?? ''),
                                        ]),
                                        keyboardType: TextInputType.emailAddress,
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 50,
                                ),
                                // TODO -- fix error messages
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.saveAndValidate()) {
                                      AuthResultStatus status = await auth.signIn(
                                        _formKey.currentState!.value['email'],
                                        _formKey.currentState!.value['password'],
                                      );
                                      if (status == AuthResultStatus.successful) {
                                        var verified = context.read(firebaseAuthProvider).currentUser!.emailVerified;
                                        if (verified) {
                                          Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, _, __) => const MyHomePage(),
                                              transitionDuration: Duration.zero,
                                            ),
                                          );
                                        } else {
                                          state.setErrorMessage('Please verify your Email!');
                                          context.read(userStateProvider.notifier).signOut();
                                        }
                                      } else {
                                        setState(() {
                                          var temp = AuthExceptionHandler.generateExceptionMessage(status);
                                          print(temp);
                                          if (status == AuthResultStatus.invalidEmail ||
                                              status == AuthResultStatus.userDisabled) {
                                            _formKey.currentState!.invalidateField(name: 'email', errorText: temp);
                                          } else if (status == AuthResultStatus.wrongPassword) {
                                            _formKey.currentState!.invalidateField(name: 'password', errorText: temp);
                                          } else if (status == AuthResultStatus.userNotFound) {
                                              state.setIsLogin();
                                          } else {
                                            state.setErrorMessage(temp);
                                          }
                                        });
                                      }
                                    }
                                  },
                                  child: Text(state.isLogin() ? 'LOG IN' : 'SIGN UP'),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                RichText(
                                  text: !state.isLogin()
                                      ? TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Already have an account? ',
                                              style: TextStyle(
                                                color: textColour,
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: TextButton(
                                                onPressed: () {
                                                    state.setIsLogin();
                                                },
                                                child: const Text(
                                                  'Log In',
                                                  style: TextStyle(decoration: TextDecoration.underline),
                                                ),
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                  alignment: Alignment.centerLeft,
                                                  minimumSize: Size.zero,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: "Don't have an account? ",
                                              style: TextStyle(
                                                color: textColour,
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: TextButton(
                                                onPressed: () {
                                                  state.setIsLogin();
                                                },
                                                child: const Text(
                                                  'Sign Up',
                                                  style: TextStyle(decoration: TextDecoration.underline),
                                                ),
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                  alignment: Alignment.centerLeft,
                                                  minimumSize: Size.zero,
                                                ),
                                              ),
                                            ),
                                          ],
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
              ),
            ),
          ),
        ),
      );
    });
  }
}
