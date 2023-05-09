import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lifecare/controller/sensor_values_controller.dart';
import 'package:lifecare/data/models/sensor_values_model.dart';

class HeartBeatHistoryScreen extends StatefulWidget {
  const HeartBeatHistoryScreen({Key? key}) : super(key: key);

  @override
  State<HeartBeatHistoryScreen> createState() => _HeartBeatHistoryScreenState();
}

class _HeartBeatHistoryScreenState extends State<HeartBeatHistoryScreen> {
  final SensorValuesController sensorValueController = Get.find();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        sensorValueController.getMoreHeartBeatHistory();
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
    sensorValueController.getHeartBeatHistory();
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        centerTitle: false,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Obx(
          () => RefreshIndicator(
            onRefresh: sensorValueController.heartBeatLoading.value
                ? () async => false
                : () async => sensorValueController.getHeartBeatHistory(),
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
                          "Current value: ${sensorValueController.heartBeatMinValues.map((element) => element.value).last}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          "Avg value: ${sensorValueController.heartBeatAverage} BPM",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                    bottom: 4.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Row(
                    children: const [
                      SizedBox(width: 18),
                      Text(
                        "Date",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      Spacer(),
                      Text(
                        "BPM",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                        textAlign: TextAlign.end,
                      ),
                      SizedBox(width: 18),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: Obx(
                    () => sensorValueController.heartBeatLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : sensorValueController.heartBeatHistory.isNotEmpty
                            ? ListView.separated(
                                controller: scrollController,
                                itemCount: sensorValueController
                                    .heartBeatHistory.length,
                                itemBuilder: (BuildContext context, int index) {
                                  int newIndex = sensorValueController
                                          .heartBeatHistory.length -
                                      index -
                                      1;

                                  SensorsValueModel sensorsValueModel =
                                      sensorValueController
                                          .heartBeatHistory[newIndex];

                                  return ListTile(
                                    title: Row(
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
                                        const SizedBox(width: 17),
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
