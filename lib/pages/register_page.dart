import 'package:flutter/material.dart';
import 'package:drive_guard/controllers/auth_service.dart';
import 'package:drive_guard/controllers/input_validator.dart';
import 'package:drive_guard/pages/login_page.dart';
import 'package:iconsax/iconsax.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({
    Key? key,
    required this.onTap,
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

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Check if passwords match
      if (_passwordController.text != _confirmPasswordController.text) {
        _showSnackBar(context, 'PASSWORD DOES NOT MATCH !!');
        return; // Do not proceed further
      }

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

      await _authService.createUser(data, context, () {
        // Delay navigation to login page
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(
                onTap: () {},
              ),
            ),
          );
        });
      });

      setState(() {
        _isLoader = false;
      });
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person,
                    size: 100,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Let\'s create an account for you!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: TextFormField(
                            controller: _fNameController,
                            keyboardType: TextInputType.name,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: _inputValidator.validateFirstName,
                            decoration: InputDecoration(
                              hintText: 'First Name',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              prefixIcon: const Icon(
                                Iconsax.personalcard,
                                color: Colors.black,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: TextFormField(
                            controller: _lNameController,
                            keyboardType: TextInputType.name,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: _inputValidator.validateLastName,
                            decoration: InputDecoration(
                              hintText: 'Last Name',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              prefixIcon: const Icon(
                                Iconsax.security_user,
                                color: Colors.black,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _inputValidator.validateEmail,
                      decoration: InputDecoration(
                        hintText: 'Email Address',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.black,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _inputValidator.validatePhoneNumber,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        prefixIcon: const Icon(
                          Icons.phone_outlined,
                          color: Colors.black,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        prefixIcon: const Icon(
                          Icons.password_outlined,
                          color: Colors.black,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureText1,
                      keyboardType: TextInputType.visiblePassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _inputValidator.validatePassword,
                      decoration: InputDecoration(
                        hintText: 'Password Confirmation',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        prefixIcon: const Icon(
                          Icons.check,
                          color: Colors.black,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText1
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: _toggleConfirmPasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: ElevatedButton(
                      onPressed: _isLoader
                          ? null
                          : () {
                              _submitForm(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: _isLoader
                          ? const Center(child: CircularProgressIndicator())
                          : const Text(
                              'SIGN UP',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login now',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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
