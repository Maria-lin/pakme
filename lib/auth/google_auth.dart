import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _googleSignIn = GoogleSignIn();

Future<User?> signInWithGoogle(BuildContext context) async {
  try {
    UserCredential? userCredential;

    if (kIsWeb) {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
      userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } else {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      }
    }

    return userCredential?.user ?? FirebaseAuth.instance.currentUser;
  } catch (error) {
    // Handle errors here
    print("Error signing in with Google: $error");
    return null;
  }
}

Future<void> signOutWithGoogle() async {
  if (kIsWeb) {
    await FirebaseAuth.instance.signOut();
  } else {
    await _googleSignIn.signOut();
  }
}
