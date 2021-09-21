import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expirtyTime;
  String? _userId;

  bool get isAuth {
    print("*******Ayush*****");
    // print(token);
    return token != null;
  }

  String? get token {
    if (_token != null) {
      print(_token);
      return _token!;
    }
    return null;
  }

  Future<void> signIn(String? email, String? password) async {
    try {
      UserCredential auth =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      print('######Ayush########');
      // print(auth);
      _token = auth.user!.uid;
      print(auth.user!.uid);
      print(_token);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    notifyListeners();
  }

  Future<void> signUp(String? email, String? password) async {
    try {
      UserCredential auth =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      // print(auth);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
