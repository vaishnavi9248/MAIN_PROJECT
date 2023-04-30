import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifecare/const/preference_key.dart';
import 'package:lifecare/data/services/notification_service.dart';
import 'package:lifecare/data/services/shared_pref.dart';
import 'package:lifecare/ui/home/home_screen.dart';
import 'package:lifecare/ui/login/login_screen.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("_firebaseMessagingBackgroundHandler ${message.toMap()}");
  NotificationService().notificationShow(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  NotificationService().init();

  bool isLoggedIn = await SharedPref().getBool(key: PreferenceKey.isLoggedIn);

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLoggedIn});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LifeCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: isLoggedIn ? HomeScreen() : const LoginScreen(),
    );
  }
}
