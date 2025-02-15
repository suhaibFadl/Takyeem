class Surah {
  final String uid;
  final String name;
  final int order;

  Surah({
    required this.uid,
    required this.name,
    required this.order,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      uid: json['uid'],
      name: json['name'],
      order: json['order'],
    );
  }
}
