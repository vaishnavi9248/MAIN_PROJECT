import 'package:get/get.dart';
import 'package:lifecare/data/models/sensor_values_model.dart';

class SensorValuesController extends GetxController {
  RxList<SensorsValueModel> sensorsValues = <SensorsValueModel>[
    SensorsValueModel(
      dateTime: DateTime.now(),
      heartBeat: 60,
      temperature: 97,
    )
  ].obs;

  void updateSensorValues({
    required double heartBeat,
    required double temperature,
  }) {
    if (sensorsValues.length >= 40) sensorsValues.removeAt(0);

    if (heartBeat == 0.0 && sensorsValues.isNotEmpty) {
      heartBeat = sensorsValues.last.heartBeat;
    }

    if (temperature == 0.0 && sensorsValues.isNotEmpty) {
      temperature = sensorsValues.last.temperature;
    }

    sensorsValues.add(
      SensorsValueModel(
        heartBeat: heartBeat,
        temperature: temperature,
        dateTime: DateTime.now(),
      ),
    );
  }
}
