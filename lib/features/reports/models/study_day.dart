class StudyDay {
  final int id;
  final String englishName;
  final String arabicName;

  StudyDay(
      {required this.id, required this.englishName, required this.arabicName});

  factory StudyDay.fromJson(Map<String, dynamic> json) {
    return StudyDay(
        id: json['id'],
        englishName: json['english_name'],
        arabicName: json['arabic_name']);
  }
}
