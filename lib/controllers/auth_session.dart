import 'package:drive_guard/pages/home_page.dart';
import 'package:drive_guard/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthSession extends StatelessWidget {
  const AuthSession({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user logged in
          if (snapshot.hasData) {
            return const HomePage();
          }

          //user NOT logged in
          else {
            return const LoginPage();
          }
        });
  }
}
