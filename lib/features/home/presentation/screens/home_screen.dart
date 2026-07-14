import 'package:flutter/material.dart';
import 'package:task_manager/constants/theme/app_colors.dart';
import 'package:task_manager/core/alert_services.dart';
import 'package:task_manager/core/db_helper.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/features/home/data/task_model.dart';
import 'package:task_manager/features/home/presentation/widgets/task_summary.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int todayTasks = 0;
  int pendingTasks = 0;
  int completedTasks = 0;
  int overdueTasks = 0;
  final dbRef = DbHelper.instance;
  List<TaskModel> tasks = [];
  List<TaskModel> pinnedTasks = [];

  Map<int, Color> pickColor = {
    0: AppColors.lightOrange,
    1: AppColors.lightGreen,
  };

  @override
  void initState() {
    super.initState();
    fetchHomeScreenDate();
  }

  Future<void> fetchHomeScreenDate() async {
    final fetchAllTasksResult = await dbRef.fetchAllTasks();
    final fetchPinnedTasksResult = await dbRef.fetchPinnedTasks();
    todayTasks = await dbRef.fetchTodayTasks();
    pendingTasks = await dbRef.fetchTodayPendingTasks();
    completedTasks = await dbRef.fetchTodayCompletedTasks();
    overdueTasks = await dbRef.fetchOverDueTasks();
    setState(() {
      tasks = fetchAllTasksResult;
      pinnedTasks = fetchPinnedTasksResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
        child: Column(
          spacing: 16,
          crossAxisAlignment: .start,
          children: [
            Text(
              "Wednesday, July 1",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.grey,
              ),
            ),

            Text(
              "Welcome 👋",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 16,
                  crossAxisAlignment: .start,
                  children: [
                    TaskSummary(
                      todayTasks: todayTasks,
                      completedTasks: completedTasks,
                      pendingTasks: pendingTasks,
                      overdueTasks: overdueTasks,
                    ),
                    if (pinnedTasks.isNotEmpty) ...[
                      SizedBox(height: 12),
                      Text(
                        "⭐ Pinned",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),

                      buildList(tasks: pinnedTasks),
                    ],

                    Text(
                      "Today",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    buildList(tasks: tasks),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildList({required List<TaskModel> tasks}) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.darkBlue,
            border: Border(
              left: BorderSide(color: pickColor[task.status]!, width: 2),
            ),
          ),
          child: Row(
            crossAxisAlignment: .start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: GestureDetector(
                  onTap: () async {
                    await dbRef.markTaskComplete(sno: task.sno);
                    await fetchHomeScreenDate();
                    await AlertServices.instance.unscheduleNotification(
                      sno: task.sno,
                    );
                  },
                  child: task.status == 0
                      ? Icon(Icons.circle_outlined, size: 20)
                      : Icon(
                          Icons.done_all,
                          size: 20,
                          color: AppColors.lightGreen,
                        ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      task.title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: task.status == 1
                            ? AppColors.grey
                            : AppColors.white,
                        decoration: task.status == 1
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: AppColors.grey,
                      ),
                    ),
                    if (task.desc != null && task.desc!.isNotEmpty)
                      Text(
                        task.desc!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white,
                        ),
                      ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              width: 1,
                              color: AppColors.violetBlue,
                            ),
                            color: AppColors.cardBgColor,
                          ),
                          child: Text(
                            task.category,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              width: 1,
                              color: pickColor[task.status]!,
                            ),
                            color: pickColor[task.status]!.withAlpha(40),
                          ),
                          child: Text(
                            "• ${task.priority}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: pickColor[task.status]!,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: AppColors.violet,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Today • ${stringToTimeOfDay(task.startTime).format(context)} - ${stringToTimeOfDay(task.endTime).format(context)}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await dbRef.pinTask(
                        sno: task.sno,
                        pin: task.pin == 0 ? 1 : 0,
                      );

                      await fetchHomeScreenDate();
                    },
                    child: Icon(
                      task.pin == 0 ? Icons.star_border_outlined : Icons.star,
                      size: 25,
                      color: task.pin == 0
                          ? AppColors.grey
                          : AppColors.lightOrange,
                    ),
                  ),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      await dbRef.deleteTask(sno: task.sno);

                      await fetchHomeScreenDate();
                      await AlertServices.instance.unscheduleNotification(
                        sno: task.sno,
                      );
                    },
                    child: Icon(
                      Icons.delete_outline_rounded,
                      size: 25,
                      color: AppColors.lightRed,
                    ),
                  ),
                  SizedBox(height: 12),
                  Icon(
                    Icons.more_horiz_rounded,
                    size: 25,
                    color: AppColors.violet,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
