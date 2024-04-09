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
      log(" this is the cancle action");

      LocalNotifications.showScheduleNotification(
          payload: "This is periodic data");
    } else {
      log(" this is the no action");
    }
  }

// initialize the local notifications
  static Future init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
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
    required String payload,
  }) async {
    tz.initializeTimeZones();

    // Get the current time in the Nepali time zone
    var nepalTimeZone = tz.getLocation('Asia/Kathmandu'); // Nepali time zone
    var nowInNepal = tz.TZDateTime.now(nepalTimeZone);

    int M1 = 5;
    int M2 = 20;
    int E1 = 30; // 4 PM
    int E2 = 40; // 6 PM
    int E3 = 50; // 7 PM
    int E4 = 60; // 8 PM

    // int M1 = calculateTimeRemaining(6);
    // int M2 = calculateTimeRemaining(7);
    // int E1 = calculateTimeRemaining(16); // 4 PM
    // int E2 = calculateTimeRemaining(18); // 6 PM
    // int E3 = calculateTimeRemaining(19); // 7 PM
    // int E4 = calculateTimeRemaining(20); // 8 PM

    Future<void> scheduleNotification({
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
            playSound: false,
            sound: RawResourceAndroidNotificationSound('notifications'),
            largeIcon: DrawableResourceAndroidBitmap('@mipmap/logo'),
            styleInformation: BigPictureStyleInformation(
              DrawableResourceAndroidBitmap(
                  '@mipmap/food'), // Replace '@mipmap/food' with your large image asset path
              contentTitle: "Hello student Hurry up!",
              summaryText:
                  "Place a order for your canteen meal ", // Updated notification message
              // Updated summary text
              htmlFormatContentTitle: true,
              htmlFormatSummaryText: true,
            ),
            actions: <AndroidNotificationAction>[
              AndroidNotificationAction(
                'yes_action', // ID of the action
                'Make a Order', // Label of the action
                titleColor: Colors.red,
                showsUserInterface: true,
              ),
              AndroidNotificationAction(
                'no_action', // ID of the action
                'Cancle', // Label of the action
                titleColor: Colors.red,
                allowGeneratedReplies: true,
                showsUserInterface: false,
              ),
            ],
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    }

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
            playSound: false,
            sound: RawResourceAndroidNotificationSound('notifications'),
            largeIcon: DrawableResourceAndroidBitmap('@mipmap/logo'),
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    }

//-------------morning 1 notification
    scheduleNotifications(
      notificationId: 1,
      title: "Thank you for placing your order!",
      body: "Your meal will be ready for pickup from the counter.",
      payload: payload,
      scheduledDateTime: nowInNepal.add(Duration(seconds: M1)),
    );

//-------------morning 2 notificaiton
    scheduleNotification(
      notificationId: 2, title: "Hello Student 2",
      body:
          "Don't forget to order your meal! Order before  hours to ensure you don't miss today's menu. Time is running out!", // Updated notification message
      payload: payload,
      scheduledDateTime: nowInNepal.add(Duration(hours: M2)),
    );

//-------------Evening  1 notificaiton
    scheduleNotification(
      notificationId: 3, title: "Hello Student 3",
      body:
          "Don't forget to order your meal! Order before  hours to ensure you don't miss today's menu. Time is running out!", // Updated notification message
      payload: payload,
      scheduledDateTime: nowInNepal.add(Duration(hours: E1)),
    );

//-------------Evening  2 notificaiton
    scheduleNotification(
      notificationId: 4, title: "Hello Student 4",
      body:
          "Don't forget to order your meal! Order before  hours to ensure you don't miss today's menu. Time is running out!", // Updated notification message
      payload: payload,
      scheduledDateTime: nowInNepal.add(Duration(hours: E2)),
    );

//-------------Evening  3 notificaiton
    scheduleNotification(
      notificationId: 5, title: "Hello Student 5",
      body:
          "Don't forget to order your meal! Order before  hours to ensure you don't miss today's menu. Time is running out!", // Updated notification message
      payload: payload,
      scheduledDateTime: nowInNepal.add(Duration(hours: E3)),
    );

//-------------Evening  4 notificaiton

    scheduleNotification(
      notificationId: 6, title: "Hello Student 6",
      body:
          "Don't forget to order your meal! Order before  hours to ensure you don't miss today's menu. Time is running out!", // Updated notification message
      payload: payload,
      scheduledDateTime: nowInNepal.add(Duration(hours: E4)),
    );
  }

  // close all the notifications available
  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
