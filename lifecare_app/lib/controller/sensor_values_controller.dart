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

  void updateSensorValues({required double value}) {
    if (sensorsValues.length >= 40) sensorsValues.removeAt(0);

    sensorsValues.add(
      SensorsValueModel(
        heartBeat: value,
        temperature: value,
        dateTime: DateTime.now(),
      ),
    );
  }
}
