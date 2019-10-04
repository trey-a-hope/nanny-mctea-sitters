class Validater {//cleanup
  static String isEmpty(String value) {
    if (value.length == 0) {
      return ('Field cannot be empty.');
    }
  }

  static String mobile(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(patttern);
    if (value.length == 0) {
      return null;
    } else if (!regExp.hasMatch(value)) {
      return 'Enter valid number or leave blank.';
    }
    return null;
  }

  static String email(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter a valid email.';
    else
      return null;
  }

  static String password(String value) {
    Pattern pattern = '.{6,}';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return '6 character minimum.';
    else
      return null;
  }

  static String validateBasic(String value) {
    if (value.isEmpty) return 'Cannot leave empty.';
    return null;
  }

  static String validateFirstName(String value) {
    if (value.isEmpty) return 'First name is required.';
    final RegExp nameExp = RegExp(r'^[A-za-z0-9]{0,12}$');
    if (!nameExp.hasMatch(value)) return 'Must be less than 13 alpha-numerics.';
    return null;
  }

  static String validateLastName(String value) {
    if (value.isEmpty) return 'Last name is required.';
    final RegExp nameExp = RegExp(r'^[A-za-z0-9]{0,12}$');
    if (!nameExp.hasMatch(value)) return 'Must be less than 13 alpha-numerics.';
    return null;
  }

  static String validateAddress(String value) {
    if (value.isEmpty) return 'Invalid address.';
    return null;
  }

  static String validateCity(String value) {
    if (value.isEmpty) return 'Invalid city.';
    return null;
  }

  static String validateState(String value) {
    if (value.isEmpty) return 'Invalid state.';
    final RegExp regExp = RegExp(r'^[a-zA-Z]{2}$');
    if (!regExp.hasMatch(value)) return 'Must be 2 letters.';
    return null;
  }

  static String validateZIP(String value) {
    if (value.isEmpty) return 'Invalid zip.';
    final RegExp regExp = RegExp(r'^[0-9]{5}$');
    if (!regExp.hasMatch(value)) return 'Must be 5 digits.';
    return null;
  }

  static String validateEmail(String value) {
    if (value.isEmpty) return 'Email is required.';
    final RegExp nameExp = RegExp(r'^.+@.+\..+$');
    if (!nameExp.hasMatch(value)) return 'Invalid email address';
    return null;
  }

  static String validatePassword(String value) {
    if (value.isEmpty) return 'Invalid password.';
    return null;
  }

  static String validateCardNumber(String value) {
    if (value.isEmpty) return 'Invalid card number.';
    final RegExp regExp = RegExp(r'^[0-9]{16}$');
    if (!regExp.hasMatch(value)) return 'Must be 16 numbers.';
    return null;
  }

  static String validateExpiration(String value) {
    if (value.isEmpty) return 'Invalid expiration.';
    final RegExp regExp = RegExp(r'^[0-9]{4}$');
    if (!regExp.hasMatch(value)) return 'Must be 4 numbers.';
    return null;
  }

  static String validateCVC(String value) {
    if (value.isEmpty) return 'Invalid CVC.';
    final RegExp regExp = RegExp(r'^[0-9]{3}$');
    if (!regExp.hasMatch(value)) return 'Must be 3 numbers.';
    return null;
  }
}
