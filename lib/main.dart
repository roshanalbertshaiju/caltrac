
import 'package:flutter/material.dart';

import 'services/storage_service.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WorkoutTrackerApp());
}

class WorkoutTrackerApp extends StatelessWidget {
  const WorkoutTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workout Tracker',
      theme: _buildDarkTheme(),
      home: const HomeDashboard(),
    );
  }
}

ThemeData _buildDarkTheme() {
  const accentColor = Color(0xFFFFD700); // Gold
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF181818),
    primaryColor: accentColor,
    colorScheme: ColorScheme.dark(
      primary: accentColor,
      secondary: accentColor,
      surface: Color(0xFF232323),
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFF232323),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      elevation: 4,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 20, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 18, color: Colors.white),
      bodySmall: TextStyle(fontSize: 16, color: Colors.white),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF181818),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    useMaterial3: true,
  );
}

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final GlobalKey<_WorkoutListState> _workoutListKey = GlobalKey<_WorkoutListState>();

  void _handleAddWorkout(String workout) {
    // Optionally handle additional logic here if needed
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏠 Workout Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Workout History',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const WorkoutHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: WorkoutList(
        key: _workoutListKey,
        onAddWorkout: _handleAddWorkout,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddWorkoutDialog(
              onAdd: (workout) {
                _workoutListKey.currentState?._addWorkout(workout);
              },
            ),
          );
        },
        tooltip: 'Add Workout',
        child: const Icon(Icons.add),
      ),
    );
  }
}


class WorkoutList extends StatefulWidget {
  final Function(String) onAddWorkout;

  const WorkoutList({super.key, required this.onAddWorkout});

  @override
  State<WorkoutList> createState() => _WorkoutListState();
}


class _WorkoutListState extends State<WorkoutList> {
  final List<String> _workouts = [
    'Push Ups',
    'Squats',
    'Plank',
  ];

  void _addWorkout(String workout) {
    setState(() {
      _workouts.add(workout);
    });
    widget.onAddWorkout(workout);
  }

  void _markAsComplete(int index) async {
    setState(() {
      final completed = _workouts.removeAt(index);
      StorageService.saveWorkout('${completed} (${_formatDateTime(DateTime.now())})');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Marked as complete!')),
    );
  }

  static String _formatDateTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  // Removed of() and findAncestorStateOfType usage

  // completedWorkouts now stored in SharedPreferences

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _workouts.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(_workouts[index]),
            trailing: IconButton(
              icon: const Icon(Icons.check_circle_outline),
              tooltip: 'Mark as Complete',
              onPressed: () => _markAsComplete(index),
            ),
          ),
        );
      },
    );
  }
}


class AddWorkoutDialog extends StatefulWidget {
  final Function(String) onAdd;

  const AddWorkoutDialog({super.key, required this.onAdd});

  @override
  State<AddWorkoutDialog> createState() => _AddWorkoutDialogState();
}


class _AddWorkoutDialogState extends State<AddWorkoutDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Workout'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Workout name'),
        onSubmitted: (value) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _submit() {
    final workout = _controller.text.trim();
    if (workout.isNotEmpty) {
      widget.onAdd(workout);
      Navigator.of(context).pop();
    }
  }
}

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  List<String> _history = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await StorageService.loadHistory();
    setState(() {
      _history = history;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? const Center(child: Text('No workout history yet.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(_history[index]),
                      ),
                    );
                  },
                ),
    );
  }
}
