import 'dart:convert';

import 'package:lifecare/const/api_Keys.dart';
import 'package:lifecare/data/models/sensor_values_model.dart';
import 'package:lifecare/data/services/http_helper.dart';
import 'package:lifecare/util/custom_print.dart';

class CommonRepository {
  final HttpHelper _httpHelper = HttpHelper();

  Future<List<SensorsValueModel>> getHeartBeatHistory({
    int limit = 30,
    int page = 1,
  }) async {
    try {
      var response =
          await _httpHelper.get("${Api.heartbeat}?limit=$limit&page=$page");

      if (response.runtimeType.toString() == "Response") {
        List<dynamic> data = jsonDecode(response.body)["data"];

        List<SensorsValueModel> list = [];

        for (var element in data) {
          list.add(SensorsValueModel.fromJson(element));
        }

        return list;
      }
    } catch (e) {
      customDebugPrint("getHeartBeatHistory error $e");
    }

    return [];
  }

  Future<List<SensorsValueModel>> getTemperatureHistory({
    int limit = 30,
    int page = 1,
  }) async {
    try {
      var response =
          await _httpHelper.get("${Api.temperature}?limit=$limit&page=$page");

      if (response.runtimeType.toString() == "Response") {
        List<dynamic> data = jsonDecode(response.body)["data"];

        List<SensorsValueModel> list = [];

        for (var element in data) {
          list.add(SensorsValueModel.fromJson(element));
        }

        return list;
      }
    } catch (e) {
      customDebugPrint("getTemperatureHistory error $e");
    }

    return [];
  }
}
