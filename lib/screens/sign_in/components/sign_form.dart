import 'package:drive_guard/controllers/auth_service.dart';
import 'package:drive_guard/controllers/input_validator.dart';
import 'package:flutter/material.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../constants.dart';
import '../../forgot_password/forgot_password_screen.dart';
import '../../login_success/login_success_screen.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  var inputValidator = InputValidator();
  bool _obsecureText = true;
  bool _isLoader = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoader = true;
      });

      final data = {
        "email": _emailController.text,
        "password": _passwordController.text,
      };

      await _authService.validateUser(data, context, () {
        // Delay navigation to log in page
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (_, __, ___) => const LoginSuccessScreen(),
                transitionsBuilder: (_, animation, __, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  final tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          }
        });
      });

      // Check if widget is mounted before calling setState
      if (mounted) {
        setState(() {
          _isLoader = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //email address inputfield
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
          const SizedBox(height: 20),

          //password inputfield
          TextFormField(
            controller: _passwordController,
            obscureText: _obsecureText,
            keyboardType: TextInputType.visiblePassword,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: inputValidator.validatePassword,
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: IconButton(
                icon: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(
                    _obsecureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
                onPressed: _togglePasswordVisibility,
                highlightColor: Colors.transparent,
              ),
            ),
          ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              children: [
                Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      context, ForgotPasswordScreen.routeName),
                  child: const Text(
                    "Forgot Password",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          //sign in button
          ElevatedButton(
            onPressed: _isLoader ? null : _submitForm,
            child: _isLoader
                ? const Center(
                    child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ))
                : const Text(
                    "Sign In",
                  ),
          ),
        ],
      ),
    );
  }
}
