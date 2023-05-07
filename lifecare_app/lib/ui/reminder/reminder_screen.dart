import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifecare/data/models/reminder_model.dart';
import 'package:lifecare/main.dart';
import 'package:lifecare/util/custom_print.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool loading = true;

  List<ReminderModel> reminders = [];

  @override
  void initState() {
    getReminder();

    super.initState();
  }

  void getReminder() {
    setState(() => loading = true);

    reminders = [
      ReminderModel(
          id: DateTime.now().microsecondsSinceEpoch,
          message: "message",
          title: "title",
          dateTime: DateTime.now().add(const Duration(milliseconds: 500))),
      ReminderModel(
          id: DateTime.now().microsecondsSinceEpoch,
          message: "message1",
          title: "title1",
          dateTime: DateTime.now().add(const Duration(minutes: 1))),
      ReminderModel(
          id: DateTime.now().microsecondsSinceEpoch,
          message: "message2",
          title: "title2",
          dateTime: DateTime.now().add(const Duration(milliseconds: 2500))),
    ];

    for (var element in reminders) {
      customDebugPrint("element ${element.dateTime}");
      notificationGlobalService.showTimeNotification(element);
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearest reminderss"),
        centerTitle: false,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loading ? () async => false : () async => getReminder(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (String value) {},
                  decoration: const InputDecoration(
                    hintText: "Search by name, location, pincode...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text("Count: ${reminders.length}"),
              ),
              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : reminders.isNotEmpty
                        ? ListView.builder(
                            itemCount: reminders.length,
                            itemBuilder: (BuildContext context, int index) {
                              ReminderModel reminder = reminders[index];

                              return Container(
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.3),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12.0))),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Name: ${reminder.title}",
                                            style: const TextStyle(
                                                letterSpacing: 1),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            "Phone: ${reminder.message}",
                                            style: const TextStyle(
                                                letterSpacing: 1),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            "Phone: ${reminder.dateTime}",
                                            style: const TextStyle(
                                                letterSpacing: 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : const Center(child: Text("No reminders found")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
