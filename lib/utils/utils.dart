import 'package:intl/intl.dart';

String formatDate({
  String inputStringDate = "", 
  String inputFormat = "yyyy-MM-dd", 
  String outputFormat = "dd MMMM yyyy"
}) {
  DateTime date = DateTime.parse(inputStringDate);
  return DateFormat("dd MMMM yyyy").format(date);
}