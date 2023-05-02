import 'dart:convert';

import 'package:lifecare/const/api_Keys.dart';
import 'package:lifecare/data/models/doc_model.dart';
import 'package:lifecare/data/models/report_model.dart';
import 'package:lifecare/data/services/http_helper.dart';
import 'package:lifecare/util/custom_print.dart';

class ReportRepository {
  HttpHelper httpHelper = HttpHelper();

  Future<List<ReportModel>> getReports() async {
    try {
      var response = await httpHelper.get(Api.report);

      if (response.runtimeType.toString() == "Response") {
        List<dynamic> data = jsonDecode(response.body)["data"];

        List<ReportModel> list = [];

        for (var element in data) {
          list.add(ReportModel.fromMap(element));
        }

        return list;
      }
    } catch (e) {
      customDebugPrint("getReports error $e");
    }

    return [];
  }

  Future<ReportModel> addReport({required dynamic body}) async {
    try {
      var response = await httpHelper.post(Api.report, body);

      if (response.runtimeType.toString() == "Response") {
        return ReportModel.fromMap(jsonDecode(response.body)["data"]);
      }
    } catch (e) {
      customDebugPrint("addReport error $e");
    }
    return ReportModel.initial();
  }

  Future<bool> updateReport({required dynamic body}) async {
    try {
      var response = await httpHelper.put(Api.report, body);

      if (response.runtimeType.toString() == "Response") {
        bool acknowledged = jsonDecode(response.body)["data"]["acknowledged"];

        customDebugPrint("acknowledged $acknowledged");

        return jsonDecode(response.body)["data"]["acknowledged"] ?? false;
      }
    } catch (e) {
      customDebugPrint("updateReport error $e");
    }
    return false;
  }

  Future<bool> deleteReport({required String id}) async {
    try {
      var response = await httpHelper.delete("${Api.report}/$id");

      if (response.runtimeType.toString() == "Response") {
        bool acknowledged = jsonDecode(response.body)["data"]["acknowledged"];

        customDebugPrint("acknowledged $acknowledged");

        return jsonDecode(response.body)["data"]["acknowledged"] ?? false;
      }
    } catch (e) {
      customDebugPrint("deleteReport error $e");
    }
    return false;
  }

  Future<List<DocModel>> getDocs({required String noteId}) async {
    try {
      var response = await httpHelper.get("${Api.doc}/$noteId");

      if (response.runtimeType.toString() == "Response") {
        List<dynamic> data = jsonDecode(response.body)["data"];

        List<DocModel> list = [];

        for (var element in data) {
          list.add(DocModel.fromMap(element));
        }

        return list;
      }
    } catch (e) {
      customDebugPrint("getDocs error $e");
    }

    return [];
  }

  Future<bool> deleteDoc({required String id}) async {
    try {
      var response = await httpHelper.delete("${Api.doc}/$id");

      if (response.runtimeType.toString() == "Response") {
        bool acknowledged = jsonDecode(response.body)["data"]["acknowledged"];

        customDebugPrint("acknowledged $acknowledged");

        return jsonDecode(response.body)["data"]["acknowledged"] ?? false;
      }
    } catch (e) {
      customDebugPrint("deleteDoc error $e");
    }
    return false;
  }

  Future<DocModel> addDoc({required dynamic body}) async {
    try {
      var response = await httpHelper.post(Api.doc, body);

      if (response.runtimeType.toString() == "Response") {
        return DocModel.fromMap(jsonDecode(response.body)["data"]);
      }
    } catch (e) {
      customDebugPrint("addReport error $e");
    }
    return DocModel.initial();
  }
}
