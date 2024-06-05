import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../controllers/input_validator.dart';

class ForgotPassForm extends StatefulWidget {
  const ForgotPassForm({super.key});

  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final inputValidator = InputValidator();

  void forgotPassword(String email, BuildContext context) async {
    if (email.isEmpty) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => const Center(),
    );

    try {
      final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegExp.hasMatch(email)) {
        throw const FormatException(
            'An unexpected error occurred. Invalid email format.');
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      Navigator.pop(context);

      showSuccessMessage(
        context,
        "Password reset email sent. Check your inbox.",
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      final errorMessage = e.message ?? "An error occurred. Please try again.";
      print(e);
    } on FormatException catch (e) {
      Navigator.pop(context);
      print(e);
    } catch (e) {
      Navigator.pop(context);
      print(e);
    }
  }

  void showSuccessMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/success_animation.json',
                width: 90,
                height: 90,
                fit: BoxFit.fill,
                repeat: true,
              ),
              const Text(
                'SUCCESS',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          //email inputfield
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: inputValidator.validateEmail,
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          const SizedBox(height: 8),

          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              forgotPassword(_emailController.text.trim(), context);
            },
            child: const Text("Send Email"),
          ),
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }
}
