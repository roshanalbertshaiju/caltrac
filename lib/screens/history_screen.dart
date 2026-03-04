import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('history'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.calendar_month, size: 56),
            SizedBox(height: 12),
            Text(
              'History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'Completed sessions list + grouping + detail view coming next.',
              textAlign: TextAlign.center,
              style: TextStyle(color: kTextSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

