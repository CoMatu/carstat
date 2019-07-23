class NumberValidator {
  String numberValidator(String value) {
    if (value == null) {
      return null;
    }
    final n = num.tryParse(value);
    if (n == null) {
      return 'Введите число';
    }
    return null;
  }
}
