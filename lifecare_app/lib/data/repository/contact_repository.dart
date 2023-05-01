import 'dart:convert';

import 'package:lifecare/const/api_Keys.dart';
import 'package:lifecare/data/models/contacts_model.dart';
import 'package:lifecare/data/services/http_helper.dart';
import 'package:lifecare/util/custom_print.dart';

class ContactRepository {
  HttpHelper httpHelper = HttpHelper();

  Future<List<ContactsModel>> getContacts() async {
    try {
      var response = await httpHelper.get(Api.contact);

      if (response.runtimeType.toString() == "Response") {
        List<dynamic> data = jsonDecode(response.body)["data"];

        List<ContactsModel> list = [];

        for (var element in data) {
          list.add(ContactsModel.fromMap(element));
        }

        return list;
      }
    } catch (e) {
      customDebugPrint("getContacts error $e");
    }

    return [];
  }

  Future<ContactsModel> addContact({required dynamic body}) async {
    try {
      var response = await httpHelper.post(Api.contact, body);

      if (response.runtimeType.toString() == "Response") {
        return ContactsModel.fromMap(jsonDecode(response.body)["data"]);
      }
    } catch (e) {
      customDebugPrint("addContact error $e");
    }
    return ContactsModel.initial();
  }

  Future<bool> updateContact({required dynamic body}) async {
    try {
      var response = await httpHelper.put(Api.contact, body);

      if (response.runtimeType.toString() == "Response") {
        bool acknowledged = jsonDecode(response.body)["data"]["acknowledged"];

        customDebugPrint("acknowledged $acknowledged");

        return jsonDecode(response.body)["data"]["acknowledged"] ?? false;
      }
    } catch (e) {
      customDebugPrint("updateContact error $e");
    }
    return false;
  }

  Future<bool> deleteContact({required String id}) async {
    try {
      var response = await httpHelper.delete("${Api.contact}/$id");

      if (response.runtimeType.toString() == "Response") {
        bool acknowledged = jsonDecode(response.body)["data"]["acknowledged"];

        customDebugPrint("acknowledged $acknowledged");

        return jsonDecode(response.body)["data"]["acknowledged"] ?? false;
      }
    } catch (e) {
      customDebugPrint("deleteContact error $e");
    }
    return false;
  }
}
