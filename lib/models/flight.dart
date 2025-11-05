class Flight {
  double duration;

  Flight({required this.duration});

  factory Flight.fromJson(Map<String, Object?> json) {
    return Flight(duration: (json['duration'] as double?) ?? 0.0);
  }

  Flight copyWith({double? duration}) {
    return Flight(duration: duration ?? this.duration);
  }

  Map<String, Object?> toJson() {
    return {"duration": duration};
  }
}
