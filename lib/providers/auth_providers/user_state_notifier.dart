import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

import '../../constants.dart';
import 'auth_helper.dart';

class MyUserData {
  final String uid;
  final bool isAdmin;
  final String email;
  final User authData;

  MyUserData({
    required this.authData,
    required this.uid,
    required this.isAdmin,
    required this.email,
  });

  factory MyUserData.fromFirestore(DocumentSnapshot doc, User user) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MyUserData(
      uid: user.uid,
      email: data['email'] ?? 'Anonymous',
      isAdmin: data['isAdmin'] ?? false,
      authData: user,
    );
  }
}

class UserStateNotifier extends StateNotifier<MyUserData?> {
  final Reader _read;
  StreamSubscription<User?>? _authStateChangeSubscription;

  UserStateNotifier(this._read) : super(null);

  Future<void> appInit() async {
    print('init');
    _read(firebaseAuthProvider).setPersistence(Persistence.LOCAL).then(
      (value) {
        _authStateChangeSubscription = _read(firebaseAuthProvider).authStateChanges().listen((user) async {
          print(user?.uid);
          if (user == null) {
            await _read(firebaseAuthProvider).signInAnonymously();
          } else {
            FirebaseFirestore.instance.collection("users").doc(user.uid).snapshots().listen((userData) {
              state = MyUserData.fromFirestore(userData, user);
            });
          }
        });
      },
    );
  }

  // TODO -- will most likely remove all of those..
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
