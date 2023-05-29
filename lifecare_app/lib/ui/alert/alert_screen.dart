import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lifecare/controller/sensor_values_controller.dart';
import 'package:lifecare/ui/contacts/contacts_screen.dart';
import 'package:lifecare/ui/history/heartbeat_history_screen.dart';
import 'package:lifecare/ui/history/temperature_history_screen.dart';
import 'package:lifecare/ui/hospitals/hospital_screen.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  final SensorValuesController sensorValueController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alert!!!..."),
        centerTitle: false,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (sensorValueController
                        .heartBeatWarningValue.value.id.isNotEmpty ||
                    sensorValueController
                        .temperatureWarningValue.value.id.isNotEmpty) ...[
                  const SizedBox(height: 8.0),
                  RichText(
                    text: TextSpan(
                      text:
                          'We would like to inform you that our health monitoring '
                          'device has detected an variations in the ',
                      style: const TextStyle(
                          color: Colors.black, fontSize: 14, height: 1.5),
                      children: [
                        if (sensorValueController
                            .heartBeatWarningValue.value.id.isNotEmpty)
                          TextSpan(
                            text: 'Heart rate on '
                                '${DateFormat("dd/MM/yyyy, hh:mm a").format(sensorValueController.heartBeatWarningValue.value.createdAt)}'
                                ' by ${sensorValueController.heartBeatWarningValue.value.value}BPM',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        if (sensorValueController
                                .heartBeatWarningValue.value.id.isNotEmpty &&
                            sensorValueController
                                .temperatureWarningValue.value.id.isNotEmpty)
                          const TextSpan(text: ' and '),
                        if (sensorValueController
                            .temperatureWarningValue.value.id.isNotEmpty)
                          TextSpan(
                            text: 'Temperature on '
                                '${DateFormat("dd/MM/yyyy, hh:mm a").format(sensorValueController.temperatureWarningValue.value.createdAt)}'
                                ' by ${sensorValueController.temperatureWarningValue.value.value}°F',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 8.0),
                ],
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      const Text("Full history heartbeat"),
                      TextButton(
                          onPressed: () =>
                              Get.to(() => const HeartBeatHistoryScreen()),
                          child: const Text("Click here"))
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      const Text("Full history temperature"),
                      TextButton(
                          onPressed: () =>
                              Get.to(() => const TemperatureHistoryScreen()),
                          child: const Text("Click here"))
                    ],
                  ),
                ),
                const SizedBox(height: 18.0),
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      const Text("For nearest hospitals"),
                      TextButton(
                          onPressed: () {
                            Get.to(() => const HospitalScreen());
                          },
                          child: const Text("Click here"))
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      const Text("For emergency contacts"),
                      TextButton(
                          onPressed: () {
                            Get.to(() => const ContactsScreen());
                          },
                          child: const Text("Click here"))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
