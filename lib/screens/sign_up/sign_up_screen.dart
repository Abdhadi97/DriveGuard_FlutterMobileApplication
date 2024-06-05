import 'package:flutter/material.dart';

import '../../components/socal_card.dart';
import '../../constants.dart';
import 'components/sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = "/sign_up";

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + screenHeight * 0.03,
        title: const Text(
          'Sign Up',
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
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  const Text("Register Account", style: headingStyle),
                  SizedBox(height: screenHeight * 0.01),
                  const Text(
                    "Complete your details to create \nnew account",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.1),
                  const SignUpForm(),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'By continuing your confirm that you agree \nwith all the shared data will be use for \nDriveGuard operation. ',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
