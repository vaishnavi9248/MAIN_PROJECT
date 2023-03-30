import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackBar({required String message}) =>
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text(message)));
