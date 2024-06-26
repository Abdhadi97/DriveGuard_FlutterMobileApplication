import 'package:drive_guard/controllers/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  var database = Database();
  Future<void> createUser(data, context, Function onSuccess) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );
      await database.addUser(data, context);
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Register Successful"),
            content: Text("New User Created"),
          );
        },
      );
      onSuccess(); // Invoke the callback function after successful registration
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Sign Up Failed"),
            content: Text(e.toString()),
          );
        },
      );
    }
  }

  Future<void> validateUser(data, context, Function onSuccess) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );

      onSuccess();
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Login Failed"),
              content: Text(e.toString()),
            );
          });
    }
  }
}
