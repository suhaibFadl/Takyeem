class DailyRecordType {
  final String uid;
  final String name;

  DailyRecordType({
    required this.uid,
    required this.name,
  });

  factory DailyRecordType.fromJson(Map<String, dynamic> json) {
    return DailyRecordType(
      uid: json['uid'],
      name: json['name'],
    );
  }
}
