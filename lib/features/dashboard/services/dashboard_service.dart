import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<int> getTotalStudents() async {
    final response = await _supabase.from('Students').select('*');
    return response.length;
  }

  Future<int> getAttendances() async {
    DateTime toDate = DateTime.now();
    DateTime fromDate = DateTime(toDate.year, toDate.month, toDate.day, 0, 0);

    final response = await _supabase
        .from('StudentDailyRecord')
        .select('*')
        .gte('date',
            fromDate.toIso8601String()) // Use gte for greater than or equal to
        .lt('date', toDate.toIso8601String());
    return response.length;
  }

  Future<int> getTotalByType(String type) async {
    DateTime toDate = DateTime.now();
    DateTime fromDate = DateTime(toDate.year, toDate.month, toDate.day, 0, 0);
    final response = await _supabase
        .from('StudentDailyRecord')
        .select('*') // Fetch data
        .eq('type', type)
        .gte('date', fromDate.toIso8601String())
        .lt('date', toDate.toIso8601String());
    return response.length;
  }
}
