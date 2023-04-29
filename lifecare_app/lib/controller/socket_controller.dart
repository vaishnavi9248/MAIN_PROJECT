import 'package:get/get.dart';
import 'package:lifecare/const/config_key.dart';
import 'package:lifecare/controller/sensor_values_controller.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketController extends GetxController {
  late Socket socket;

  final SensorValuesController sensorValueController =
      Get.put(SensorValuesController());

  @override
  void onInit() {
    connectToSocket();
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
      print("Connected to socket $data");
    });

    socket.onAny((event, data) {
      sensorValueController.updateSensorValues(
          value: double.parse(data["value"].toString()));
    });

    //receive new messages
    // socket.on("message", message);

    socket.onConnecting((data) => print("Connecting to socket $data"));

    socket.onError(_connectionError);
    socket.onConnectError(_connectionError);
    socket.onReconnectError(_connectionError);
  }

  void _connectionError(dynamic data) {
    print("socket connection error $data");
    //connectToSocket();
  }
}
