// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Center(
        // Center the content vertically and horizontally
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  resetPassword(emailController.text.trim(), context);
                },
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void resetPassword(String email, BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Send password reset email
    try {
      // Validate email format
      final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegExp.hasMatch(email)) {
        throw 'Invalid email format';
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      // Dismiss loading indicator
      Navigator.pop(context);

      // Show success message
      showSuccessMessage(
          context, "Password reset email sent. Check your inbox.");
    } catch (e) {
      // Dismiss loading indicator
      Navigator.pop(context);

      // Show error message
      if (e is FirebaseAuthException) {
        showErrorMessage(
            context,
            e.message ??
                "Failed to send password reset email. Please try again.");
      } else {
        showErrorMessage(
            context, "Failed to send password reset email. Please try again.");
      }
    }
  }

  // Function to show success message with guidance
  void showSuccessMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Check your email for instructions on resetting your password.',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to show error message
  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
