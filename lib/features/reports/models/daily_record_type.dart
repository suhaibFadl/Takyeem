class DailyRecordType {
  final int id;
  final String name;
  final double priority;

  DailyRecordType({
    required this.id,
    required this.name,
    required this.priority,
  });

  factory DailyRecordType.fromJson(Map<String, dynamic> json) {
    return DailyRecordType(
      id: json['id'],
      name: json['name'],
      priority: double.parse(json['priority'].toString()),
    );
  }
}
