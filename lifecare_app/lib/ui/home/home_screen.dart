import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lifecare/const/preference_key.dart';
import 'package:lifecare/controller/sensor_values_controller.dart';
import 'package:lifecare/controller/socket_controller.dart';
import 'package:lifecare/data/services/shared_pref.dart';
import 'package:lifecare/ui/alert/alert_screen.dart';
import 'package:lifecare/ui/contacts/contacts_screen.dart';
import 'package:lifecare/ui/history/heartbeat_history_screen.dart';
import 'package:lifecare/ui/history/temperature_history_screen.dart';
import 'package:lifecare/ui/hospitals/hospital_screen.dart';
import 'package:lifecare/ui/login/login_screen.dart';
import 'package:lifecare/ui/medicine_reminder/medicine_reminder_screen.dart';
import 'package:lifecare/ui/reminder/reminder_screen.dart';
import 'package:lifecare/ui/reports/report_screen.dart';
import 'package:lifecare/util/show_custom_snackbar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);

  final SensorValuesController sensorValueController =
      Get.put(SensorValuesController());

  final SocketController socketController = Get.put(SocketController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LifeCare"),
        centerTitle: true,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        elevation: 1.0,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                  child: const Text("Temperature History"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 1));
                    Get.to(() => const TemperatureHistoryScreen());
                  }),
              PopupMenuItem(
                  child: const Text("HeartBeat History"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 1));
                    Get.to(() => const HeartBeatHistoryScreen());
                  }),
              PopupMenuItem(
                  child: const Text("Medicine Reminder"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 1));
                    Get.to(() => const MedicineReminderScreen());
                  }),
              PopupMenuItem(
                  child: const Text("General Reminder"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 1));
                    Get.to(() => const ReminderScreen());
                  }),
              PopupMenuItem(
                  child: const Text("Hospitals"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 1));
                    Get.to(() => const HospitalScreen());
                  }),
              PopupMenuItem(
                  child: const Text("Reports"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 1));
                    Get.to(() => const ReportScreen());
                  }),
              PopupMenuItem(
                  child: const Text("Contacts"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 1));
                    Get.to(() => const ContactsScreen());
                  }),
              PopupMenuItem(
                  child: const Text("Alert"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 1));
                    Get.to(() => const AlertScreen());
                  }),
              PopupMenuItem(
                  child: const Text("Sign-out"),
                  onTap: () async {
                    SharedPref()
                        .setBool(key: PreferenceKey.isLoggedIn, value: false);
                    showCustomSnackBar(message: "Successfully logged-out");
                    await Future.delayed(const Duration(milliseconds: 1));

                    Get.offAll(() => const LoginScreen());
                    Get.deleteAll();
                  }),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 22.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 12.0),
                const Text(
                  "HeartBeat",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0),
                ),
                const SizedBox(height: 4.0),
                Obx(
                  () => Text(
                    "C: ${sensorValueController.heartBeatMinValues.map((element) => element.value).last} / "
                    "Avg: ${sensorValueController.heartBeatAverage} BPM",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: Obx(
                    () => Sparkline(
                      data: sensorValueController.heartBeatMinValues
                          .map((element) => element.value)
                          .toList(),
                      enableGridLines: true,
                      // fillMode: FillMode.below,
                      // fillColor: Colors.red.withOpacity(0.5),
                      min: sensorValueController.heartBeatMin.value,
                      max: sensorValueController.heartBeatMax.value,
                      gridLineAmount: 9,
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                const Text(
                  "Temperature",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0),
                ),
                const SizedBox(height: 4.0),
                Obx(
                  () => Text(
                    "C: ${sensorValueController.temperatureMinValues.map((element) => element.value).last} / "
                    "Avg: ${sensorValueController.temperatureAverage} °f",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: Obx(
                    () => Sparkline(
                      data: sensorValueController.temperatureMinValues
                          .map((element) => element.value)
                          .toList(),
                      enableGridLines: true,
                      //fillMode: FillMode.below,
                      //fillColor: Colors.red.withOpacity(0.5),
                      gridLineAmount: 11,
                      min: sensorValueController.temperatureMin.value,
                      max: sensorValueController.temperatureMax.value,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
