import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:takyeem/features/date/models/hijri_month.dart';

class DateService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> insertMonth(HijriMonth month) async {
    await supabase.from('hijri_months').insert(month.toJson());
  }

  Future<HijriMonth?> getMonthByNameAndYear(String name, int year) async {
    final response = await supabase
        .from('hijri_months')
        .select('*')
        .eq('name', name)
        .eq('year', year);

    return response.isEmpty ? null : HijriMonth.fromJson(response[0]);
  }

  Future<void> createNewMonth(HijriMonth month) async {
    await supabase.from('hijri_months').insert(month.toJson());
  }
}
