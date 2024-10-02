import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final phonenumberFormatter = NumberFormat("### 0#", "en_US");

formatPhoneNumber(String phone) {
  return phone
      .replaceAllMapped(
        RegExp(r'(\d{2})'),
        (Match match) => '${match.group(1)} ',
      )
      .trim();
}

final formatter = NumberFormat("#,##0", "fr_FR");

formatAmount(double montant) {
  String formattedNumber = formatter.format(montant);
  return formattedNumber;
}

abstract class Formatter {
  Formatter._();

  static String formatDateTime(DateTime dateTime) {
    final DateFormat dateFormat = DateFormat('hh:mm a');
    return dateFormat.format(dateTime);
  }
}

class PairSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final newText = _formatText(newValue.text);
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  String _formatText(String input) {
    input = input.replaceAll(' ', ''); // Remove existing spaces
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      if (i % 2 == 0 && i != 0) {
        buffer.write(' ');
      }
      buffer.write(input[i]);
    }
    return buffer.toString();
  }
}
