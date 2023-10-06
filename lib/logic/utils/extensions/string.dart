extension StringExtensions on String {
  String limitToCharacters(int characters) {
    final input = this;
    if (input.length <= characters) {
      return input.trim();
    }
    return '${input.substring(0, characters).trim()}...';
  }

  String removeWhiteSpaces() {
    final input = this;
    return input.replaceAll(RegExp(r'\s+'), ' ');
  }
}
