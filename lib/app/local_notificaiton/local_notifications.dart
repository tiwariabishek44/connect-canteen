import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  // on tap on any notification
  static void onNotificationTap(NotificationResponse notificationResponse) {
    if (notificationResponse.actionId == 'yes_action') {
      LocalNotifications.showScheduleNotification(
          payload: "This is periodic data");
      log(" this is the reply action");
    } else if (notificationResponse.actionId == 'no_action') {
      LocalNotifications.showScheduleNotification(
          payload: "This is periodic data");
    } else {
      log(" this is the no action");
    }
  }

  // initialize the local notifications
  static Future init() async {
    // initialise the plugin. app_icon needs to be added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  static int calculateTimeRemaining(int targetHour) {
    // Get the current time in the Nepali time zone
    var nepalTimeZone = tz.getLocation('Asia/Kathmandu'); // Nepali time zone
    var now = tz.TZDateTime.now(nepalTimeZone);

    // Define the target hour (22:00 or 10 PM)

    // Calculate the difference in hours between now and the target hour
    int hoursRemaining;
    if (now.hour < targetHour) {
      hoursRemaining = targetHour - now.hour;
    } else {
      hoursRemaining = (24 - now.hour) + targetHour;
    }

    return hoursRemaining;
  }

  static Future<void> showScheduleNotification({
    String? title,
    String? body,
    required String payload,
  }) async {
    tz.initializeTimeZones();

    // Get the current time in the Nepali time zone
    var nepalTimeZone = tz.getLocation('Asia/Kathmandu'); // Nepali time zone
    var nowInNepal = tz.TZDateTime.now(nepalTimeZone);

    Future<void> scheduleNotifications({
      required int notificationId,
      required String title,
      required String body,
      required String payload,
      required tz.TZDateTime scheduledDateTime,
    }) async {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledDateTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel 3',
            'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            playSound: true,
            largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          ),
          iOS: DarwinNotificationDetails(
            presentSound: false,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    }

    scheduleNotifications(
      notificationId: 1,
      title: title!,
      body: body!,
      payload: payload,
      scheduledDateTime: nowInNepal.add(const Duration(seconds: 1)),
    );
  }

  // close all the notifications available
  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
