import 'dart:async';
import 'dart:math';

import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<double> heartBeatList = [];
List<double> temperatureList = [];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static Random random = Random();

  @override
  void initState() {
    generateCountList();
    updateHeartBeat();
    updateTemperature();
    super.initState();
  }

  void generateCountList() {
    heartBeatList =
        List.generate(50, (_) => 60 + random.nextDouble() * (100 - 60));

    temperatureList = List.generate(
        50,
        (_) => double.parse(
            (36.1 + random.nextDouble() * (37.2 - 36.1)).toStringAsFixed(2)));
  }

  void updateHeartBeat() {
    Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      Random random = Random();
      double newHeart = double.parse(
          (60 + random.nextDouble() * (100 - 60)).toStringAsFixed(2));
      heartBeatList.removeAt(0);
      heartBeatList.add(newHeart);
      setState(() {});
    });
  }

  void updateTemperature() {
    Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      Random random = Random();
      double newTempe = double.parse(
          (36.1 + random.nextDouble() * (37.2 - 36.1)).toStringAsFixed(2));
      temperatureList.removeAt(0);
      temperatureList.add(newTempe);
      setState(() {});
    });
  }

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
                Text(
                  "  ${heartBeatList.last.round()} BPM",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: Sparkline(
                    data: heartBeatList,
                    enableGridLines: true,
                    // fillMode: FillMode.below,
                    // fillColor: Colors.red.withOpacity(0.5),
                    min: 60,
                    max: 100,
                    gridLineAmount: 9,
                  ),
                ),
                const SizedBox(height: 12.0),
                const Text(
                  "Temperature",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0),
                ),
                const SizedBox(height: 4.0),
                Text(
                  "${temperatureList.last} °C",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: Sparkline(
                    data: temperatureList,
                    enableGridLines: true,
                    //fillMode: FillMode.below,
                    //fillColor: Colors.red.withOpacity(0.5),
                    gridLineAmount: 12,
                    max: 37.2,
                    min: 36.1,
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
