import 'dart:convert';

import 'package:lifecare/const/api_Keys.dart';
import 'package:lifecare/data/models/contacts_module.dart';
import 'package:lifecare/data/services/http_helper.dart';
import 'package:lifecare/util/custom_print.dart';

class ContactRepository {
  HttpHelper httpHelper = HttpHelper();

  Future<List<ContactsModule>> getContacts() async {
    try {
      var response = await httpHelper.get(Api.contact);

      if (response.runtimeType.toString() == "Response") {
        List<dynamic> data = jsonDecode(response.body)["data"];

        List<ContactsModule> list = [];

        for (var element in data) {
          list.add(ContactsModule.fromMap(element));
        }

        return list;
      }
    } catch (e) {
      customDebugPrint("getContacts error $e");
    }

    return [];
  }

  Future<ContactsModule> addContact({required dynamic body}) async {
    try {
      var response = await httpHelper.post(Api.contact, body);

      if (response.runtimeType.toString() == "Response") {
        return ContactsModule.fromMap(jsonDecode(response.body)["data"]);
      }
    } catch (e) {
      customDebugPrint("addContact error $e");
    }
    return ContactsModule.initial();
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
