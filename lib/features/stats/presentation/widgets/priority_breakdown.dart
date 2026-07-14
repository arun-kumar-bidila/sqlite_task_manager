import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/constants/theme/app_colors.dart';
import 'package:task_manager/core/db_helper.dart';

class PriorityBreakdown extends StatefulWidget {
  const PriorityBreakdown({super.key});

  @override
  State<PriorityBreakdown> createState() => _PriorityBreakdownState();
}

class _PriorityBreakdownState extends State<PriorityBreakdown> {
  int highPriority = 0;
  int lowPriority = 0;
  int mediumPriority = 0;
  final dbRef = DbHelper.instance;

  @override
  void initState() {
    super.initState();
    fetchPriorityTasks();
  }

  Future<void> fetchPriorityTasks() async {
    highPriority = await dbRef.fetchPriorityTasks(priority: "High");
    lowPriority = await dbRef.fetchPriorityTasks(priority: "Low");
    mediumPriority = await dbRef.fetchPriorityTasks(priority: "Medium");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1, color: AppColors.grey),
        color: Color(0xFF141624),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            "Priority Breakdown",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 32),
          SizedBox(
            height: 100,

            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: highPriority.ceilToDouble(),
                    color: AppColors.lightRed,
                    radius: 30,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: lowPriority.ceilToDouble(),
                    color: AppColors.lightGreen,
                    radius: 30,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: mediumPriority.ceilToDouble(),
                    color: AppColors.lightOrange,
                    radius: 30,
                    showTitle: false,
                  ),
                ],
                centerSpaceRadius: 30,
                centerSpaceColor: Color(0xFF141624),
              ),
            ),
          ),
          SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _legendItem(
                color: AppColors.lightRed,
                text: "High ($highPriority)",
              ),
              _legendItem(
                color: AppColors.lightOrange,
                text: "Medium ($mediumPriority)",
              ),
              _legendItem(
                color: AppColors.lightGreen,
                text: "Low ($lowPriority)",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem({required Color color, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
