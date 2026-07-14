import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/constants/theme/app_theme.dart';
import 'package:task_manager/features/common/bottom_navbar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: AppTheme.appTheme,
      debugShowCheckedModeBanner: false,
      home: BottomNavbar(),
    );
  }
}
