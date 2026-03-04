import 'workout_exercise.dart';

class WorkoutSession {
  final String id;
  final String name;
  final DateTime startedAt;
  final DateTime? completedAt;
  final List<WorkoutExercise> exercises;
  final String? notes;

  const WorkoutSession({
    required this.id,
    required this.name,
    required this.startedAt,
    this.completedAt,
    required this.exercises,
    this.notes,
  });

  WorkoutSession copyWith({
    String? id,
    String? name,
    DateTime? startedAt,
    DateTime? completedAt,
    List<WorkoutExercise>? exercises,
    String? notes,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      name: name ?? this.name,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      exercises: exercises ?? this.exercises,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'exercises': exercises.map((e) => e.toJson()).toList(growable: false),
      'notes': notes,
    };
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'] as String,
      name: json['name'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => WorkoutExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
    );
  }

  Duration? get duration =>
      completedAt?.difference(startedAt);

  double get totalVolume =>
      exercises.fold(0.0, (sum, e) => sum + e.totalVolume);

  int get totalSets => exercises.fold(0, (sum, e) => sum + e.sets.length);
}

