class AddStudentEntity {
  final String firstName;
  final String fatherName;
  final String lastName;
  final DateTime bornDate;
  final DateTime joiningDate;
  final String phoneNumber;
  final String quardianPhoneNumber;

  AddStudentEntity({
    required this.firstName,
    required this.fatherName,
    required this.lastName,
    required this.bornDate,
    required this.joiningDate,
    required this.phoneNumber,
    required this.quardianPhoneNumber,
  });

  factory AddStudentEntity.fromJson(Map<String, dynamic> json) {
    return AddStudentEntity(
      firstName: json['first_name'] ?? 'Unknown', // Handle null
      fatherName: json['father_name'] ?? 'Unknown', // Handle null
      lastName: json['last_name'] ?? 'Unknown', // Handle null
      bornDate: json['born_date'] is String
          ? DateTime.parse(json['born_date'])
          : DateTime.tryParse(json['born_date']?.toString() ?? '') ??
              DateTime.now(),
      joiningDate: json['joining_date'] is String
          ? DateTime.parse(json['joining_date'])
          : DateTime.tryParse(json['joining_date']?.toString() ?? '') ??
              DateTime.now(),
      phoneNumber: json['phone_number'] ?? 'Unknown', // Handle null
      quardianPhoneNumber:
          json['quardian_phone_number'] ?? 'Unknown', // Handle null
    );
  }
}
