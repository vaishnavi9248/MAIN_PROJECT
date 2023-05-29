import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lifecare/controller/sensor_values_controller.dart';
import 'package:lifecare/data/models/sensor_values_model.dart';

class TemperatureHistoryScreen extends StatefulWidget {
  const TemperatureHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TemperatureHistoryScreen> createState() =>
      _TemperatureHistoryScreenState();
}

class _TemperatureHistoryScreenState extends State<TemperatureHistoryScreen> {
  final SensorValuesController sensorValueController = Get.find();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        sensorValueController.getMoreTemperatureHistory();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sensorValueController.getTemperatureHistory();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Temperature History"),
        centerTitle: false,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Obx(
          () => RefreshIndicator(
            onRefresh: sensorValueController.temperatureLoading.value
                ? () async => false
                : () async => sensorValueController.getTemperatureHistory(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                    bottom: 4.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Current value: ${sensorValueController.temperatureMinValues.map((element) => element.value).last}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          "Avg value: ${sensorValueController.temperatureAverage} °F",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(12.0, 2.0, 16.0, 2.0),
                  child: Row(
                    children: [
                      Text(
                        "Date",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      Spacer(),
                      Text(
                        "°F",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: Obx(
                    () => sensorValueController.temperatureLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : sensorValueController.temperatureHistory.isNotEmpty
                            ? ListView.separated(
                                controller: scrollController,
                                itemCount: sensorValueController
                                    .temperatureHistory.length,
                                itemBuilder: (BuildContext context, int index) {
                                  int newIndex = sensorValueController
                                          .temperatureHistory.length -
                                      index -
                                      1;

                                  SensorsValueModel sensorsValueModel =
                                      sensorValueController
                                          .temperatureHistory[newIndex];

                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12.0, 2.0, 16.0, 2.0),
                                    child: Row(
                                      children: [
                                        Text("${index + 1})"),
                                        const SizedBox(width: 10),
                                        Text(DateFormat("dd/MM/yy hh:mm:ss")
                                            .format(
                                                sensorsValueModel.createdAt)),
                                        const Spacer(),
                                        Text(
                                          "${sensorsValueModel.value}",
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(),
                              )
                            : const Center(child: Text("No History found")),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
