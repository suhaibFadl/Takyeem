class DailyRecordStatus {
  final String uid;
  final String name;

  DailyRecordStatus({required this.uid, required this.name});

  factory DailyRecordStatus.fromJson(Map<String, dynamic> json) {
    return DailyRecordStatus(
      uid: json['uid'],
      name: json['name'],
    );
  }
}
