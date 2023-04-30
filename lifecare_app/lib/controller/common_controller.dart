import 'package:get/get.dart';
import 'package:lifecare/const/api_Keys.dart';
import 'package:lifecare/data/services/http_helper.dart';

class CommonController extends GetxController {
  final HttpHelper _httpHelper = HttpHelper();

  void addFcm(dynamic body) async => await _httpHelper.post(Api.addFCM, body);
}
