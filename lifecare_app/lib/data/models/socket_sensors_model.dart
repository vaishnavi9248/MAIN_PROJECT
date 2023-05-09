import 'package:lifecare/data/models/sensor_values_model.dart';

class SocketSensorsModel {
  final SensorsValueModel data;
  final double averageValue;

  SocketSensorsModel({
    required this.data,
    required this.averageValue,
  });

  factory SocketSensorsModel.fromJson(Map<String, dynamic> json) {
    return SocketSensorsModel(
      data: SensorsValueModel.fromJson(json["data"]),
      averageValue: double.parse(json["averageValue"].toString()),
    );
  }

  factory SocketSensorsModel.initial() => SocketSensorsModel(
        data: SensorsValueModel.initial(),
        averageValue: 0,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> newJson = <String, dynamic>{};
    newJson['data'] = data.toJson();
    newJson['averageValue'] = averageValue;

    return newJson;
  }
}
