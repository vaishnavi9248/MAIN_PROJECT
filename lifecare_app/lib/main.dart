import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lifecare/bloc/reminder/reminder_hydrated_cubit.dart';
import 'package:lifecare/const/preference_key.dart';
import 'package:lifecare/data/services/notification_service.dart';
import 'package:lifecare/data/services/shared_pref.dart';
import 'package:lifecare/firebase_options.dart';
import 'package:lifecare/ui/home/home_screen.dart';
import 'package:lifecare/ui/login/login_screen.dart';
import 'package:lifecare/util/custom_print.dart';
import 'package:path_provider/path_provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  customDebugPrint("_firebaseMessagingBackgroundHandler ${message.toMap()}");

  //notificationGlobalService.notificationShow(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getTemporaryDirectory());

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await globalNotificationService.init();

  bool isLoggedIn = await SharedPref().getBool(key: PreferenceKey.isLoggedIn);

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.isLoggedIn,
  });

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (repoContext) => ReminderHydratedCubit()),
      ],
      child: GetMaterialApp(
        title: 'LifeCare',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          //useMaterial3: true,
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: isLoggedIn ? HomeScreen() : LoginScreen(),
      ),
    );
  }
}
