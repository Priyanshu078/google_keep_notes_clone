import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  Future<User?> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(authCredential);

        user = userCredential.user;
        if (user != null) {
          if (kDebugMode) {
            print(user.photoURL);
            print(user.email);
            print(user.displayName);
          }
          return user;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          if (kDebugMode) {
            print(e);
          }
          return null;
        } else if (e.code == 'invalid-credential') {
          if (kDebugMode) {
            print(e);
          }
          return null;
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return null;
      }
    }
    return null;
  }
}
