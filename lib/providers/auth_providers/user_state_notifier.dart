import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

import '../../constants.dart';
import '../../models/user_model.dart';
import 'auth_helper.dart';

class MyUserData {
  User authData;
  MyUser userData;

  MyUserData({required this.authData, required this.userData});
}

class UserStateNotifier extends StateNotifier< MyUserData? /*User?*/> {
  final Reader _read;

  StreamSubscription<User?>? _authStateChangeSubscription;
  UserStateNotifier(this._read) : super(null) {
    _authStateChangeSubscription?.cancel();
    _authStateChangeSubscription = _read(authRepositoryProvider).authStateChanges.listen((user) {
      if (user != null) {
        FirebaseFirestore.instance.collection("users").doc(user.uid).snapshots().listen((userData) {
          state = MyUserData(authData: user, userData: MyUser.fromFirestore(userData, userData.id));
        });
      } else {
        state = null;
      }
    });
  }

  Future<void> appInit() async {
    print('init');
    var user = _read(authRepositoryProvider).getCurrentUser();
    if (user == null) {
      await _read(firebaseAuthProvider).signInAnonymously();
    }
  }

  Future<AuthResultStatus> signIn(email, password) async {
    var status = await _read(authRepositoryProvider).signInWithEmailAndPassword(email, password);
    return status;
  }

  Future<User?> createUserWithEmailAndPassword(email, password) async {
    var user = await _read(authRepositoryProvider).createUserWithEmailAndPassword(email.trim(), password);
    return user;
  }

  Future<void> signOut() async {
    await _read(authRepositoryProvider).signOut();
  }

  Future<void> forgotPassword(email) async {
    await _read(authRepositoryProvider).forgotPassword(email);
  }

  Future<dynamic> deleteUser(email, password) async {
    var complete = await _read(authRepositoryProvider).deleteUser(email, password);
    return complete;
  }


  // TODO -- add proper document documentation
  // * Firebase management
  Future<void> updateDocument(String uid, Map data) {
    return FirebaseFirestore.instance.collection('users').doc(uid).update(data as Map<String, dynamic>);
  }

  Future<void> addDocument(String uid, Map data) {
    return FirebaseFirestore.instance.collection('users').doc(uid).set(data as Map<String, dynamic>);
  }

  Future<void> removeDocument(uid) {
    var dbRef = FirebaseFirestore.instance.collection('users').doc(uid);
    return dbRef.delete();
  }

  @override
  void dispose() {
    _authStateChangeSubscription?.cancel();
    super.dispose();
  }
}
