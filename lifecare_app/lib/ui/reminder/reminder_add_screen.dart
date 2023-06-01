import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:lifecare/bloc/reminder/reminder_hydrated_cubit.dart';
import 'package:lifecare/data/enum/days_enum.dart';
import 'package:lifecare/data/models/reminder_model.dart';
import 'package:lifecare/data/services/notification_service.dart';

class ReminderAddScreen extends StatefulWidget {
  const ReminderAddScreen({Key? key, this.reminderModel}) : super(key: key);

  final ReminderModel? reminderModel;

  @override
  State<ReminderAddScreen> createState() => _ReminderAddScreenState();
}

class _ReminderAddScreenState extends State<ReminderAddScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();

  DateTime reminderTime = DateTime.now();

  List<DaysEnum> days = [];

  @override
  void initState() {
    if (widget.reminderModel != null) {
      titleController.text = widget.reminderModel!.title;
      days = widget.reminderModel!.repeat;
      reminderTime = widget.reminderModel!.dateTime;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: widget.reminderModel == null
                          ? () => Navigator.pop(context)
                          : () {
                              context
                                  .read<ReminderHydratedCubit>()
                                  .deleteReminder(id: widget.reminderModel!.id);
                              Navigator.pop(context, ["refresh"]);
                            },
                      child: Text(
                          widget.reminderModel == null ? "Cancel" : "Delete",
                          style: const TextStyle(color: Colors.red))),
                  const Text(
                    "Set Reminder",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  TextButton(
                    onPressed: () {
                      if (widget.reminderModel == null) {
                        ReminderModel data = ReminderModel(
                          id: DateTime.now().microsecondsSinceEpoch,
                          title: titleController.text,
                          dateTime: DateTime(
                            reminderTime.year,
                            reminderTime.month,
                            reminderTime.day,
                            reminderTime.hour,
                            reminderTime.minute,
                          ),
                          repeat: days,
                        );
                        context
                            .read<ReminderHydratedCubit>()
                            .addNewReminder(newData: data);
                        // FlutterAlarmClock.createAlarm(
                        //   reminderTime.hour,
                        //   reminderTime.minute,
                        //   title: titleController.text,
                        // );
                        globalNotificationService.showTimeNotification(data);
                      } else {
                        context.read<ReminderHydratedCubit>().updateReminder(
                              newData: ReminderModel(
                                id: widget.reminderModel!.id,
                                title: titleController.text,
                                dateTime: reminderTime,
                                repeat: days,
                              ),
                            );
                      }

                      Navigator.pop(context, ["refresh"]);
                    },
                    child: Text(
                        widget.reminderModel == null ? "Save" : "Update",
                        style: const TextStyle(color: Colors.red)),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              TimePickerSpinner(
                time: reminderTime,
                is24HourMode: false,
                spacing: 15,
                itemHeight: 50,
                onTimeChange: (time) => setState(() => reminderTime = time),
              ),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  const Text("Title:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0)),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: "Reminder",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "Repeat:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                  const SizedBox(width: 4.0),
                  for (var value in DaysEnum.values)
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (days.contains(value)) {
                            days.removeWhere((element) => element == value);
                          } else {
                            days.add(value);
                          }
                        });
                      },
                      child: Container(
                        width: 25.0,
                        height: 25.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          border: days.contains(value) ? null : Border.all(),
                          color: days.contains(value) ? Colors.teal : null,
                        ),
                        child: Center(
                          child: Text(
                            value.titleSingleWord,
                            style: TextStyle(
                              color: days.contains(value) ? Colors.white : null,
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
