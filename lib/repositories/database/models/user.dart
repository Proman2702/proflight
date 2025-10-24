class User {
  String id;
  double flyHours;

  User({required this.id, required this.flyHours});

  factory User.fromJson(Map<String, Object?> json) {
    return User(id: (json['id'] as String?) ?? '', flyHours: (json['flyHours'] as double?) ?? 0.0);
  }

  User copyWith({String? id, double? flyHours}) {
    return User(id: id ?? this.id, flyHours: flyHours ?? this.flyHours);
  }

  Map<String, Object?> toJson() {
    return {"id": id, "flyHours": flyHours};
  }
}
