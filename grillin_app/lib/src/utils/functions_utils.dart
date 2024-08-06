// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';

// Project imports:
import '../../values/k_colors.dart';
import '../../values/k_styles.dart';
import '../managers/page_manager.dart';

//Currency
String currencyFormat(double? price) {
  return price != null ? NumberFormat("#,##0.00", "en_US").format(price) : "-";
}

//Date
String dateFormat(DateTime? date) {
  return date != null ? DateFormat("dd/MM/yyyy").format(date) : "";
}

String getFormattedDateAndTime(DateTime value) {
  final DateFormat formatter = DateFormat("dd/MM/yyyy HH:mm");
  return formatter.format(value);
}

DateTime? dateToLocal(String? dateTimeString) {
  DateTime? dateTime;
  if (dateTimeString != null && dateTimeString.isNotEmpty) {
    dateTime = DateTime.tryParse(dateTimeString);
  }
  if (dateTime != null) {
    return dateTime.toLocal();
  }
  return null;
}

//Context
BuildContext getCurrentContext() {
  return PageManager().navigatorKey.currentContext!;
}

//Toast
void showToast({
  required String message,
  Duration duration = const Duration(seconds: 2),
  EdgeInsets padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  Color? color,
  BorderRadius? borderRadius,
  double fontSize = 14,
}) {
  SnackBar snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    elevation: 0,
    padding: const EdgeInsets.only(bottom: 70),
    duration: duration,
    backgroundColor: Colors.transparent,
    content: Padding(
      padding: EdgeInsets.only(
          bottom:
              MediaQuery.of(PageManager().currentContext).viewInsets.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                  color: color ?? KColors.black,
                  borderRadius: borderRadius ?? BorderRadius.circular(5),
                  boxShadow: [KStyles().toastShadow]),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: fontSize, color: KColors.white),
                maxLines: null,
              ),
            ),
          ),
        ],
      ),
    ),
  );
  ScaffoldMessenger.of(PageManager().currentContext).clearSnackBars();
  ScaffoldMessenger.of(PageManager().currentContext).showSnackBar(snackBar);
}
