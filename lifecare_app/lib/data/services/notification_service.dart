import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lifecare/data/models/reminder_model.dart';
import 'package:lifecare/util/custom_print.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
    enableLights: true,
    enableVibration: true,
    // playSound: true,
    // sound: RawResourceAndroidNotificationSound("alarm"),
  );

  Future<void> init() async {
    await registerNotificationListeners();
    await initializeFlutterLocalNotificationsPlugin();
    await requestNotificationPermissions();

    firebaseOpenMessageListen();
    firebaseOnMessageListen();
  }

  Future<void> registerNotificationListeners() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> initializeFlutterLocalNotificationsPlugin() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    tz.initializeTimeZones();
  }

  Future<void> requestNotificationPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  void firebaseOpenMessageListen() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      customDebugPrint("onMessageOpenedApp ${message.toMap().toString()}");
    });
  }

  void firebaseOnMessageListen() {
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      customDebugPrint(
          "firebaseOnMessageListen ${message?.toMap().toString()}");
      notificationShow(message);
    });
  }

  void notificationShow(RemoteMessage? message) async {
    try {
      RemoteNotification? notification = message?.notification;

      int id = int.parse(
          message?.data["values"] ?? notification.hashCode.toString());

      await flutterLocalNotificationsPlugin.show(
        id,
        notification?.title,
        notification?.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'channelId1', 'high_importance_channel',
              importance: Importance.max,
              priority: Priority.high,
              enableLights: true,
              fullScreenIntent: true,
              enableVibration: true,
              audioAttributesUsage: AudioAttributesUsage.alarm,
              visibility: NotificationVisibility.public,
              // playSound: true,
              // sound: RawResourceAndroidNotificationSound("alarm"),
              color: Color.fromARGB(255, 255, 0, 0),
              ledColor: Color.fromARGB(255, 255, 0, 0),
              ledOnMs: 1000,
              ledOffMs: 500
              // additionalFlags: Int32List.fromList(<int>[4]),
              ),
        ),
      );
    } catch (e) {
      customDebugPrint("notificationShow error $e");
    }
  }

  Future<List<PendingNotificationRequest>> getScheduledNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  void showTimeNotification(ReminderModel reminderModel) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        reminderModel.id.hashCode,
        reminderModel.title,
        "reminderModel.message",
        tz.TZDateTime.from(reminderModel.dateTime, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            playSound: true,
            importance: Importance.high,
            priority: Priority.high,
            sound: const UriAndroidNotificationSound("alarm"),
            audioAttributesUsage: AudioAttributesUsage.alarm,
            enableVibration: true,
            //additionalFlags: Int32List.fromList(<int>[3]),
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      customDebugPrint("showTimeNotification error $e");
    }
  }
}
