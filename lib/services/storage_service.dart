import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/exercise_set.dart';
import '../models/personal_record.dart';
import '../models/workout_session.dart';

class StorageService {
  static const String _activeSessionKey = 'active_session_v1';
  static const String _sessionsKey = 'completed_sessions_v1';
  static const String _personalRecordsKey = 'personal_records_v1';

  static Future<void> initializeStorage() async {
    await SharedPreferences.getInstance();
  }

  static Future<bool> saveActiveSession(WorkoutSession session) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_activeSessionKey, jsonEncode(session.toJson()));
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<WorkoutSession?> loadActiveSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_activeSessionKey);
      if (raw == null) return null;
      return WorkoutSession.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> clearActiveSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.remove(_activeSessionKey);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> saveCompletedSession(WorkoutSession session) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existing = prefs.getStringList(_sessionsKey) ?? [];
      existing.add(jsonEncode(session.toJson()));
      await prefs.setStringList(_sessionsKey, existing);
      await _updatePersonalRecordsFromCompletedSession(session);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<List<WorkoutSession>> loadAllSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList(_sessionsKey) ?? [];
      final sessions = raw
          .map((e) => WorkoutSession.fromJson(jsonDecode(e) as Map<String, dynamic>))
          .toList();
      sessions.sort((a, b) {
        final ad = a.completedAt ?? a.startedAt;
        final bd = b.completedAt ?? b.startedAt;
        return bd.compareTo(ad);
      });
      return sessions;
    } catch (_) {
      return [];
    }
  }

  static Future<bool> deleteSession(String sessionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList(_sessionsKey) ?? [];
      final kept = raw.where((e) {
        try {
          final json = jsonDecode(e) as Map<String, dynamic>;
          return (json['id'] as String?) != sessionId;
        } catch (_) {
          return true;
        }
      }).toList(growable: false);
      await prefs.setStringList(_sessionsKey, kept);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> savePersonalRecords(List<PersonalRecord> records) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded =
          records.map((r) => jsonEncode(r.toJson())).toList(growable: false);
      await prefs.setStringList(_personalRecordsKey, encoded);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<List<PersonalRecord>> loadPersonalRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList(_personalRecordsKey) ?? [];
      final prs = raw
          .map((e) => PersonalRecord.fromJson(jsonDecode(e) as Map<String, dynamic>))
          .toList();
      prs.sort((a, b) => a.exerciseName.toLowerCase().compareTo(b.exerciseName.toLowerCase()));
      return prs;
    } catch (_) {
      return [];
    }
  }

  static Future<bool> updatePersonalRecord(PersonalRecord record) async {
    try {
      final prs = await loadPersonalRecords();
      final idx = prs.indexWhere(
        (r) => r.exerciseName.toLowerCase() == record.exerciseName.toLowerCase(),
      );
      if (idx >= 0) {
        // Replace only if the new record is "better" by estimated 1RM, tie-break by weight.
        final current = prs[idx];
        final current1rm = _estimate1rm(current.weightKg, current.reps);
        final next1rm = _estimate1rm(record.weightKg, record.reps);
        if (next1rm > current1rm ||
            (next1rm == current1rm && record.weightKg > current.weightKg)) {
          prs[idx] = record;
        }
      } else {
        prs.add(record);
      }
      return savePersonalRecords(prs);
    } catch (_) {
      return false;
    }
  }

  static Future<List<PersonalRecord>> _updatePersonalRecordsFromCompletedSession(
    WorkoutSession session,
  ) async {
    final achieved = <PersonalRecord>[];
    final completedAt = session.completedAt ?? DateTime.now();

    for (final ex in session.exercises) {
      if (ex.sets.isEmpty) continue;

      ExerciseSet? bestSet;
      double bestScore = -1;
      for (final s in ex.sets) {
        if (s.reps <= 0 || s.weightKg <= 0) continue;
        final score = _estimate1rm(s.weightKg, s.reps);
        if (score > bestScore) {
          bestScore = score;
          bestSet = s;
        }
      }
      if (bestSet == null) continue;

      final pr = PersonalRecord(
        exerciseName: ex.exerciseName,
        weightKg: bestSet.weightKg,
        reps: bestSet.reps,
        achievedAt: completedAt,
        sessionId: session.id,
      );
      final ok = await updatePersonalRecord(pr);
      if (ok) {
        achieved.add(pr);
      }
    }

    return achieved;
  }

  static double _estimate1rm(double weightKg, int reps) {
    // Epley: 1RM = w * (1 + reps/30)
    if (reps <= 0) return 0;
    return weightKg * (1 + reps / 30.0);
  }
}
