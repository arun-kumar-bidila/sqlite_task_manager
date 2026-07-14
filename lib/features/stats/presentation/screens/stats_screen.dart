import 'package:flutter/material.dart';
import 'package:task_manager/constants/theme/app_colors.dart';
import 'package:task_manager/features/stats/presentation/widgets/priority_breakdown.dart';

import 'package:task_manager/features/stats/presentation/widgets/task_stats.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              "Statistics",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
            SizedBox(height: 16),
            TaskStats(),
            SizedBox(height: 16),
            PriorityBreakdown(),
          ],
        ),
      ),
    );
  }
}
