import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double amount) {
    final format = NumberFormat.currency(locale: 'fr_MR', symbol: 'MRU', decimalDigits: 0);
    return format.format(amount);
  }

  static String formatDate(DateTime date) {
    final format = DateFormat('dd/MM/yyyy HH:mm');
    return format.format(date);
  }
  
  static String formatShortDate(DateTime date) {
    final format = DateFormat('dd/MM/yyyy');
    return format.format(date);
  }
}
