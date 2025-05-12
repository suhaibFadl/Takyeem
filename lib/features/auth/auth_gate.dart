import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:takyeem/features/auth/pages/login.dart';
import 'package:takyeem/features/navbar/google_navbar.dart';
import 'package:takyeem/features/navbar/navbar.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final session = snapshot.hasData ? snapshot.data!.session : null;
          if (session != null) {
            // return ProfilePage();
            return GoogleNavBar();
          } else {
            return const LoginPage();
          }
        });
  }
}
