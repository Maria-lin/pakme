import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<User?> signInOrCreateAccount(
    Function() signInFunc) async {
  try {
    final userCredential = await signInFunc();
    return userCredential.user;
  } catch (error) {
    // Gérer les erreurs ici
    throw error;
  }
}

Future<User?> signInWithEmail(
    String email, String password, String text,) async {
  try {
    final signInFunc = () => FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email.trim(), password: password);
    return await signInOrCreateAccount(signInFunc);
  } catch (error) {
    // Gérer les erreurs spécifiques à la connexion ici
    throw error;
  }
}

Future<User?> createAccountWithEmail(
    String email, String password) async {
  try {
    final createAccountFunc = () => FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email.trim(), password: password);
    return await signInOrCreateAccount(createAccountFunc);
  } catch (error) {
    // Gérer les erreurs spécifiques à la création de compte ici
    throw error;
  }
}

// Fonction d'exemple d'utilisation
void exampleUsage() async {
  try {
    final user = await signInWithEmail("user@example.com", "password","heyy");
    if (user != null) {
      // Utiliser l'utilisateur connecté ici
      print("Utilisateur connecté: ${user.uid}");
    } else {
      // Gérer le cas où l'utilisateur est nul (null) ici
      print("Échec de la connexion.");
    }
  } catch (error) {
    // Gérer les erreurs générales ici
    print("Une erreur s'est produite: $error");
  }
}

// Appel de la fonction d'exemple
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  exampleUsage();
}
