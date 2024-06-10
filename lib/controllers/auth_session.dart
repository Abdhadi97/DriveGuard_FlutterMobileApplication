import 'package:drive_guard/screens/init_screen.dart';
import 'package:drive_guard/screens/splash/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthSession extends StatelessWidget {
  const AuthSession({super.key});
  static String routeName = "/auth_session";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user logged in
          if (snapshot.hasData) {
            return const InitScreen();
          }
          //user NOT logged in
          else {
            return const SplashScreen1();
          }
        });
  }
}
