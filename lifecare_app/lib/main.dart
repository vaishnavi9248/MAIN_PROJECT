import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifecare/const/preference_key.dart';
import 'package:lifecare/data/services/notification_service.dart';
import 'package:lifecare/data/services/shared_pref.dart';
import 'package:lifecare/ui/home/home_screen.dart';
import 'package:lifecare/ui/login/login_screen.dart';
import 'package:lifecare/util/custom_print.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  customDebugPrint("_firebaseMessagingBackgroundHandler ${message.toMap()}");
  //notificationGlobalService.notificationShow(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  NotificationService notificationGlobalService = NotificationService();

  notificationGlobalService.init();

  bool isLoggedIn = await SharedPref().getBool(key: PreferenceKey.isLoggedIn);

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    notificationGlobalService: notificationGlobalService,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.isLoggedIn,
    required this.notificationGlobalService,
  });

  final bool isLoggedIn;
  final NotificationService notificationGlobalService;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LifeCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: isLoggedIn
          ? HomeScreen(notificationService: notificationGlobalService)
          : LoginScreen(notificationService: notificationGlobalService),
    );
  }
}
