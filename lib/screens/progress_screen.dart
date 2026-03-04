import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('progress'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.show_chart, size: 56),
            SizedBox(height: 12),
            Text(
              'Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'Charts + PRs screen coming next.',
              textAlign: TextAlign.center,
              style: TextStyle(color: kTextSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

