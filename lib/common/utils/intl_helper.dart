import 'package:intl/intl.dart';

class IntlHelper {
  static String converToDate(DateTime date) {
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
  }
 static String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat("MMM-dd-yyyy hh:mm a");
  return formatter.format(dateTime);
}

 static String formteDate(DateTime dateTime) {
  final formatter = DateFormat("MMM-dd-yyyy");
  return formatter.format(dateTime);
}
 static String formteTime(DateTime dateTime) {
  final formatter = DateFormat("hh:mm a");
  return formatter.format(dateTime);
}}
