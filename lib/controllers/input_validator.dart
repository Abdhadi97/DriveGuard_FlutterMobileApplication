class InputValidator {
  //validate firstname
  String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please fill details";
    }
    return null;
  }

  //validate lastname
  String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please fill details";
    }
    return null;
  }

  //validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter an email";
    }

    // Regular expression pattern for validating email addresses
    RegExp emailRegExp = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );

    if (!emailRegExp.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  //validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a password";
    }
    return null;
  }

  // Validate phone number
  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a phone number";
    }

    // Regular expression pattern for validating phone numbers
    RegExp phoneRegExp = RegExp(
      r'^\+?0?\d{10,12}$',
      caseSensitive: false,
      multiLine: false,
    );

    if (!phoneRegExp.hasMatch(value)) {
      return "Please enter a valid phone number";
    }
    return null;
  }

//validate checkbox empty
  String? isEmptyCheck(value) {
    if (value!.isEmpty) {
      return "Please fill details";
    }
    return null;
  }
}
