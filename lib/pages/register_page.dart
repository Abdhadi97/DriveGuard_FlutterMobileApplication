import 'package:drive_guard/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:drive_guard/controllers/auth_service.dart';
import 'package:drive_guard/controllers/input_validator.dart';
import 'package:drive_guard/pages/login_page.dart';
import 'package:iconsax/iconsax.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureText = true;
  bool _obscureText1 = true;
  bool _isLoader = false;

  final AuthService _authService = AuthService();
  final InputValidator _inputValidator = InputValidator();

  // CREATE USER METHOD
  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Check if passwords not match, not proceed
      if (_passwordController.text != _confirmPasswordController.text) {
        _showSnackBar(context, 'PASSWORD DOES NOT MATCH !!');
        return;
      }

      //if match, proceed
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
            'https://firebasestorage.googleapis.com/v0/b/driveguard-c4915.appspot.com/o/defaultProfile.jpg?alt=media&token=89120c75-b0c6-47ad-acf5-e10eb6e542c7'
      };

      //create user with data in input field
      await _authService.createUser(data, context, () {
        // Delay navigation to home page
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        });
      });

      setState(() {
        _isLoader = false;
      });
    }
  }

  //REGISTER ERROR SNACKBAR
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

  // SHOW/HIDE PASSWORD
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // SHOW/HIDE CONFIRM PASSWORD
  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    // ICON/LOGO OF THE APP
                    Icons.person,
                    size: 100,
                  ),
                  const SizedBox(height: 10),

                  // CREATE ACC TEXT
                  const Text(
                    'Let\'s create an account for you!',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),

                  //FULL NAME INPUT FIELD
                  Row(
                    children: [
                      Expanded(
                        // first name input
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: TextFormField(
                            controller: _fNameController,
                            keyboardType: TextInputType.name,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: _inputValidator.validateFirstName,
                            decoration: const InputDecoration(
                              hintText: 'First Name',
                              prefixIcon: Icon(
                                Iconsax.personalcard,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // last name input
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: TextFormField(
                            controller: _lNameController,
                            keyboardType: TextInputType.name,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: _inputValidator.validateLastName,
                            decoration: const InputDecoration(
                              hintText: 'Last Name',
                              prefixIcon: Icon(
                                Iconsax.security_user,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  //EMAIL INPUT FIELD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _inputValidator.validateEmail,
                      decoration: const InputDecoration(
                        hintText: 'Email Address',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  //PHONENUM INPUT FIELD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _inputValidator.validatePhoneNumber,
                      decoration: const InputDecoration(
                        hintText: 'Phone Number',
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  //PASSWORD INPUT FIELD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      keyboardType: TextInputType.visiblePassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _inputValidator.validatePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(
                          Icons.password_outlined,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  //CONFIRM PASSWORD INPUT FIELD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureText1,
                      keyboardType: TextInputType.visiblePassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _inputValidator.validatePassword,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        prefixIcon: const Icon(
                          Icons.password_outlined,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText1
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _toggleConfirmPasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  //REGISTER BUTTON
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: ElevatedButton(
                      onPressed: () => _submitForm(context),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: _isLoader
                          ? const CircularProgressIndicator()
                          : const Text(
                              'REGISTER',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  //GO TO LOGIN PAGE
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            child: const Text(
                              ' Login here',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
