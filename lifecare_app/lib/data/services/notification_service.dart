import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  Future<void> init() async {
    await registerNotificationListeners();

    firebaseOpenMessageListen();
    firebaseOnMessageListen();
  }

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel channel;

  Future<void> registerNotificationListeners() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var androidSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initSettings = InitializationSettings(android: androidSettings);

    flutterLocalNotificationsPlugin.initialize(initSettings);

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  void firebaseOpenMessageListen() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp ${message.toMap().toString()}");
    });
  }

  //Foreground
  void firebaseOnMessageListen() {
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      print("firebaseOnMessageListen ${message?.toMap().toString()}");
      notificationShow(message);
    });
  }

  void notificationShow(RemoteMessage? message) async {
    try {
      RemoteNotification? notification = message?.notification;
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification?.title,
        notification?.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            playSound: true,
          ),
        ),
      );
    } catch (e) {
      print("notificationShow error $e");
    }
  }
}
