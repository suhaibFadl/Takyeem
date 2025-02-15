import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:takyeem/features/date/models/hijri_month.dart';

class DateService {
  final firestore = FirebaseFirestore.instance;

  Future<void> insertMonth(HijriMonth month) async {
    await firestore.collection('hijri_months').doc().set(month.toJson());
  }

  Future<HijriMonth?> getMonthByNameAndYear(String name, int year) async {
    final response = await firestore
        .collection('HijriMonth')
        .where('name', isEqualTo: name)
        .where('year', isEqualTo: year)
        .get();

    return HijriMonth.fromJson(response.docs[0].data());
  }

  Future<void> createNewMonth(HijriMonth month) async {
    await firestore.collection('hijri_months').doc().set(month.toJson());
  }
}
