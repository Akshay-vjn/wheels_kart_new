import 'package:intl/intl.dart';

class IntlHelper {
  static String converToDate(DateTime date) {
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
  }
}
