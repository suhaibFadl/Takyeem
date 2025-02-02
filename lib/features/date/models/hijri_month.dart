class HijriMonth {
  final String name;
  final int year;
  final int shift;

  HijriMonth({
    required this.name,
    required this.year,
    required this.shift,
  });

  factory HijriMonth.fromJson(Map<String, dynamic> json) {
    return HijriMonth(
      name: json['name'],
      year: json['year'],
      shift: json['shift'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'year': year,
      'shift': shift,
    };
  }
}
