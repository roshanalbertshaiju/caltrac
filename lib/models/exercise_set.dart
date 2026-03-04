class ExerciseSet {
  final String id;
  final int reps;
  final double weightKg;
  final Duration? restDuration;

  const ExerciseSet({
    required this.id,
    required this.reps,
    required this.weightKg,
    this.restDuration,
  });

  ExerciseSet copyWith({
    String? id,
    int? reps,
    double? weightKg,
    Duration? restDuration,
  }) {
    return ExerciseSet(
      id: id ?? this.id,
      reps: reps ?? this.reps,
      weightKg: weightKg ?? this.weightKg,
      restDuration: restDuration ?? this.restDuration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reps': reps,
      'weightKg': weightKg,
      'restDurationMs': restDuration?.inMilliseconds,
    };
  }

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      id: json['id'] as String,
      reps: (json['reps'] as num).toInt(),
      weightKg: (json['weightKg'] as num).toDouble(),
      restDuration: json['restDurationMs'] != null
          ? Duration(milliseconds: (json['restDurationMs'] as num).toInt())
          : null,
    );
  }

  double get volume => reps * weightKg;
}

