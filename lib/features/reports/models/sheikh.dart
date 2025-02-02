class Sheikh {
  final int id;
  final String name;

  Sheikh({required this.id, required this.name});

  factory Sheikh.fromJson(Map<String, dynamic> json) {
    return Sheikh(
      id: json['id'],
      name: json['name'],
    );
  }
}
