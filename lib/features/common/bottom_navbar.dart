import 'package:flutter/material.dart';
import 'package:task_manager/constants/theme/app_colors.dart';
import 'package:task_manager/core/alert_services.dart';
import 'package:task_manager/features/add_task/presentation/screens/add_task_screen.dart';
import 'package:task_manager/features/calendar/presentation/screens/calendar_view_screen.dart';
import 'package:task_manager/features/home/presentation/screens/home_screen.dart';
import 'package:task_manager/features/stats/presentation/screens/stats_screen.dart';
import 'package:task_manager/features/tasks/presentation/screens/all_tasks_screen.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int selectedTab = 0;
  List<Widget> pages = [
    HomeScreen(),
    AllTasksScreen(),
    AddTaskScreen(),

    CalendarViewScreen(),
    StatsScreen(),
  ];
  final double iconSize = 30.0;
  final Color iconInactive = Colors.white;
  final Color iconActive = Color(0xFF7c86ff);
  // final Color iconActive = AppColors.violetBlue;

  @override
  void initState() {
    super.initState();
    AlertServices.instance.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.scaffoldBgColor,
        child: SafeArea(child: pages[selectedTab]),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16).copyWith(bottom: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          border: Border(
            top: BorderSide(width: 1, color: AppColors.navbarBorder),
          ),
          color: AppColors.darkBlue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavbarItem(icon: Icons.work_rounded, index: 0),
            _buildNavbarItem(icon: Icons.checklist_rounded, index: 1),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedTab = 2;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.violetBlue,
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: EdgeInsets.all(4),
                child: Icon(Icons.add, color: Colors.white, size: iconSize),
              ),
            ),
            _buildNavbarItem(icon: Icons.calendar_view_day, index: 3),
            _buildNavbarItem(icon: Icons.bar_chart_rounded, index: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavbarItem({required IconData icon, required int index}) {
    bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Icon(
        icon,
        size: iconSize,
        color: isSelected ? iconActive : iconInactive,
      ),
    );
  }
}
