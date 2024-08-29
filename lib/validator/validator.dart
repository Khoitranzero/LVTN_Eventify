class Validator {
  static isValidEmail(String email) {
    final regularExpression = RegExp(
        r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@'
        r'((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return regularExpression.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    if (password.length < 3) {
      return false;
    }
    bool hasLetter = false;
    bool hasDigit = false;
    for (int i = 0; i < password.length; i++) {
      var char = password[i];
      if (char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 90 ||
          char.codeUnitAt(0) >= 97 && char.codeUnitAt(0) <= 122) {
        hasLetter = true;
      }
      if (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57) {
        hasDigit = true;
      }
    }
    return hasLetter && hasDigit;
  }

  static isValidPhoneNumber(String phoneNumber) {
    final phoneRegEx = RegExp(r'^\d{10}$');
    return phoneRegEx.hasMatch(phoneNumber);
  }

  static isValidDateTime () {

  }
}
