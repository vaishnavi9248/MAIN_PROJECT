import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:lifecare/util/custom_print.dart';

class HttpHelper {
  Future<dynamic> get(String url, {bool auth = true}) async {
    Map<String, String> header = await _httpHeader(auth);

    try {
      var response = await http.get(Uri.parse(url), headers: header);

      return _returnResponse(response);
    } catch (e) {
      customDebugPrint("http catch get $e");
    }

    return null;
  }

  Future<dynamic> post(String url, dynamic body, {bool auth = true}) async {
    Map<String, String>? header = await _httpHeader(auth);

    try {
      var response =
          await http.post(Uri.parse(url), body: body, headers: header);

      return _returnResponse(response);
    } catch (e) {
      customDebugPrint("http catch post $e");
    }
    return null;
  }

  Future<dynamic> put(String url, dynamic body, {bool auth = true}) async {
    Map<String, String>? header = await _httpHeader(auth);

    try {
      var response =
          await http.put(Uri.parse(url), body: body, headers: header);

      return _returnResponse(response);
    } catch (e) {
      customDebugPrint("http catch put $e");
    }

    return null;
  }

  Future<dynamic> delete(String url, {bool auth = true}) async {
    Map<String, String>? header = await _httpHeader(auth);

    try {
      var response = await http.delete(Uri.parse(url), headers: header);

      return _returnResponse(response);
    } catch (e) {
      customDebugPrint("http catch delete $e");
    }

    return null;
  }

  Future<dynamic> multipart(
      {required String url,
      required String path,
      required String fieldName,
      bool auth = true}) async {
    Map<String, String>? hd = await _httpHeader(auth);

    late dynamic responseJson;
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(hd);
      request.files.add(http.MultipartFile.fromBytes(
        fieldName,
        File(path).readAsBytesSync(),
        filename: path.split("/").last,
      ));
      var res = await request.send();
      var response = await http.Response.fromStream(res);

      responseJson = _returnResponse(response);
    } catch (e) {
      customDebugPrint("multipart error $e");
    }

    return responseJson;
  }

  Future<Map<String, String>> _httpHeader(bool auth) async {
    Map<String, String> headers = {
      HttpHeaders.acceptHeader: "application/json"
    };

    return headers;
  }

  dynamic _returnResponse(http.Response response) async {
    try {
      switch (response.statusCode) {
        case 200:
          return response;

        case 404:
          return null;
      }
    } catch (e) {
      customDebugPrint("Server Error");
    }
  }
}
