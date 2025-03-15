// form_validation.dart

class FormValidation {
  // Email Validation
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter your email';
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
      return 'Please enter your password';
    }
    // Check for minimum 6 characters
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateComplaintReply(String? cissue) {
    if (cissue == null || cissue.isEmpty) {
      return "You cannot submit a reply without any content.";
    }
    // Check for minimum 6 characters
    if (cissue.length < 6) {
      return 'complaint must be at least 6 characters';
    }
    return null;
  }
}
