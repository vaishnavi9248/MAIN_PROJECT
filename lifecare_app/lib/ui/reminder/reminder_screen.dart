import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lifecare/bloc/reminder/reminder_hydrated_cubit.dart';
import 'package:lifecare/data/enum/days_enum.dart';
import 'package:lifecare/data/models/reminder_model.dart';
import 'package:lifecare/ui/reminder/reminder_add_screen.dart';

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

  Future<void> getReminder() async {
    setState(() => loading = true);

    reminders =
        await BlocProvider.of<ReminderHydratedCubit>(context).getReminders();
    reminders.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("General Reminder"),
        centerTitle: false,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Get.bottomSheet(
            const ReminderAddScreen(),
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
                        ReminderModel reminder = reminders[index];

                        final sortedRepeaters =
                            reminder.repeat.toSet().toList();

                        sortedRepeaters
                            .sort((a, b) => a.order.compareTo(b.order));

                        return InkWell(
                          onTap: () async {
                            var result = await Get.bottomSheet(
                              ReminderAddScreen(reminderModel: reminder),
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
