import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_guard/screens/init_screen.dart';
import 'package:flutter/material.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../constants.dart';
import '../../../controllers/auth_service.dart';
import '../../../controllers/input_validator.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obsecureText = true;
  bool _obsecureText1 = true;
  bool _isLoader = false;
  final AuthService _authService = AuthService();
  final InputValidator _inputValidator = InputValidator();

  // Create user
  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Check if passwords match
      if (_passwordController.text != _confirmPasswordController.text) {
        _showSnackBar(context, 'PASSWORD DOES NOT MATCH !!');
        return;
      }

      // Proceed if passwords match
      setState(() {
        _isLoader = true;
      });

      var data = {
        "firstname": _fNameController.text,
        "lastname": _lNameController.text,
        "email": _emailController.text,
        "phoneNum": _phoneController.text,
        "password": _passwordController.text,
        'imageurl':
            'https://firebasestorage.googleapis.com/v0/b/driveguard-c4915.appspot.com/o/defaultProfile.jpg?alt=media&token=89120c75-b0c6-47ad-acf5-e10eb6e542c7',
        "current address": "",
        "current location": const GeoPoint(0.0, 0.0),
      };

      // Create user with data from input fields
      await _authService.createUser(data, context, () {
        // Delay navigation to home page
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            Navigator.pushReplacementNamed(context, InitScreen.routeName);
          });
        });
      });

      setState(() {
        _isLoader = false;
      });
    }
  }

  // Register error message
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        showCloseIcon: true,
        closeIconColor: Colors.white,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Toggle visibility of password fields
  void _togglePasswordVisibility() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obsecureText1 = !_obsecureText1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // First name input field
          TextFormField(
            controller: _fNameController,
            keyboardType: TextInputType.name,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: _inputValidator.validateFirstName,
            decoration: InputDecoration(
              labelText: "First Name",
              hintText: "Enter your first name",
              hintStyle: TextStyle(
                fontSize: 14,
                color: kSecondaryColor.withOpacity(0.5),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),
          // Last name input field
          TextFormField(
            controller: _lNameController,
            keyboardType: TextInputType.name,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: _inputValidator.validateLastName,
            decoration: InputDecoration(
              labelText: "Last Name",
              hintText: "Enter your last name",
              hintStyle: TextStyle(
                fontSize: 14,
                color: kSecondaryColor.withOpacity(0.5),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),
          // Email input field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: _inputValidator.validateEmail,
            decoration: InputDecoration(
              labelText: "E-mail",
              hintText: "Enter your E-mail address",
              hintStyle: TextStyle(
                fontSize: 14,
                color: kSecondaryColor.withOpacity(0.5),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  const CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          const SizedBox(height: 20),
          // Phone number input field
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: _inputValidator.validatePhoneNumber,
            decoration: InputDecoration(
              labelText: "Phone Number",
              hintText: "Enter your phone number",
              hintStyle: TextStyle(
                fontSize: 14,
                color: kSecondaryColor.withOpacity(0.5),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  const CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
            ),
          ),
          const SizedBox(height: 20),
          // Password input field
          TextFormField(
            controller: _passwordController,
            obscureText: _obsecureText,
            keyboardType: TextInputType.visiblePassword,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: _inputValidator.validatePassword,
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              hintStyle: TextStyle(
                fontSize: 14,
                color: kSecondaryColor.withOpacity(0.5),
              ),
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
          // Confirm password input field
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obsecureText1,
            keyboardType: TextInputType.visiblePassword,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: _inputValidator.validatePassword,
            decoration: InputDecoration(
              labelText: "Confirm Password",
              hintText: "Re-enter your password",
              hintStyle: TextStyle(
                fontSize: 14,
                color: kSecondaryColor.withOpacity(0.5),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: IconButton(
                icon: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(
                    _obsecureText1
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
                onPressed: _toggleConfirmPasswordVisibility,
                highlightColor: Colors.transparent,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Register button
          ElevatedButton(
            onPressed: () => _submitForm(context),
            child: _isLoader
                ? const Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  )
                : const Text(
                    'Register',
                  ),
          ),
        ],
      ),
    );
  }
}
