import 'package:hive_flutter/hive_flutter.dart';
import '../models/workout.dart';

class HiveService {
  static const String workoutBoxName = 'workouts';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(WorkoutAdapter());
    Hive.registerAdapter(ExerciseAdapter());
    Hive.registerAdapter(ExerciseSetAdapter());
    await Hive.openBox<Workout>(workoutBoxName);
  }

  static Box<Workout> get workoutBox => Hive.box<Workout>(workoutBoxName);

  static Future<void> addWorkout(Workout workout) async {
    await workoutBox.add(workout);
  }

  static List<Workout> getWorkouts() {
    return workoutBox.values.toList();
  }

  static Future<void> updateWorkout(int key, Workout workout) async {
    await workoutBox.put(key, workout);
  }

  static Future<void> deleteWorkout(int key) async {
    await workoutBox.delete(key);
  }
}
