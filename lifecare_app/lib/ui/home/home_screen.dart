import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lifecare/const/preference_key.dart';
import 'package:lifecare/controller/sensor_values_controller.dart';
import 'package:lifecare/controller/socket_controller.dart';
import 'package:lifecare/data/services/shared_pref.dart';
import 'package:lifecare/ui/contacts/contacts_screen.dart';
import 'package:lifecare/ui/history/history_screen.dart';
import 'package:lifecare/ui/hospitals/hospital_screen.dart';
import 'package:lifecare/ui/login/login_screen.dart';
import 'package:lifecare/util/show_custom_snackbar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

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
              PopupMenuItem(child: const Text("Alert"), onTap: () {}),
              PopupMenuItem(
                  child: const Text("History"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 1));
                    Get.to(() => HistoryScreen());
                  }),
              PopupMenuItem(child: const Text("Reports"), onTap: () async {}),
              PopupMenuItem(child: const Text("Reminder"), onTap: () {}),
              PopupMenuItem(
                  child: const Text("Hospitals"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 1));
                    Get.to(() => const HospitalScreen());
                  }),
              PopupMenuItem(
                  child: const Text("Contacts"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 1));
                    Get.to(() => const ContactsScreen());
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
                    "  ${sensorValueController.sensorsValues.map((element) => element.heartBeat).last.round()} BPM",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: Obx(
                    () => Sparkline(
                      data: sensorValueController.sensorsValues
                          .map((element) => element.heartBeat)
                          .toList(),
                      enableGridLines: true,
                      // fillMode: FillMode.below,
                      // fillColor: Colors.red.withOpacity(0.5),
                      min: 60,
                      max: 100,
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
                    "${sensorValueController.sensorsValues.map((element) => element.temperature).last} °f",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: Obx(
                    () => Sparkline(
                      data: sensorValueController.sensorsValues
                          .map((element) => element.temperature)
                          .toList(),
                      enableGridLines: true,
                      //fillMode: FillMode.below,
                      //fillColor: Colors.red.withOpacity(0.5),
                      gridLineAmount: 11,
                      max: 99,
                      min: 97,
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
