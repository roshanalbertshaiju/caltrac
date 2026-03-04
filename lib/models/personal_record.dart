class PersonalRecord {
  final String exerciseName;
  final double weightKg;
  final int reps;
  final DateTime achievedAt;
  final String sessionId;

  const PersonalRecord({
    required this.exerciseName,
    required this.weightKg,
    required this.reps,
    required this.achievedAt,
    required this.sessionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'exerciseName': exerciseName,
      'weightKg': weightKg,
      'reps': reps,
      'achievedAt': achievedAt.toIso8601String(),
      'sessionId': sessionId,
    };
  }

  factory PersonalRecord.fromJson(Map<String, dynamic> json) {
    return PersonalRecord(
      exerciseName: json['exerciseName'] as String,
      weightKg: (json['weightKg'] as num).toDouble(),
      reps: (json['reps'] as num).toInt(),
      achievedAt: DateTime.parse(json['achievedAt'] as String),
      sessionId: json['sessionId'] as String,
    );
  }
}

