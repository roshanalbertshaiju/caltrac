import 'dart:math';

import 'exercise_set.dart';

class WorkoutExercise {
  final String id;
  final String exerciseName;
  final String category;
  final List<ExerciseSet> sets;
  final String? notes;

  const WorkoutExercise({
    required this.id,
    required this.exerciseName,
    required this.category,
    required this.sets,
    this.notes,
  });

  WorkoutExercise copyWith({
    String? id,
    String? exerciseName,
    String? category,
    List<ExerciseSet>? sets,
    String? notes,
  }) {
    return WorkoutExercise(
      id: id ?? this.id,
      exerciseName: exerciseName ?? this.exerciseName,
      category: category ?? this.category,
      sets: sets ?? this.sets,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exerciseName': exerciseName,
      'category': category,
      'sets': sets.map((s) => s.toJson()).toList(growable: false),
      'notes': notes,
    };
  }

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      id: json['id'] as String,
      exerciseName: json['exerciseName'] as String,
      category: json['category'] as String,
      sets: (json['sets'] as List<dynamic>)
          .map((e) => ExerciseSet.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
    );
  }

  double get totalVolume => sets.fold(0.0, (sum, s) => sum + s.volume);

  double get maxWeight =>
      sets.isEmpty ? 0 : sets.map((s) => s.weightKg).reduce(max);

  int get totalReps => sets.fold(0, (sum, s) => sum + s.reps);
}

