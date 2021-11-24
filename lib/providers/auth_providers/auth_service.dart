import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import 'auth_helper.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  Future<void> signInWithEmailAndPassword(email, password);
  User? getCurrentUser();
  Future<void> signOut();
  Future<void> forgotPassword(email);
  Future<void> createUserWithEmailAndPassword(email, password, data);
  Future<void> deleteUser(email, password);
}

class AuthService implements AuthRepository{
  AuthService(this._read);

  final Reader _read;
  late AuthResultStatus _status;

  @override
  Stream<User?> get authStateChanges => _read(firebaseAuthProvider).authStateChanges();

  @override
  User? getCurrentUser() => _read(firebaseAuthProvider).currentUser;

  @override
  Future<AuthResultStatus> signInWithEmailAndPassword(email, password) async {
    try {
      final authResult = await _read(firebaseAuthProvider).signInWithEmailAndPassword(email: email, password: password);
      if (authResult.user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  @override
  Future<void> signOut() async {
    await _read(firebaseAuthProvider).signOut();
    await _read(firebaseAuthProvider).signInAnonymously();
  }

  @override
  Future<void> forgotPassword(email) async {
    _read(firebaseAuthProvider).sendPasswordResetEmail(email: email);
  }

  @override
  Future<User?> createUserWithEmailAndPassword(email, password, data) async {
    await _read(firebaseAuthProvider).createUserWithEmailAndPassword(email: email, password: password).then((result) {
      result.user?.sendEmailVerification();
      result.user!.updateDisplayName(data['displayName']);
      _read(userStateProvider.notifier).addDocument(result.user!.uid, data);
      return result.user;
    });
  }

  @override
  Future deleteUser(email, password) async {
    try {
      User? user = _read(firebaseAuthProvider).currentUser;
      var result = await user?.reauthenticateWithCredential(EmailAuthProvider.credential(email: email, password: password));
      await _read(userStateProvider.notifier).removeDocument(result?.user?.uid); // called from database class
      await result!.user!.delete();
      return true;
    }on FirebaseAuthException catch (e) {
      return AuthExceptionHandler.handleException(e);
    }
  }
}