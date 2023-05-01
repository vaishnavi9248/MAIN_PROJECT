import 'package:flutter/foundation.dart';

void customDebugPrint(dynamic message) {
  if (kDebugMode) debugPrint("\n${message.toString()}\n", wrapWidth: 1024);
}
