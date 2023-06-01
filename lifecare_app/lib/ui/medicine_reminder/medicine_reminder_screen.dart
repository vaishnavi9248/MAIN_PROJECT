import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lifecare/bloc/reminder/reminder_hydrated_cubit.dart';
import 'package:lifecare/data/enum/days_enum.dart';
import 'package:lifecare/data/models/medicine_reminder_model.dart';
import 'package:lifecare/ui/medicine_reminder/medicine_reminder_add_screen.dart';

class MedicineReminderScreen extends StatefulWidget {
  const MedicineReminderScreen({Key? key}) : super(key: key);

  @override
  State<MedicineReminderScreen> createState() => _MedicineReminderScreenState();
}

class _MedicineReminderScreenState extends State<MedicineReminderScreen> {
  bool loading = true;

  List<MedicineReminderModel> reminders = [];

  @override
  void initState() {
    getReminder();

    super.initState();
  }

  Future<void> getReminder() async {
    setState(() => loading = true);

    reminders = await BlocProvider.of<ReminderHydratedCubit>(context)
        .getMedicineReminders();
    reminders.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medicine Reminder"),
        centerTitle: false,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Get.bottomSheet(
            const MedicineReminderAddScreen(),
            isScrollControlled: true,
          );

          if (result != null) {
            getReminder();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loading ? () async => false : () async => getReminder(),
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : reminders.isNotEmpty
                  ? ListView.separated(
                      shrinkWrap: true,
                      itemCount: reminders.length,
                      itemBuilder: (BuildContext context, int index) {
                        MedicineReminderModel reminder = reminders[index];

                        final sortedRepeaters =
                            reminder.repeat.toSet().toList();

                        sortedRepeaters
                            .sort((a, b) => a.order.compareTo(b.order));

                        return InkWell(
                          onTap: () async {
                            var result = await Get.bottomSheet(
                              MedicineReminderAddScreen(
                                reminderModel: reminder,
                              ),
                              isScrollControlled: true,
                            );

                            if (result != null) {
                              getReminder();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      DateFormat("hh:mm a")
                                          .format(reminder.dateTime),
                                      style: const TextStyle(
                                        letterSpacing: 1,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        reminder.title,
                                        style: const TextStyle(
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4.0),
                                Text(sortedRepeaters.isEmpty
                                    ? "Ring once"
                                    : sortedRepeaters
                                        .map((e) => e.titleShort)
                                        .toList()
                                        .join(", ")),
                                const SizedBox(height: 4.0),
                                Text(
                                  reminder.medicineList
                                      .map((e) => e.name)
                                      .toList()
                                      .join(", "),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(thickness: 1.5);
                      },
                    )
                  : const Center(child: Text("No reminders")),
        ),
      ),
    );
  }
}
