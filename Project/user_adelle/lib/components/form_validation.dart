// form_validation.dart

class FormValidation {
  // Email Validation
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter an email';
    }
    String pattern =
        r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.com$'; // Regular expression for email
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password Validation
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter a password';
    }
    // Check for minimum 6 characters
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Confirm Password Validation
  static String? validateConfirmPassword(
      String? confirmPassword, String? password) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (confirmPassword != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Contact Number Validation (example: 10 digits)
  static String? validateContact(String? contact) {
    if (contact == null || contact.isEmpty) {
      return 'Please enter a contact number';
    }
    // Regex for 10-digit contact number (you can modify this pattern for specific formats)
    String pattern = r'^[0-9]{10}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(contact)) {
      return 'Please enter a valid 10-digit contact number';
    }
    return null;
  }

  // Name Validation
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  // Address Validation
  static String? validateAddress(String? address) {
    if (address == null || address.isEmpty) {
      return 'Please enter your address';
    }
    return null;
  }

  // Dropdown Validation
  static String? validateDropdown(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select an option';
    }
    return null;
  }

  static String? validateComplaintTitle(String? title) {
    if (title == null || title.isEmpty) {
      return "Please enter a title for your complaint.";
    }
    if (title.length < 6) {
      return 'Title must be at least 6 characters';
    }

    String pattern = r'^[a-zA-Z]+[a-zA-Z\w\s]+$'; // Allow spaces
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(title)) {
      return 'Title contains invalid characters';
    }

    return null;
  }

  static String? validateFeedback(String? issue) {
    if (issue == null || issue.isEmpty) {
      return "You cannot submit feedback without any content.";
    }
    // Check for minimum 6 characters
    if (issue.length < 6) {
      return 'title must be at least 6 characters';
    }
    return null;
  }

  static String? validateComplaintIssue(String? cissue) {
    if (cissue == null || cissue.isEmpty) {
      return "You cannot submit a complaint without any content.";
    }
    // Check for minimum 6 characters
    if (cissue.length < 6) {
      return 'complaint must be at least 6 characters';
    }
    return null;
  }
}
