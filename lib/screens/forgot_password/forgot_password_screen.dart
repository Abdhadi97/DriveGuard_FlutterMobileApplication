import 'package:flutter/material.dart';
import 'components/forgot_pass_form.dart';
import '../../constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String routeName = "/forgot_password";

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + screenHeight * 0.03,
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kSecondaryColor,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: kSecondaryColor,
          ),
        ),
        leadingWidth: 80,
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                const Text("Forgot Password", style: headingStyle),
                SizedBox(height: screenHeight * 0.01),
                const Text(
                  "Please enter your email and we will send \nyou a link to create new password",
                  textAlign: TextAlign.center,
                ),
                Image.asset(
                  "assets/images/forgot_password.png",
                  height: screenHeight * 0.4,
                  width: screenWidth * 0.75,
                ),
                const ForgotPassForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
