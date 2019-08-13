import 'package:intl/intl.dart';

class DateValidator {

  DateTime convertToDate(String input) {
    try
    {
      var d = DateFormat('dd.MM.yyyy').parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  bool isValidDate(String date) {
    if (date.isEmpty) return true;
    var d = convertToDate(date);
    return d != null && d.isBefore(new DateTime.now());
  }

}