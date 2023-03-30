import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';

class SensorValuesController extends GetxController {
  RxList<double> heartBeatList = <double>[60].obs;
  RxList<double> temperatureList = <double>[36.1].obs;

  Random randomGenerator = Random();

  @override
  void onInit() {
    generateCountList();
    updateHeartBeat();
    updateTemperature();
    super.onInit();
  }

  void generateCountList() {
    // heartBeatList.value = List.generate(
    //     10, (_) => 60 + randomGenerator.nextDouble() * (100 - 60));
    //
    // temperatureList.value = List.generate(
    //     10,
    //     (_) => double.parse(
    //         (36.1 + randomGenerator.nextDouble() * (37.2 - 36.1))
    //             .toStringAsFixed(2)));
  }

  void updateHeartBeat() {
    Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      Random random = Random();
      double newHeart = double.parse(
          (60 + random.nextDouble() * (100 - 60)).toStringAsFixed(2));
      if (heartBeatList.length > 40) heartBeatList.removeAt(0);
      heartBeatList.add(newHeart);
    });
  }

  void updateTemperature() {
    Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      Random random = Random();
      double newTempe = double.parse(
          (36.1 + random.nextDouble() * (37.2 - 36.1)).toStringAsFixed(2));
      if (temperatureList.length > 40) temperatureList.removeAt(0);
      temperatureList.add(newTempe);
    });
  }
}
