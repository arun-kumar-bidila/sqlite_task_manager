import 'package:flutter/material.dart';
import 'package:task_manager/constants/theme/app_colors.dart';
import 'package:task_manager/core/alert_services.dart';
import 'package:task_manager/core/app_validators.dart';
import 'package:task_manager/core/db_helper.dart';
import 'package:task_manager/core/task_params.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/features/common/common_text_field.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedPriority = "Medium";
  String _selectedCategory = "💼 Work";
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  final List<String> categories = [
    "💼 Work",
    "🏠 Personal",
    "📚 Study",
    "🛒 Shopping",
    "❤️ Health",
    "💪 Gym",
    "✈️ Travel",
  ];

  final dbRef = DbHelper.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 16,
              crossAxisAlignment: .start,
              children: [
                Center(
                  child: Text(
                    "New Task",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
                CommonTextField(
                  hint: "Title",
                  controller: _titleController,
                  maxLines: 1,
                  validator: fieldValidator,
                ),
                CommonTextField(
                  hint: "Description(optional)...",
                  controller: _descController,
                  maxLines: 3,
                ),
                Text(
                  "PRIORITY",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey,
                  ),
                ),
                Row(
                  spacing: 12,
                  children: [
                    _priorityButton(
                      label: "Low",
                      labelColor: AppColors.lightGreen,
                      bgColor: AppColors.darkGreen,
                    ),
                    _priorityButton(
                      label: "Medium",
                      labelColor: AppColors.lightOrange,
                      bgColor: Color(0xFF292017),
                    ),
                    _priorityButton(
                      label: "High",
                      labelColor: AppColors.lightRed,
                      bgColor: AppColors.darkRed,
                    ),
                  ],
                ),
                Text(
                  "CATEGORY",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey,
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedCategory == categories[index];
                      return GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            _selectedCategory = categories[index];
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
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
                                fontSize: 16,
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

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        spacing: 12,
                        children: [
                          Text(
                            "START TIME",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();

                              final TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: startTime ?? TimeOfDay.now(),
                              );

                              setState(() {
                                startTime = time;
                              });
                            },

                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.grey,
                                ),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  Text(
                                    (startTime?.format(context) ?? "00 : 00")
                                        .toString(),

                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  Icon(
                                    Icons.timer_outlined,
                                    size: 20,
                                    color: AppColors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        spacing: 12,
                        children: [
                          Text(
                            "END TIME",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              final TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: endTime ?? TimeOfDay.now(),
                              );
                              setState(() {
                                endTime = time;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.grey,
                                ),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  Text(
                                    (endTime?.format(context) ?? "00 : 00")
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  Icon(
                                    Icons.timer_outlined,
                                    size: 20,
                                    color: AppColors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Text(
                  "NOTES",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey,
                  ),
                ),
                CommonTextField(
                  hint: "Add Notes(optional)...",
                  controller: _notesController,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FocusScope.of(context).unfocus();
          if ((_formKey.currentState?.validate() ?? false) &&
              _selectedPriority.isNotEmpty &&
              _selectedCategory.isNotEmpty &&
              startTime != null &&
              endTime != null) {
            if (endTime!.isAfter(startTime!)) {
              final DateTime now = DateTime.now();

              int id = await dbRef.addTask(
                params: TaskParams(
                  title: _titleController.text.trim(),
                  desc: _descController.text.trim(),
                  priority: _selectedPriority,
                  category: _selectedCategory,
                  notes: _notesController.text.trim(),
                  status: 0,
                  pin: 0,
                  startTime: time24(startTime!),
                  endTime: time24(endTime!),
                  date: now.toString().split(' ')[0],
                ),
              );
              if ((id > 0) && context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Task Created")));
                await AlertServices.instance.scheduleNotification(
                  id: id,
                  title: "Task Reminder",
                  body:
                      "${_titleController.text.trim()} • ${startTime!.format(context)} - ${endTime!.format(context)}",
                  hour: startTime!.hour,
                  minute: startTime!.minute,
                );
              }
              setState(() {
                _notesController.clear();
                _titleController.clear();
                _descController.clear();
                startTime = null;
                endTime = null;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("End Time Should Be Greater Than Start Time"),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Enter Required Fields")));
          }
        },
        backgroundColor: AppColors.violetBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(100),
        ),
        child: Icon(Icons.done, size: 30, color: AppColors.white),
      ),
    );
  }

  Widget _priorityButton({
    required String label,
    required Color labelColor,
    required Color bgColor,
  }) {
    final bool isSelected = _selectedPriority == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            _selectedPriority = label;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              width: 1,
              color: isSelected ? labelColor.withAlpha(87) : AppColors.grey,
            ),
            color: isSelected ? bgColor : Color(0xFF161823),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isSelected ? labelColor : AppColors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
