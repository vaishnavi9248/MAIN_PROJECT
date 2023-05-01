import 'dart:convert';

import 'package:lifecare/const/api_Keys.dart';
import 'package:lifecare/data/models/hospital_model.dart';
import 'package:lifecare/data/services/http_helper.dart';
import 'package:lifecare/util/custom_print.dart';

class HospitalRepository {
  HttpHelper httpHelper = HttpHelper();

  Future<List<HospitalModel>> getHospitals() async {
    try {
      var response = await httpHelper.get(Api.hospital);

      if (response.runtimeType.toString() == "Response") {
        List<dynamic> data = jsonDecode(response.body)["data"];

        List<HospitalModel> list = [];

        for (var element in data) {
          list.add(HospitalModel.fromMap(element));
        }

        return list;
      }
    } catch (e) {
      customDebugPrint("getHospitals error $e");
    }

    return [];
  }
}
