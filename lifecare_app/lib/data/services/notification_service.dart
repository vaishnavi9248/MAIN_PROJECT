import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lifecare/data/models/reminder_model.dart';
import 'package:lifecare/util/custom_print.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse? notificationResponse) {
  customDebugPrint(
      "onDidReceiveNotificationResponse ${notificationResponse?.payload}");
}

NotificationService globalNotificationService = NotificationService();

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
    showBadge: true,
    enableLights: true,
    enableVibration: true,
    playSound: true,
    sound: RawResourceAndroidNotificationSound("alarm"),
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

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    tz.initializeTimeZones();
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse? notificationResponse) {
    clickAction(notificationResponse);
  }

  void clickAction(NotificationResponse? notificationResponse) {
    customDebugPrint("clickAction");
  }

  Future<void> requestNotificationPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  void firebaseOpenMessageListen() {
    FirebaseMessaging.onMessageOpenedApp.listen(onData);
  }

  void onData(RemoteMessage? message) {
    customDebugPrint("onMessageOpenedApp ${message?.toMap().toString()}");
  }

  void firebaseOnMessageListen() {
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      customDebugPrint(
          "firebaseOnMessageListen ${message?.toMap().toString()}");
      notificationShow(message);
      //add audio manager
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
            'channelId1',
            'high_importance_channel',
            importance: Importance.max,
            priority: Priority.high,
            enableLights: true,
            fullScreenIntent: true,
            enableVibration: true,
            audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
            visibility: NotificationVisibility.public,
            playSound: true,
            sound: RawResourceAndroidNotificationSound("alarm"),
            color: Color.fromARGB(255, 255, 0, 0),
            ledColor: Color.fromARGB(255, 255, 0, 0),
            ledOnMs: 1000,
            ledOffMs: 500,
            styleInformation: DefaultStyleInformation(true, true),
            channelShowBadge: true,
            ongoing: true,
          ),
        ),
        payload: message?.data["type"] ?? "",
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
        "LifeCare Reminder",
        reminderModel.title,
        tz.TZDateTime.from(reminderModel.dateTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channelId1', 'high_importance_channel',
            importance: Importance.max,
            priority: Priority.high,
            enableLights: true,
            fullScreenIntent: true,
            audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
            visibility: NotificationVisibility.public,
            playSound: true,
            sound: RawResourceAndroidNotificationSound("alarm"),
            color: Color.fromARGB(255, 255, 0, 0),
            ledColor: Color.fromARGB(255, 255, 0, 0),
            ledOnMs: 1000,
            ledOffMs: 500,
            styleInformation: DefaultStyleInformation(true, true),
            channelShowBadge: true,
            ongoing: true,
            autoCancel: false,
            // additionalFlags: Int32List.fromList(<int>[4]),
          ),
        ),
        payload: "reminder",
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      customDebugPrint("showTimeNotification error $e");
    }
  }
}
