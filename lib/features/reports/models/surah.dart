class Surah {
  final int id;
  final String name;
  final int order;

  Surah(this.id, this.name, this.order);

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      json['id'],
      json['name'],
      json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'order': order,
    };
  }
}
