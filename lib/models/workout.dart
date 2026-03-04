import 'package:hive/hive.dart';

part 'workout.g.dart';

@HiveType(typeId: 0)
class Workout extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  DateTime dateTime;

  @HiveField(2)
  List<Exercise> exercises;

  @HiveField(3)
  bool completed;

  Workout({
    required this.name,
    required this.dateTime,
    required this.exercises,
    this.completed = false,
  });
}

@HiveType(typeId: 1)
class Exercise extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<ExerciseSet> sets;

  Exercise({
    required this.name,
    required this.sets,
  });
}

@HiveType(typeId: 2)
class ExerciseSet extends HiveObject {
  @HiveField(0)
  int reps;

  @HiveField(1)
  double weight;

  @HiveField(2)
  bool completed;

  ExerciseSet({
    required this.reps,
    required this.weight,
    this.completed = false,
  });
}
