import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lifecare/controller/sensor_values_controller.dart';
import 'package:lifecare/data/models/sensor_values_model.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({Key? key}) : super(key: key);

  final SensorValuesController sensorValueController = Get.find();

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 12.0,
                bottom: 4.0,
                left: 16.0,
                right: 16.0,
              ),
              child: Obx(
                () => Row(
                  children: [
                    const SizedBox(width: 30),
                    const Expanded(
                      child: Text(
                        "Date",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "HBT\navg:${((sensorValueController.sensorsValues.map((element) => element.heartBeat).reduce((value, element) => value + element)) / sensorValueController.sensorsValues.length).toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "TEMP\navg:${((sensorValueController.sensorsValues.map((element) => element.temperature).reduce((value, element) => value + element)) / sensorValueController.sensorsValues.length).toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  itemCount: sensorValueController.sensorsValues.length,
                  itemBuilder: (BuildContext context, int index) {
                    int newIndex =
                        sensorValueController.sensorsValues.length - index - 1;

                    SensorsValueModel sensorsValueModel =
                        sensorValueController.sensorsValues[newIndex];

                    return ListTile(
                      title: Row(
                        children: [
                          Text("${index + 1})"),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: Text(DateFormat("hh:mm:ss dd/MM/yy")
                                .format(sensorsValueModel.dateTime)),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "${sensorsValueModel.heartBeat} BPM",
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "${sensorsValueModel.temperature} °f",
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
