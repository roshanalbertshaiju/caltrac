import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('dashboard'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: kAccentGradient,
            borderRadius: kCardRadius,
            border: const Border.fromBorderSide(
              BorderSide(color: kBorder, width: 1),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ready to train?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Weekly stats coming next.',
                style: TextStyle(color: kTextSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(Icons.play_circle_outline, size: 56),
                SizedBox(height: 12),
                Text(
                  'Start a Workout',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Active session + exercise logging is being wired up next.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kTextSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

