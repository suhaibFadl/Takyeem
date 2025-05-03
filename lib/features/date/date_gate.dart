
import 'dart:developer';

import 'package:hijri/hijri_calendar.dart';
import 'package:takyeem/features/date/date_service.dart';
import 'package:takyeem/features/date/models/today.dart';

class DateGate {
  final DateService dateService = DateService();

  Future<Today?> getHijriDate(DateTime date) async {
    var hDate = HijriCalendar.fromDate(date);
    var currentHijriMonth = await dateService.getMonthByNameAndYear(
      hDate.longMonthName,
      hDate.hYear,
    );
    log("Hijri Month: $currentHijriMonth");
    if (currentHijriMonth == null) return null;

    final shiftedDate =
        DateTime.now().subtract(Duration(days: currentHijriMonth.shift));
    final shiftedHijri = HijriCalendar.fromDate(shiftedDate);
    final monthName = shiftedHijri.longMonthName;
    final year = shiftedHijri.hYear;
    final day = shiftedHijri.hDay;
    final wday = hDate.getDayName();

    return Today(wday, monthName, year, day);
  }
}
