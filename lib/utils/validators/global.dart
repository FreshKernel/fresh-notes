class GlobalValidator {
  GlobalValidator._();
  static String? validateTextIsEmpty(String text, {String? errorMessage}) {
    if (text.trim().isEmpty) {
      return errorMessage ?? 'Please enter a valid text.';
    }
    return null;
  }
}
