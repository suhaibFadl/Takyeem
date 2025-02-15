class Sheikh {
  final String uid;
  final String name;

  Sheikh({
    required this.uid,
    required this.name,
  });

  factory Sheikh.fromJson(Map<String, dynamic> json) {
    return Sheikh(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
