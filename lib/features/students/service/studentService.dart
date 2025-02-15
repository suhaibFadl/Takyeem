import 'package:takyeem/features/reports/models/surah.dart';
import 'package:takyeem/features/students/models/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentService {
  // final SupabaseClient _supabase = Supabase.instance.client;
  final firestore = FirebaseFirestore.instance;

  Future<void> addStudent(Student student) async {
    await firestore.collection('Students').doc().set(student.toJson());
  }

  Future<List<Student>> getAllStudents() async {
    print("response: heeeere");

    final response = await firestore.collection('Students').get();
    List<Student> students = await Future.wait(response.docs.map((e) async {
      Map<String, dynamic> studentData = e.data();

      // Get the DocumentReference for Surah
      DocumentReference<Map<String, dynamic>> surahRef = studentData['surah'];

      // Fetch Surah data
      DocumentSnapshot<Map<String, dynamic>> surahSnapshot =
          await surahRef.get();
      print("surahSnapshot: ${surahSnapshot.data()}");
      // ✅ Modify e.data() to include the Surah object
      studentData['surah'] = surahSnapshot.data();

      // Pass the modified data to Student.fromJson()
      return Student.fromJson(studentData);
    }).toList());

    return students;
  }

  Future<Student> getStudentById(int id) async {
    final response =
        await firestore.collection('Students').doc(id.toString()).get();

    return Student.fromJson(response.data()!);
  }
}
