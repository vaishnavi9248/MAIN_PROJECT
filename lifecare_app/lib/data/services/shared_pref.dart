import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<bool> getBool({required String key}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(key) ?? false;
  }

  Future<void> setBool({required String key, required bool value}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(key, value);
  }
}
