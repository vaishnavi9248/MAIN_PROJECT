import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:lifecare/const/config_key.dart';
import 'package:lifecare/controller/common_controller.dart';
import 'package:lifecare/controller/sensor_values_controller.dart';
import 'package:lifecare/data/models/socket_sensors_model.dart';
import 'package:lifecare/util/custom_print.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketController extends GetxController {
  late Socket socket;

  final SensorValuesController sensorValueController =
      Get.put(SensorValuesController());

  @override
  void onInit() {
    connectToSocket();
    addFcm();
    super.onInit();
  }

  Future<void> connectToSocket() async {
    socket = io(
        ConfigKey.serverKey,
        OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build());

    socket.onConnect((data) {
      customDebugPrint("Connected to socket $data");
    });

    socket.onAny((event, data) {
      if (event != "newHeartBeat" && event != "newTemperature") {
        customDebugPrint("event $event data $data");
      }
    });

    socket.on("newHeartBeat", (data) {
      sensorValueController.updateHeartBeatValues(
          data: SocketSensorsModel.fromJson(data));
    });

    socket.on("newTemperature", (data) {
      sensorValueController.updateTemperatureValues(
          data: SocketSensorsModel.fromJson(data));
    });

    //receive new messages
    // socket.on("message", message);

    socket
        .onConnecting((data) => customDebugPrint("Connecting to socket $data"));

    socket.onError(_connectionError);
    socket.onConnectError(_connectionError);
    socket.onReconnectError(_connectionError);
  }

  void _connectionError(dynamic data) {
    customDebugPrint("socket connection error $data");
    //connectToSocket();
  }

  Future<void> addFcm() async {
    final CommonController commonController = Get.put(CommonController());
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    String deviceId = androidInfo.id;
    String token = await messaging.getToken() ?? "";

    if (token.isNotEmpty && deviceId.isNotEmpty) {
      Map body = {
        "deviceId": deviceId,
        "token": token,
      };

      commonController.addFcm(body);
    }
  }
}
