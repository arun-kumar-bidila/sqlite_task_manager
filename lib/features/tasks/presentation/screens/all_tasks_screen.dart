import 'package:flutter/material.dart';
import 'package:task_manager/constants/theme/app_colors.dart';
import 'package:task_manager/core/alert_services.dart';
import 'package:task_manager/core/db_helper.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/features/common/common_text_field.dart';
import 'package:task_manager/features/home/data/task_model.dart';

class AllTasksScreen extends StatefulWidget {
  const AllTasksScreen({super.key});

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = "All";
  final List<String> categories = [
    "All",
    "💼 Work",
    "🏠 Personal",
    "📚 Study",
    "🛒 Shopping",
    "❤️ Health",
    "💪 Gym",
    "✈️ Travel",
  ];
  Map<int, Color> pickColor = {
    // "Low": AppColors.lightGreen,
    // "Medium": AppColors.lightOrange,
    // "High": AppColors.lightRed,
    0: AppColors.lightOrange,
    1: AppColors.lightGreen,
  };

  final dbRef = DbHelper.instance;
  List<TaskModel> tasks = [];
  @override
  void initState() {
    super.initState();
    fetchAllTasks();
  }

  Future<void> fetchAllTasks() async {
    final result = await dbRef.fetchAllTasks();

    setState(() {
      tasks = result;
    });
  }

  void fetchCategoryBasedTasks({required String category}) async {
    final result = await dbRef.fetchCategoryBasedTasks(category: category);
    setState(() {
      tasks = result;
    });
  }

  Future<void> filterTasks({required String query}) async {
    if (query == "") {
      return fetchAllTasks();
    }
    tasks = tasks.where((task) {
      return task.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            CommonTextField(
              hint: "Search Tasks...",
              controller: _searchController,
              maxLines: 1,
              onValueChanged: (value) {
                filterTasks(query: value);
              },
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedCategory == categories[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = categories[index];
                        if (_selectedCategory == "All") {
                          fetchAllTasks();
                        } else {
                          fetchCategoryBasedTasks(category: _selectedCategory);
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      margin: EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          width: 1,
                          color: isSelected
                              ? AppColors.violetBlue
                              : AppColors.grey,
                        ),
                        color: isSelected
                            ? AppColors.cardBgColor
                            : Color(0xFF161823),
                      ),
                      child: Center(
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? AppColors.violetBlue
                                : AppColors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),

            Text(
              "Manage Tasks •",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
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
                        left: BorderSide(
                          color: pickColor[task.status]!,
                          width: 2,
                        ),
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
                              await fetchAllTasks();
                              await AlertServices.instance
                                  .unscheduleNotification(sno: task.sno);
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
                                      color: pickColor[task.status]!.withAlpha(
                                        40,
                                      ),
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

                                await fetchAllTasks();
                              },
                              child: Icon(
                                task.pin == 0
                                    ? Icons.star_border_outlined
                                    : Icons.star,
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

                                await fetchAllTasks();
                                await AlertServices.instance
                                    .unscheduleNotification(sno: task.sno);
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
