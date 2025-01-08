// Email validation
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email address';
  }
  return null;
}

// Password validation
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  } else if (value.length < 8) {
    return 'Password should be at least 8 characters';
  } else {
    // Regular expression to check for at least one letter, one number, and one special character
    final passwordRegex = RegExp(
        r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$');
    if (!passwordRegex.hasMatch(value)) {
      return 'Password must contain at least one letter, one number, \nand one special character';
    }
  }
  return null;
}

// Confirm Password validation
String? validateConfirmPassword(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'Please re-enter your password';
  } else if (value != password) {
    return 'Passwords do not match';
  }
  return null;
}

// Name validation
String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Name is required';
  }
  return null;
}

// Phone number validation
String? validatePhone(String? value) {
  if (value != null && value.isNotEmpty) {
    // Regex for Malaysian phone number formats
    final phoneRegex = RegExp(r'^(?:\+60|0)[1-9][0-9]{7,8}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid phone number. Eg. 0123456789 (without "-")';
    }
  }
  return null;
}
