class DailyRecordType {
  final int id;
  final String name;

  DailyRecordType({required this.id, required this.name});

  factory DailyRecordType.fromJson(Map<String, dynamic> json) {
    return DailyRecordType(
      id: json['id'],
      name: json['name'],
    );
  }
}
