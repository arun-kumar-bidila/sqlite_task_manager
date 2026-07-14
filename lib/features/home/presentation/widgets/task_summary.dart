import 'package:flutter/material.dart';
import 'package:task_manager/constants/theme/app_colors.dart';

class TaskSummary extends StatefulWidget {
  final int todayTasks;
  final int pendingTasks;
  final int completedTasks;
  final int overdueTasks;
  const TaskSummary({
    super.key,
    required this.todayTasks,
    required this.pendingTasks,
    required this.completedTasks,
    required this.overdueTasks,
  });

  @override
  State<TaskSummary> createState() => _TaskSummaryState();
}

class _TaskSummaryState extends State<TaskSummary> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildSummaryCard(
              cardValue: widget.todayTasks.toString(),
              cardLabel: "Today",
              cardBg: AppColors.cardBgColor,
              cardValueColor: AppColors.violet,
            ),
            SizedBox(width: 12),
            _buildSummaryCard(
              cardValue: widget.completedTasks.toString(),
              cardLabel: "Done",
              cardBg: AppColors.darkGreen,
              cardValueColor: AppColors.lightGreen,
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            _buildSummaryCard(
              cardValue: widget.pendingTasks.toString(),
              cardLabel: "Pending",
              cardBg: AppColors.darkOrange,
              cardValueColor: AppColors.lightOrange,
            ),
            SizedBox(width: 12),
            _buildSummaryCard(
              cardValue: widget.overdueTasks.toString(),
              cardLabel: "Overdue",
              cardBg: AppColors.darkRed,
              cardValueColor: AppColors.lightRed,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String cardValue,
    required String cardLabel,
    required Color cardBg,
    required Color cardValueColor,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: cardBg,
          border: Border.all(width: 1, color: cardValueColor.withAlpha(81)),
        ),
        child: Column(
          children: [
            Text(
              cardValue,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: cardValueColor,
              ),
            ),
            SizedBox(height: 12),
            Text(
              cardLabel.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
