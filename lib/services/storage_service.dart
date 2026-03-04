import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _workoutHistoryKey = 'workout_history';

  /// Save a completed workout (name + timestamp) to local storage
  static Future<void> saveWorkout(String workout) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final entry = '$workout | ${now.toIso8601String()}';
    final history = prefs.getStringList(_workoutHistoryKey) ?? [];
    history.add(entry);
    await prefs.setStringList(_workoutHistoryKey, history);
  }

  /// Load all completed workouts from local storage
  static Future<List<String>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_workoutHistoryKey) ?? [];
  }
}
