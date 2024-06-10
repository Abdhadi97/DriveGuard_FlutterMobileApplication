import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:drive_guard/providers/user_provider.dart';
import 'package:drive_guard/controllers/input_validator.dart';

class UpdateProfileForm extends StatefulWidget {
  const UpdateProfileForm({Key? key}) : super(key: key);

  @override
  _UpdateProfileFormState createState() => _UpdateProfileFormState();
}

class _UpdateProfileFormState extends State<UpdateProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumController;

  final _validator = InputValidator();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with user data if available
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _firstNameController =
        TextEditingController(text: userProvider.user?.firstName ?? '');
    _lastNameController =
        TextEditingController(text: userProvider.user?.lastName ?? '');
    _phoneNumController =
        TextEditingController(text: userProvider.user?.phoneNum ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _firstNameController,
            keyboardType: TextInputType.name,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: _validator.validateFirstName,
            decoration: const InputDecoration(
              labelText: 'First Name',
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _lastNameController,
            keyboardType: TextInputType.name,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: _validator.validateLastName,
            decoration: const InputDecoration(
              labelText: 'Last Name',
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _phoneNumController,
            keyboardType: TextInputType.phone,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: _validator.validatePhoneNumber,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _submitForm(context);
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Save changes
      final updatedData = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'phoneNum': _phoneNumController.text.trim(),
      };

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      try {
        await userProvider.updateUserProfile(
          updatedData['firstName']!,
          updatedData['lastName']!,
          updatedData['phoneNum']!,
        );

        // Show success dialog
        showSuccessMessage(context, "Profile details updated successfully");
      } catch (e) {
        // Handle errors, for example show a snackbar or dialog
        print('Error updating profile: $e');
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumController.dispose();
    super.dispose();
  }
}

void showSuccessMessage(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (context) => AlertDialog(
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black,
      backgroundColor: Colors.white,
      content: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/success_animation.json',
              width: 80,
              height: 80,
              fit: BoxFit.fill,
              repeat: true,
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Dismiss the dialog
              },
              child: const Text('Proceed'),
            ),
          ],
        ),
      ),
    ),
  );
}
