import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:lifecare/data/models/sensor_values_model.dart';

class SensorValuesController extends GetxController {
  // RxList<double> heartBeatList = <double>[60].obs;
  // RxList<double> temperatureList = <double>[97].obs;
  // Timer? htTimer, tpTimer;

  Timer? timer;

  RxList<SensorsValueModel> sensorsValues = <SensorsValueModel>[
    SensorsValueModel(
      dateTime: DateTime.now(),
      heartBeat: 60,
      temperature: 97,
    )
  ].obs;

  @override
  void onInit() {
    // generateCountList();
    // updateHeartBeat();
    // updateTemperature();
    updateSensorValues();
    super.onInit();
  }

  @override
  void dispose() {
    // if (htTimer != null) {
    //   htTimer!.cancel();
    // }
    //
    // if (tpTimer != null) {
    //   tpTimer!.cancel();
    // }

    if (timer != null) {
      timer!.cancel();
    }

    super.dispose();
  }

  // void generateCountList() {
  //   heartBeatList.value = List.generate(
  //       10, (_) => 60 + randomGenerator.nextDouble() * (100 - 60));
  //
  //   temperatureList.value = List.generate(
  //       10,
  //       (_) => double.parse(
  //           (36.1 + randomGenerator.nextDouble() * (37.2 - 36.1))
  //               .toStringAsFixed(2)));
  // }

  // void updateHeartBeat() {
  //   Timer.periodic(const Duration(milliseconds: 1500), (timer) {
  //     htTimer = timer;
  //     Random random = Random();
  //     double newHeart = double.parse(
  //         (60 + random.nextDouble() * (100 - 60)).toStringAsFixed(2));
  //     if (heartBeatList.length > 40) heartBeatList.removeAt(0);
  //     heartBeatList.add(newHeart);
  //   });
  // }
  //
  // void updateTemperature() {
  //   Timer.periodic(const Duration(milliseconds: 2500), (timer) {
  //     tpTimer = timer;
  //     Random random = Random();
  //     double newTempe = double.parse(
  //         (97 + random.nextDouble() * (99 - 97)).toStringAsFixed(2));
  //     if (temperatureList.length > 40) temperatureList.removeAt(0);
  //     temperatureList.add(newTempe);
  //   });
  // }

  void updateSensorValues() {
    Random random = Random();
    Timer.periodic(const Duration(milliseconds: 2000), (currentTimer) {
      timer = currentTimer;
      double newTempe = double.parse(
          (97 + random.nextDouble() * (99 - 97)).toStringAsFixed(2));

      double newHeart = double.parse(
          (60 + random.nextDouble() * (100 - 60)).toStringAsFixed(2));

      if (sensorsValues.length > 40) sensorsValues.removeAt(0);

      sensorsValues.add(
        SensorsValueModel(
          heartBeat: newHeart,
          temperature: newTempe,
          dateTime: DateTime.now(),
        ),
      );
    });
  }
}
