class ViewTypeEntity {
  final String name;
  int total;
  int passed;

  ViewTypeEntity(
      {required this.name, required this.total, required this.passed});

  factory ViewTypeEntity.fromJson(Map<String, dynamic> json) {
    return ViewTypeEntity(
      name: json['name'],
      total: json['total'],
      passed: json['passed'],
    );
  }
}
