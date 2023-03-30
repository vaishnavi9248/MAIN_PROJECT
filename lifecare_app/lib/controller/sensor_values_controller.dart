import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:lifecare/data/models/sensor_values_model.dart';

class SensorValuesController extends GetxController {
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
    updateSensorValues();
    super.onInit();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }

    super.dispose();
  }

  void updateSensorValues() {
    Random random = Random();
    Timer.periodic(const Duration(milliseconds: 2000), (currentTimer) {
      timer = currentTimer;
      double newTempe = double.parse(
          (97 + random.nextDouble() * (99 - 97)).toStringAsFixed(2));

      double newHeart = double.parse(
          (60 + random.nextDouble() * (100 - 60)).toStringAsFixed(2));

      if (sensorsValues.length >= 40) sensorsValues.removeAt(0);

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
