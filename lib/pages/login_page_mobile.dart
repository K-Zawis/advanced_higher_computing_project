import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '/constants.dart';
import '../providers/auth_providers/auth_helper.dart';

class MobileLogInPage extends ConsumerStatefulWidget {
  const MobileLogInPage({Key? key}) : super(key: key);

  @override
  _MobileLogInPageState createState() => _MobileLogInPageState();
}

class _MobileLogInPageState extends ConsumerState<MobileLogInPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Consumer(builder: (context, ref, child) {
      var auth = ref.watch(userStateProvider.notifier);
      var state = ref.watch(loginProvider);
      return Padding(
        padding: EdgeInsets.only(
          bottom: bottom,
        ),
        child: FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50),
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
                            enableSuggestions: true,
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
                                  color: Colors.white,
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
                                  controller: state.confirmControllerS(),
                                  obscureText: !state.isConfirmPasswordVisible(),
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
                                        color: Colors.white,
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
                            height: 15,
                          ),
                          Text(
                            state.errorMessage(),
                            style: TextStyle(
                              color: Theme.of(context).errorColor,
                            ),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.saveAndValidate()) {
                                state.setPasswordValid(true);
                                state.setConfirmValid(true);
                                if (state.isLogin()) {
                                  AuthResultStatus status = await auth.signIn(
                                    _formKey.currentState!.value['email'],
                                    _formKey.currentState!.value['password'],
                                  );
                                  if (status == AuthResultStatus.successful) {
                                    var verified = ref.read(firebaseAuthProvider).currentUser!.emailVerified;
                                    if (verified) {
                                      state.resetControllers();
                                      selectPage(ref, context, 'Home Page');
                                    } else {
                                      state.setErrorMessage('Please verify your Email!');
                                      ref.read(userStateProvider.notifier).signOut();
                                    }
                                  } else {
                                    setState(() {
                                      var temp = AuthExceptionHandler.generateExceptionMessage(status);
                                      if (status == AuthResultStatus.invalidEmail || status == AuthResultStatus.userDisabled) {
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
                                } else {
                                  try {
                                    await auth.createUserWithEmailAndPassword(
                                      _formKey.currentState!.value['email'],
                                      _formKey.currentState!.value['password'],
                                    );
                                    state.setIsLogin();
                                  } on FirebaseAuthException catch (e) {
                                    var status = AuthExceptionHandler.handleException(e);
                                    var temp = AuthExceptionHandler.generateExceptionMessage(status);
                                    if (status == AuthResultStatus.emailAlreadyExists) {
                                      _formKey.currentState!.invalidateField(name: 'email', errorText: temp);
                                    } else if (status == AuthResultStatus.weakPassword) {
                                      _formKey.currentState!.invalidateField(name: 'password', errorText: temp);
                                    } else {
                                      state.setErrorMessage(temp);
                                    }
                                  }
                                }
                              }
                              if (!_formKey.currentState!.fields['password']!.isValid) {
                                state.setPasswordValid(true);
                              } else {
                                state.setPasswordValid(false);
                              }
                              if (!_formKey.currentState!.fields['confirm_password']!.isValid) {
                                state.setConfirmValid(true);
                              } else {
                                state.setConfirmValid(false);
                              }
                            },
                            child: Text(state.isLogin() ? 'LOG IN' : 'SIGN UP'),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          state.isLogin()
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Don't have an account? ",
                                      style: TextStyle(
                                        color: textColour,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        state.resetControllers();
                                        state.setIsLogin();
                                      },
                                      child: const Text(
                                        'Sign Up',
                                        style: TextStyle(decoration: TextDecoration.underline),
                                      ),
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                                        //alignment: MaterialStateProperty.all(Alignment.centerLeft),
                                        minimumSize: MaterialStateProperty.all(Size.zero),
                                      ), /*TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              alignment: Alignment.bottomLeft,
                                              minimumSize: Size.zero,
                                            ),*/
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Already have an account? ',
                                      style: TextStyle(
                                        color: textColour,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        state.resetControllers();
                                        state.setIsLogin();
                                      },
                                      child: const Text(
                                        'Log In',
                                        style: TextStyle(decoration: TextDecoration.underline),
                                      ),
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        alignment: Alignment.bottomLeft,
                                        minimumSize: Size.zero,
                                      ),
                                    ),
                                  ],
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
      );
    });
  }
}
