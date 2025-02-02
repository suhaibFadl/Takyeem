class DailyRecordStatus {
  final int id;
  final String name;

  DailyRecordStatus({required this.id, required this.name});

  factory DailyRecordStatus.fromJson(Map<String, dynamic> json) {
    return DailyRecordStatus(
      id: json['id'],
      name: json['name'],
    );
  }
}
