// ignore_for_file: invalid_use_of_protected_member

import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lifecare/controller/sensor_values_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final SensorValuesController sensorValueController = Get.put(
    SensorValuesController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LifeCare"),
        centerTitle: true,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        elevation: 1.0,
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
                    "  ${sensorValueController.heartBeatList.last.round()} BPM",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: Obx(
                    () => Sparkline(
                      data: sensorValueController.heartBeatList.value,
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
                    "${sensorValueController.temperatureList.last} °C",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: Obx(
                    () => Sparkline(
                      data: sensorValueController.temperatureList.value,
                      enableGridLines: true,
                      //fillMode: FillMode.below,
                      //fillColor: Colors.red.withOpacity(0.5),
                      gridLineAmount: 12,
                      max: 37.2,
                      min: 36.1,
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
