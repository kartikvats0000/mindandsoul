/*
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationServices{
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();




  initializeNotification()async{
     AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings('logo');

    var iosInitializationSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload)async{}
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings
    );
    
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse)async{
      }
    );




  }
  NotificationDetails notificationDetails =  const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName',importance: Importance.max,priority: Priority.high,playSound: true, ),
      iOS: DarwinNotificationDetails()
  );

  sendNotification({int id = 0,required String title, required String body, String? payload}){
    return flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }

  scheduleNotification({int id = 0,required DateTime time,required String title, required String body, String? payload}){
    return flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(time, tz.local),
        notificationDetails,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }
}*/

/*import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/app_icon', // Replace with your app's icon resource
      [
        NotificationChannel(
          channelKey: 'your_channel_key', // Replace with your channel key
          channelName: 'Your App Channel',
          channelDescription: 'Your App Channel Description',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.green,
          enableVibration: true,
          playSound: true,

        ),
      ],
    );
  }

  Future<void> show({
    required int id,
    required String channelKey,
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channelKey,
        title: title,
        body: body,
        notificationLayout: NotificationLayout.BigText,
      ),
    );
  }

  Future<void> scheduleDailyZonedNotification({
    required int id,
    required String channelKey,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channelKey,
        title: title,
        body: body,
        notificationLayout: NotificationLayout.BigText,
      ),
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        second: 0,
        repeats: true,
      ),
    );
  }

  Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }
}*/


/*
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'dart:io' show Platform;
import 'package:rxdart/subjects.dart';
import 'services.dart';
import '../main.dart';

class LocalNotifyManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  var initSetting;

  BehaviorSubject<ReceiveNotification> get didReceiveLocalNotificationSubject =>
      BehaviorSubject<ReceiveNotification>();

  LocalNotifyManager.init() {
    if (Platform.isIOS) {
      requestIOSPermission();
    }
    initializePlatform();
  }

  requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()!
        .requestPermissions(alert: true, badge: true, sound: true);
  }

  initializePlatform() {
    var initSettingAndroid = const AndroidInitializationSettings('codex_logo');
    */
/*var initSettingIOS = IOSInitializationSettings();*//*

    initSetting = InitializationSettings(
        android: initSettingAndroid);
    flutterLocalNotificationsPlugin.initialize(initSetting,);
  }

  setOnNotificationReceive(Function onNotificationReceive) {
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }

  Future<void> scheduleNotification(int notificationId, String title,
      String body, Time notificationTime) async {
    var androidPlatformChannelSpecifics =
    const AndroidNotificationDetails('your_channel_id', 'your_channel_name',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        //sound: RawResourceAndroidNotificationSound("noti"),
        icon: 'codex_logo');
 */
/*   var iOSPlatformChannelSpecifics = const IOSNotificationDetails();*//*

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        );

    await flutterLocalNotificationsPlugin.showDailyAtTime(
      notificationId,
      title,
      body,
      notificationTime,
      platformChannelSpecifics,
      payload: 'notification$notificationId',
    );
  }
}

LocalNotifyManager localNotifyManager = LocalNotifyManager.init();

class ReceiveNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceiveNotification(
      {required this.id,
        required this.title,
        required this.body,
        required this.payload});
}
*/



