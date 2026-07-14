import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/constants/theme/app_colors.dart';
import 'package:task_manager/core/alert_services.dart';
import 'package:task_manager/core/db_helper.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/features/home/data/task_model.dart';

class CalendarViewScreen extends StatefulWidget {
  const CalendarViewScreen({super.key});

  @override
  State<CalendarViewScreen> createState() => _CalendarViewScreenState();
}

class _CalendarViewScreenState extends State<CalendarViewScreen> {
  List<DateTime> _dates = [DateTime.now()];
  final dbRef = DbHelper.instance;
  List<TaskModel> tasks = [];

  Map<int, Color> pickColor = {
    // "Low": AppColors.lightGreen,
    // "Medium": AppColors.lightOrange,
    // "High": AppColors.lightRed,
    0: AppColors.lightOrange,
    1: AppColors.lightGreen,
  };

  String displayDate({required DateTime datetime}) {
    final selectedDate = datetime.toString().split(" ")[0];
    if (selectedDate == DateTime.now().toString().split(" ")[0]) {
      return "Today";
    } else {
      return selectedDate;
    }
  }

  String mapDate({required String date}) {
    if (date == (DateTime.now().toString().split(" ")[0])) {
      return "Today";
    } else {
      return date;
    }
  }

  Future<void> fetchTasksByDate({required String date}) async {
    final result = await dbRef.fetchTasksByDate(date: date);
    setState(() {
      tasks = result;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTasksByDate(date: _dates[0].toString().split(" ")[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: Column(
        crossAxisAlignment: .start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  SizedBox(height: 16),

                  CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      dayTextStyle: TextStyle(
                        fontSize: 16,
                        color: AppColors.white,
                      ),
                      monthTextStyle: TextStyle(
                        fontSize: 16,
                        color: AppColors.white,
                      ),
                      yearTextStyle: TextStyle(
                        fontSize: 16,
                        color: AppColors.white,
                      ),
                      weekdayLabelTextStyle: TextStyle(
                        fontSize: 16,
                        color: AppColors.lightGreen,
                        fontWeight: FontWeight.w500,
                      ),
                      controlsTextStyle: TextStyle(
                        fontSize: 16,
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      selectedDayTextStyle: TextStyle(
                        fontSize: 16,
                        color: AppColors.white,
                      ),
                      selectedDayHighlightColor: AppColors.violetBlue,
                      disableVibration: true,
                      lastMonthIcon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.white,
                        size: 16,
                      ),
                      nextMonthIcon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.white,
                        size: 16,
                      ),
                    ),
                    value: _dates,
                    onValueChanged: (dates) {
                      setState(() {
                        _dates = dates;
                        fetchTasksByDate(
                          date: _dates[0].toString().split(" ")[0],
                        );
                      });
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          "${displayDate(datetime: _dates[0])} •",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 12),
                        tasks.isEmpty
                            ? Text(
                                "No Tasks Created",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.violet,
                                ),
                              )
                            : ListView.builder(
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
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: GestureDetector(
                                            onTap: () async {
                                              await dbRef.markTaskComplete(
                                                sno: task.sno,
                                              );
                                              await fetchTasksByDate(
                                                date: _dates[0]
                                                    .toString()
                                                    .split(" ")[0],
                                              );
                                              await AlertServices.instance
                                                  .unscheduleNotification(
                                                    sno: task.sno,
                                                  );
                                            },
                                            child: task.status == 0
                                                ? Icon(
                                                    Icons.circle_outlined,
                                                    size: 20,
                                                  )
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
                                                  color: AppColors.white,
                                                ),
                                              ),
                                              if (task.desc != null &&
                                                  task.desc!.isNotEmpty)
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 8,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                      border: Border.all(
                                                        width: 1,
                                                        color: AppColors
                                                            .violetBlue,
                                                      ),
                                                      color:
                                                          AppColors.cardBgColor,
                                                    ),
                                                    child: Text(
                                                      task.category,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 16),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 8,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                      border: Border.all(
                                                        width: 1,
                                                        color:
                                                            pickColor[task
                                                                .status]!,
                                                      ),
                                                      color:
                                                          pickColor[task
                                                                  .status]!
                                                              .withAlpha(40),
                                                    ),
                                                    child: Text(
                                                      "• ${task.priority}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            pickColor[task
                                                                .status]!,
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
                                                    "${mapDate(date: task.date)} • ${stringToTimeOfDay(task.startTime).format(context)} - ${stringToTimeOfDay(task.endTime).format(context)}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700,
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

                                                await fetchTasksByDate(
                                                  date: _dates[0]
                                                      .toString()
                                                      .split(" ")[0],
                                                );
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
                                                await dbRef.deleteTask(
                                                  sno: task.sno,
                                                );

                                                await fetchTasksByDate(
                                                  date: _dates[0]
                                                      .toString()
                                                      .split(" ")[0],
                                                );
                                                await AlertServices.instance
                                                    .unscheduleNotification(
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
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
