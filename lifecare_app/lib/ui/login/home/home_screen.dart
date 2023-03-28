import 'dart:async';
import 'dart:math';

import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static Random random = Random();

  List<double> heartBeatList = [];
  List<double> temperatureList = [];

  @override
  void initState() {
    generateCountList();
    addNewValue();
    super.initState();
  }

  void addNewValue() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      Random random = Random();
      double newHeart = 60 + random.nextDouble() * (100 - 60);
      heartBeatList.removeAt(0);
      heartBeatList.add(newHeart);
      setState(() {});
    });
  }

  void generateCountList() {
    heartBeatList =
        List.generate(30, (_) => 60 + random.nextDouble() * (100 - 60));

    temperatureList = List.generate(
        30,
        (_) => double.parse(
            (36.1 + random.nextDouble() * (37.2 - 36.1)).toStringAsFixed(2)));
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
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300.0,
                  child: Sparkline(
                    data: temperatureList,
                    enableGridLines: true,
                    fillMode: FillMode.below,
                    fillColor: Colors.red.withOpacity(0.5),
                    gridLineAmount: 15,
                    max: 37.4,
                    min: 36,
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  height: 300.0,
                  child: Sparkline(
                    data: heartBeatList,
                    enableGridLines: true,
                    fillMode: FillMode.below,
                    fillColor: Colors.red.withOpacity(0.5),
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
