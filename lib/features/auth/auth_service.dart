import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // final SupabaseClient _supabase = Supabase.instance.client;
  final firebase = FirebaseAuth.instance;
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      return await firebase.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print('Error: ${e.message}');
      }
      rethrow; // Optionally rethrow the error
    }
  }

  Future<UserCredential> signUpWithEmailPassword(String? email, String? phone,
      {String password = "12345678"}) async {
    return await firebase.createUserWithEmailAndPassword(
        email: email!, password: password);
  }

  Future<void> signOut() async {
    return await firebase.signOut();
  }

  String? getCurrentUser() {
    final user = firebase.currentUser;
    return user?.email;
  }
}
