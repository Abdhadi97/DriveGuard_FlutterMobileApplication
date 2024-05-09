class InputValidtor {
  //validate firstname
  String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your first name";
    }
    return null;
  }

  //validate lastname
  String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your last name";
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

//validate checkbox empty
  String? isEmptyCheck(value) {
    if (value!.isEmpty) {
      return "Please fill details";
    }
    return null;
  }
}
