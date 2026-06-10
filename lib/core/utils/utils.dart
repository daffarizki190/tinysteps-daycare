class AppUtils {
  AppUtils._();

  static bool isValidEmail(String email) {
    return email.isNotEmpty && email.length >= 3;
  }

  static bool isValidPassword(String password) {
    return password.isNotEmpty && password.length >= 4;
  }
}
