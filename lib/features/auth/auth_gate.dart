import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:takyeem/features/auth/pages/login.dart';
import 'package:takyeem/features/navbar/navbar.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<firebase_auth.User?>(
      stream: firebase_auth.FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const LoginPage();
        } else {
          return const NavBar();
        }
      },
    );
  }
}
