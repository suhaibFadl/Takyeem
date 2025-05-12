import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:takyeem/features/dashboard/entities/view_type.dart';

class DashboardService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<int> getTotalStudents() async {
    final response =
        await _supabase.from('Students').select('*').eq('isActive', true);
    return response.length;
  }

  Future<int> getAttendances() async {
    DateTime toDate = DateTime.now();
    DateTime fromDate = DateTime(toDate.year, toDate.month, toDate.day, 0, 0);

    final typeResponse = await _supabase
        .from('DailyRecordType')
        .select('*')
        .neq('name', 'غائب بعذر')
        .neq('name', 'غائب بدون عذر');

    debugPrint('typeResponse: ${typeResponse.toString()}');
    final response = await _supabase
        .from('StudentDailyRecord')
        .select('*')
        .inFilter('type_id', typeResponse.map((e) => e['id']).toList())
        .gte('date',
            fromDate.toIso8601String()) // Use gte for greater than or equal to
        .lt('date', toDate.toIso8601String());
    debugPrint('response: ${response.length}');
    return response.length;
  }

  Future<int> getAbsentees() async {
    DateTime toDate = DateTime.now();
    DateTime fromDate = DateTime(toDate.year, toDate.month, toDate.day, 0, 0);

    final typeResponse = await _supabase
        .from('DailyRecordType')
        .select('id')
        .inFilter('name', ['غائب بعذر', 'غائب بدون عذر']);

    final response = await _supabase
        .from('StudentDailyRecord')
        .select('*')
        .inFilter('type_id', typeResponse.map((e) => e['id']).toList())
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
        .select('*')
        .eq('type', type)
        .neq('status', 'لم يسمع')
        .gte('date', fromDate.toIso8601String())
        .lt('date', toDate.toIso8601String());
    return response.length;
  }

  Future<Map<String, ViewTypeEntity>?> getTotalByTypeList() async {
    DateTime toDate = DateTime.now();
    DateTime fromDate = DateTime(toDate.year, toDate.month, toDate.day, 0, 0);

    final response = await _supabase
        .from('StudentDailyRecord')
        .select('*, DailyRecordType(*)')
        .neq('status', 'لم يسمع')
        .gte('date', fromDate.toIso8601String())
        .lt('date', toDate.toIso8601String())
        .order('DailyRecordType(priority)', ascending: true);

    Map<String, ViewTypeEntity> map = {};

    for (var record in response) {
      if (!map.containsKey(record['DailyRecordType']['name'])) {
        map[record['DailyRecordType']['name']] = ViewTypeEntity(
            name: record['DailyRecordType']['name'], total: 0, passed: 0);
      }

      map[record['DailyRecordType']['name']]!.total++;

      if (record['status'] == 'حفظ') {
        map[record['DailyRecordType']['name']]!.passed++;
      }
    }
    return map;
  }

  // Future<void> populateTypeIdsFromTypeNames() async {
  //   try {
  //     // 1. Fetch all DailyRecordType records to create a name-to-ID map
  //     final dailyRecordTypesResponse =
  //         await _supabase.from('DailyRecordType').select('id, name');

  //     if (dailyRecordTypesResponse.isEmpty) {
  //       debugPrint(
  //           'No entries found in DailyRecordType. Cannot map names to IDs.');
  //       return;
  //     }

  //     final Map<String, int> typeNameToIdMap = {
  //       for (var typeEntry in dailyRecordTypesResponse)
  //         typeEntry['name'] as String: typeEntry['id'] as int,
  //     };

  //     // 2. Fetch StudentDailyRecord entries for today
  //     final DateTime now = DateTime.now();
  //     final DateTime todayStart = DateTime(now.year, now.month, now.day);
  //     final DateTime tomorrowStart = DateTime(now.year, now.month, now.day + 1);

  //     final studentRecordsResponse = await _supabase
  //         .from('StudentDailyRecord')
  //         .select('id, type, type_id')
  //         .gte('date', todayStart.toIso8601String())
  //         .lt('date', tomorrowStart.toIso8601String());

  //     if (studentRecordsResponse.isEmpty) {
  //       debugPrint('No StudentDailyRecord entries found to process.');
  //       return;
  //     }

  //     List<Map<String, dynamic>> recordsToUpdate = [];

  //     // 3. Iterate through student records, identify those needing typeId update
  //     for (var record in studentRecordsResponse) {
  //       final recordId = record['id'] as int;
  //       final typeName =
  //           record['type'] as String?; // The string name of the type
  //       final currentTypeId = record['type_id']; // The current integer type_id

  //       if (typeName != null && typeNameToIdMap.containsKey(typeName)) {
  //         final expectedTypeId = typeNameToIdMap[typeName]!;
  //         // If type_id is null or doesn't match the expected ID from the type name
  //         if (currentTypeId == null || currentTypeId != expectedTypeId) {
  //           recordsToUpdate.add({
  //             'id': recordId, // Primary key for the update
  //             'type_id': expectedTypeId, // The new type_id to set
  //           });
  //         }
  //       } else if (typeName != null) {
  //         // Type name exists in StudentDailyRecord but not in DailyRecordType map
  //         debugPrint(
  //             'Warning: Type name "$typeName" found in StudentDailyRecord (id: $recordId) but not in DailyRecordType table. Cannot set type_id.');
  //       }
  //     }

  //     // 4. Perform batch update if there are records to update
  //     if (recordsToUpdate.isNotEmpty) {
  //       await _supabase.from('StudentDailyRecord').upsert(recordsToUpdate);
  //       debugPrint(
  //           'Successfully processed ${recordsToUpdate.length} StudentDailyRecord(s) for typeId update.');
  //     } else {
  //       debugPrint('No StudentDailyRecord entries required a typeId update.');
  //     }
  //   } catch (e) {
  //     debugPrint('Error during populateTypeIdsFromTypeNames: ${e.toString()}');
  //     rethrow;
  //   }
  // }
}
