import 'package:get/get.dart';
import 'package:lifecare/data/models/sensor_values_model.dart';
import 'package:lifecare/data/models/socket_sensors_model.dart';
import 'package:lifecare/data/repository/common_repository.dart';

class SensorValuesController extends GetxController {
  CommonRepository commonRepository = CommonRepository();

  RxList<SensorsValueModel> temperatureMinValues = <SensorsValueModel>[
    SensorsValueModel(value: 97, createdAt: DateTime.now()),
  ].obs;
  RxDouble temperatureAverage = 0.0.obs;
  RxDouble temperatureMin = 0.0.obs;
  RxDouble temperatureMax = 0.0.obs;

  RxList<SensorsValueModel> heartBeatMinValues = <SensorsValueModel>[
    SensorsValueModel(value: 60, createdAt: DateTime.now())
  ].obs;
  RxDouble heartBeatAverage = 0.0.obs;
  RxDouble heartBeatMin = 0.0.obs;
  RxDouble heartBeatMax = 0.0.obs;

  RxBool heartBeatLoading = true.obs;
  RxBool temperatureLoading = true.obs;

  RxList<SensorsValueModel> heartBeatHistory = <SensorsValueModel>[].obs;
  RxList<SensorsValueModel> temperatureHistory = <SensorsValueModel>[].obs;

  void updateTemperatureValues({required SocketSensorsModel data}) {
    if (temperatureMinValues.length >= 40) temperatureMinValues.removeAt(0);

    temperatureMinValues.add(data.data);
    temperatureAverage.value = data.averageValue;

    List<SensorsValueModel> temp = [...temperatureMinValues];
    temp.sort((a, b) => a.value.compareTo(b.value));

    temperatureMin.value = temp.length > 2 ? temp.first.value : 97.0;
    temperatureMax.value = temp.length > 2 ? temp.last.value : 99.0;
  }

  void updateHeartBeatValues({required SocketSensorsModel data}) {
    if (heartBeatMinValues.length >= 40) heartBeatMinValues.removeAt(0);

    heartBeatMinValues.add(data.data);
    heartBeatAverage.value = data.averageValue;

    List<SensorsValueModel> temp = [...heartBeatMinValues];
    temp.sort((a, b) => a.value.compareTo(b.value));
    heartBeatMin.value = temp.length > 2 ? temp.first.value : 60.0;
    heartBeatMax.value = temp.length > 2 ? temp.last.value : 100.0;
  }

  int heartBeatPageNo = 1;
  int temperaturePageNo = 1;

  Future<void> getHeartBeatHistory() async {
    heartBeatLoading.value = true;

    List<SensorsValueModel> history =
        await commonRepository.getHeartBeatHistory();

    heartBeatHistory.value = history;

    heartBeatLoading.value = false;
  }

  Future<void> getMoreHeartBeatHistory() async {
    heartBeatPageNo = heartBeatPageNo + 1;

    List<SensorsValueModel> history =
        await commonRepository.getHeartBeatHistory(page: heartBeatPageNo);

    for (var element in history) {
      heartBeatHistory.add(element);
    }
  }

  Future<void> getTemperatureHistory() async {
    temperatureLoading.value = true;

    List<SensorsValueModel> history =
        await commonRepository.getTemperatureHistory();

    temperatureHistory.value = history;

    temperatureLoading.value = false;
  }

  Future<void> getMoreTemperatureHistory() async {
    temperaturePageNo = temperaturePageNo + 1;

    List<SensorsValueModel> history =
        await commonRepository.getTemperatureHistory(page: temperaturePageNo);

    for (var element in history) {
      temperatureHistory.add(element);
    }
  }
}
