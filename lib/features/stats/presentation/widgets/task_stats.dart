import 'package:flutter/material.dart';
import 'package:task_manager/constants/theme/app_colors.dart';
import 'package:task_manager/core/db_helper.dart';

class TaskStats extends StatefulWidget {
  const TaskStats({super.key});

  @override
  State<TaskStats> createState() => _TaskStatsState();
}

class _TaskStatsState extends State<TaskStats> {
  int todayTasks = 0;
  int pendingTasks = 0;
  int completedTasks = 0;
  int overdueTasks = 0;
  DbHelper dbRef = DbHelper.instance;
  @override
  void initState() {
    super.initState();
    fetchTaskSummary();
  }

  void fetchTaskSummary() async {
    todayTasks = await dbRef.fetchTodayTasks();
    pendingTasks = await dbRef.fetchTodayPendingTasks();
    completedTasks = await dbRef.fetchTodayCompletedTasks();
    overdueTasks = await dbRef.fetchOverDueTasks();
    setState(() {});
  }

  int calculateCompletion({required int total, required int completed}) {
    if (total == 0 || completed == 0) {
      return 0;
    }
    return completed % total;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildSummaryCard(
              cardValue: completedTasks.toString(),
              cardLabel: "Completed Today",
              cardBg: AppColors.darkGreen,
              cardValueColor: AppColors.lightGreen,
            ),

            SizedBox(width: 12),
            _buildSummaryCard(
              cardValue: pendingTasks.toString(),
              cardLabel: "Pending",
              cardBg: AppColors.darkOrange,
              cardValueColor: AppColors.lightOrange,
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            _buildSummaryCard(
              cardValue: overdueTasks.toString(),
              cardLabel: "Overdue",
              cardBg: AppColors.darkRed,
              cardValueColor: AppColors.lightRed,
            ),
            SizedBox(width: 12),
            _buildSummaryCard(
              cardValue:
                  "${calculateCompletion(total: todayTasks, completed: completedTasks)}%",
              cardLabel: "Completion",
              cardBg: AppColors.cardBgColor,
              cardValueColor: AppColors.violet,
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
