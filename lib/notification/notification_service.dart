import 'dart:math';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user granted provisional permission');
    } else {
      AppSettings.openAppSettings(type: AppSettingsType.notification);
      print('user denied permission');
    }
  }

  void initLocalNotification(
      ) async {
    var androidInitializationsSettings =
        const AndroidInitializationSettings('logo');


    var intializationSetting = InitializationSettings(
      android: androidInitializationsSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(intializationSetting);
  }

  firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message);
      }
      if (Platform.isAndroid) {
        initLocalNotification();
        showNotification(message);
      } else {
        initLocalNotification();
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: true,
    );
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notifications',
      importance: Importance.high,
      enableVibration: true,
      showBadge: true,
      playSound: true,
     // sound: const RawResourceAndroidNotificationSound('noti'),
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/logo',
      ongoing: false,
      ticker: 'ticker',
      enableVibration: true,
      playSound: true,
    //  sound: const RawResourceAndroidNotificationSound('noti'),
      // sound: UriAndroidNotificationSound("assets/noti.mpeg"),
      styleInformation: const BigTextStyleInformation(''),
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails);
    _flutterLocalNotificationsPlugin.show(
      1,
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      notificationDetails,
    );
  }

  Future<void> scheduleNotification() async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notifications',
      importance: Importance.high,
      enableVibration: true,
      showBadge: true,
      playSound: true,
     // sound: const RawResourceAndroidNotificationSound('noti'),
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/logo',
      ongoing: false,
      ticker: 'ticker',
      enableVibration: true,
      playSound: true,
      // sound: const RawResourceAndroidNotificationSound('not'),
      // sound: UriAndroidNotificationSound("assets/not.mpeg"),
      styleInformation: const BigTextStyleInformation(''),
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails
    );

    /*tz.TZDateTime nextInstanceOfTenAM() {
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate =
      now.add(const Duration(seconds: 5));
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(seconds: 10));
      }
      return scheduledDate;
    }*/


    //while(startTime.isBefore(other))
    final DateTime now = DateTime.now();
    final DateTime scheduledTime = now.add(const Duration(seconds: 5));

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      scheduledTime.toIso8601String(),
      'Daily Notification Body',
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      payload: scheduledTime.toString(),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.wallClockTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time
      //androidAllowWhileIdle: true, // You can attach custom data to the notification
    );


  }

  Future<void> every45Min() async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notifications',
      importance: Importance.high,
      enableVibration: true,
      showBadge: true,
      playSound: true,
     // sound: const RawResourceAndroidNotificationSound('noti'),
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/logo',
      ongoing: false,
      ticker: 'ticker',
      enableVibration: true,
      playSound: true,
      // sound: const RawResourceAndroidNotificationSound('not'),
      // sound: UriAndroidNotificationSound("assets/not.mpeg"),
      styleInformation: const BigTextStyleInformation(''),
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails
    );

    for (int i = 0; i < 15; i++) {
      final now = DateTime.now();
      final scheduledTime = DateTime(now.year, now.month, now.day, 10, 0)
          .add(Duration(minutes: 45 * i));
      if (scheduledTime.isBefore(now)) {
        continue; // Skip notifications in the past.
      }
      if (scheduledTime.isAfter(DateTime(now.year, now.month, now.day, 22, 0))) {
        break; // Don't schedule notifications after 10 PM.
      }

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        i, // Unique ID for each notification
        'Daily Reminder', // Notification title
        'This is your daily reminder message.', // Notification content
        tz.TZDateTime.from(scheduledTime, tz.local),
        notificationDetails,
        payload: tz.TZDateTime.from(scheduledTime, tz.local).toString(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

  }

  Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // Future<void> showNotificationLocal(int notificationId, String title,
  //     String body, Time notificationTime) async {
  //   await FirebaseMessaging.instance
  //       .setForegroundNotificationPresentationOptions(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );
  AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notifications',
      importance: Importance.max,
      enableVibration: true,
      showBadge: true,
      playSound: true,
      //sound: const RawResourceAndroidNotificationSound('noti'),
    );

    // AndroidNotificationDetails androidNotificationDetails =
    //     AndroidNotificationDetails(
    //   channel.id.toString(),
    //   channel.name.toString(),
    //   channelDescription: 'your channel description',
    //   importance: Importance.high,
    //   priority: Priority.high,
    //   icon: '@drawable/codex_logo',
    //   ongoing: true,
    //   ticker: 'ticker',
    //   enableVibration: true,
    //   playSound: true,
    //   sound: const RawResourceAndroidNotificationSound('noti'),
    //   // sound: UriAndroidNotificationSound("assets/noti.mpeg"),
    //   styleInformation: const BigTextStyleInformation(''),
    // );

   //  NotificationDetails notificationDetails = NotificationDetails(
   //      android: androidNotificationDetails, iOS: iOSPlatformChannelSpecifics);
   // _flutterLocalNotificationsPlugin.showDailyAtTime(
   //    notificationId,
   //    title,
   //    body,
   //    notificationTime,
   //    notificationDetails,
   //    payload: 'notification$notificationId',
   //  );
  //}



  Future<String?> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token;
  }

  Future<void> isTokenFresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  Future<void> setUpInteractMessage(BuildContext context,bool isLogged) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print('hello pn messafe-initial---$initialMessage');
    }
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('hello pn messafe----$event');
    });
  }

}
