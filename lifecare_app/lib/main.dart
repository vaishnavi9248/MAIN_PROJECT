import 'package:flutter/material.dart';
import 'package:lifecare/const/preference_key.dart';
import 'package:lifecare/data/services/shared_pref.dart';
import 'package:lifecare/ui/login/home/home_screen.dart';
import 'package:lifecare/ui/login/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isLoggedIn = await SharedPref().getBool(key: PreferenceKey.isLoggedIn);

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLoggedIn});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
