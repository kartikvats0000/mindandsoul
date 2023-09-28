import 'dart:math';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;

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
      BuildContext context) async {
    var androidInitializationsSettings =
        const AndroidInitializationSettings('codex_logo');


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
        initLocalNotification(context);
        showNotification(message);
      } else {
        initLocalNotification(context);
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notifications',
      importance: Importance.max,
      enableVibration: true,
      showBadge: true,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('noti'),
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/codex_logo',
      ongoing: true,
      ticker: 'ticker',
      enableVibration: true,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('noti'),
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
      sound: const RawResourceAndroidNotificationSound('noti'),
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
