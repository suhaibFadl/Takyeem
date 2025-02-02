import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:takyeem/features/students/models/student.dart';

class StudentService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> addStudent(Student student) async {
    await _supabase.from('Students').insert(student.toJson());
  }

  Future<List<Student>> getAllStudents() async {
    final response = await _supabase.from('Students').select('*, Surah(*)');
    return response.map((e) => Student.fromJson(e)).toList();
  }

  Future<List<Student>> getStudentById(int id) async {
    final response =
        await _supabase.from('Students').select('*, Surah(*)').eq('id', id);

    return response.map((e) => Student.fromJson(e)).toList();
  }
}
