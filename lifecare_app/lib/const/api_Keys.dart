import 'package:lifecare/const/config_key.dart';

class Api {
  static const String addFCM = "${ConfigKey.serverKey}/fcm";
  static const String contact = "${ConfigKey.serverKey}/contact";
  static const String hospital = "${ConfigKey.serverKey}/hospital";
  static const String report = "${ConfigKey.serverKey}/notes";
  static const String doc = "${ConfigKey.serverKey}/doc";
  static const String heartbeat = "${ConfigKey.serverKey}/heartbeat";
  static const String temperature = "${ConfigKey.serverKey}/temperature";
}
