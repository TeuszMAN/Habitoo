class User {
  final String id;
  final String name;
  final String email;
  final DateTime? birthDate;
  final double? weight;
  final double? height;
  final DateTime createdAt;
  final bool hasCompletedRegistration;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.birthDate,
    this.weight,
    this.height,
    DateTime? createdAt,
    this.hasCompletedRegistration = false,
  }) : createdAt = createdAt ?? DateTime.now();

  int? get age {
    if (birthDate == null) return null;
    final now = DateTime.now();
    int age = now.year - birthDate!.year;
    if (now.month < birthDate!.month ||
        (now.month == birthDate!.month && now.day < birthDate!.day)) {
      age--;
    }
    return age;
  }

  double? get bmi {
    if (weight == null || height == null) return null;
    if (height! <= 0) return null;
    return weight! / (height! * height!);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'birthDate': birthDate?.toIso8601String(),
      'weight': weight,
      'height': height,
      'createdAt': createdAt.toIso8601String(),
      'hasCompletedRegistration': hasCompletedRegistration,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      birthDate:
          map['birthDate'] != null
              ? DateTime.parse(map['birthDate'] as String)
              : null,
      weight: map['weight']?.toDouble(),
      height: map['height']?.toDouble(),
      createdAt: DateTime.parse(map['createdAt'] as String),
      hasCompletedRegistration: map['hasCompletedRegistration'] as bool,
    );
  }

  User copyWith({
    String? name,
    String? email,
    DateTime? birthDate,
    double? weight,
    double? height,
    bool? hasCompletedRegistration,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      createdAt: createdAt,
      hasCompletedRegistration:
          hasCompletedRegistration ?? this.hasCompletedRegistration,
    );
  }
}
