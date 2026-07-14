import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class AlertServices {
  AlertServices._();

  static final AlertServices instance = AlertServices._();

  bool _isInitialized = false;
  bool _isLocalNotificationInitialized = false;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize(BuildContext context) async {
    if (_isInitialized) return;
    _isInitialized = true;
    tz.initializeTimeZones();
    final currentTimezone = await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation(currentTimezone.identifier));

    await setUpFlutterNotifications();
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> setUpFlutterNotifications() async {
    if (_isLocalNotificationInitialized) return;

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
    );

    _isLocalNotificationInitialized = true;
    return;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String description,
  }) async {
    await _localNotificationsPlugin.show(
      id: id,
      title: title,
      body: description,

      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduleDateTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    final currentDateTime = tz.TZDateTime.now(tz.local);
    if (!scheduleDateTime.isAfter(currentDateTime)) {
      scheduleDateTime = tz.TZDateTime.now(
        tz.local,
      ).add(const Duration(minutes: 1));
    }
    // final androidPlugin = _localNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //       AndroidFlutterLocalNotificationsPlugin
    //     >();
    // print(await androidPlugin?.canScheduleExactNotifications());
    // final scheduleDateTime = tz.TZDateTime.now(
    //   tz.local,
    // ).add(const Duration(minutes: 1));
    // print("Now: ${tz.TZDateTime.now(tz.local)}");
    // print("Scheduled: $scheduleDateTime");
    await _localNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body.toUpperCase(),
      scheduledDate: scheduleDateTime,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),

      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: null,
    );

    // final List<PendingNotificationRequest> pendingNotificationRequests =
    //     await _localNotificationsPlugin.pendingNotificationRequests();

    // print(pendingNotificationRequests.length);
  }

  Future<void> unscheduleNotification({required int sno}) async {
    await _localNotificationsPlugin.cancel(id: sno);
  }
}
