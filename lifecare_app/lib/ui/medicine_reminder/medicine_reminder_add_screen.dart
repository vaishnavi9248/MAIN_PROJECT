import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:lifecare/bloc/reminder/reminder_hydrated_cubit.dart';
import 'package:lifecare/data/enum/days_enum.dart';
import 'package:lifecare/data/models/medicine_reminder_model.dart';

class MedicineReminderAddScreen extends StatefulWidget {
  const MedicineReminderAddScreen({Key? key, this.reminderModel})
      : super(key: key);

  final MedicineReminderModel? reminderModel;

  @override
  State<MedicineReminderAddScreen> createState() =>
      _MedicineReminderAddScreenState();
}

class _MedicineReminderAddScreenState extends State<MedicineReminderAddScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController countController = TextEditingController();

  DateTime reminderTime = DateTime.now();

  List<DaysEnum> days = [];
  List<MedicineDetails> medicines = [
    MedicineDetails(name: "Dolo", count: 1),
    MedicineDetails(name: "Amoxicillin", count: 1),
    MedicineDetails(name: "Ocaset", count: 1),
  ];

  @override
  void initState() {
    if (widget.reminderModel != null) {
      titleController.text = widget.reminderModel!.title;
      days = widget.reminderModel!.repeat;
      medicines = widget.reminderModel!.medicineList;
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
          child: SingleChildScrollView(
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
                                    .deleteMedicineReminder(
                                        id: widget.reminderModel!.id);
                                Navigator.pop(context, ["refresh"]);
                              },
                        child: Text(
                            widget.reminderModel == null ? "Cancel" : "Delete",
                            style: const TextStyle(color: Colors.red))),
                    const Text(
                      "Set Reminder",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    TextButton(
                      onPressed: () {
                        if (widget.reminderModel == null) {
                          context
                              .read<ReminderHydratedCubit>()
                              .addNewMedicineReminder(
                                newData: MedicineReminderModel(
                                  id: DateTime.now().microsecondsSinceEpoch,
                                  title: titleController.text,
                                  dateTime: reminderTime,
                                  repeat: days,
                                  medicineList: medicines,
                                ),
                              );
                        } else {
                          context
                              .read<ReminderHydratedCubit>()
                              .updateMedicineReminder(
                                newData: MedicineReminderModel(
                                  id: widget.reminderModel!.id,
                                  title: titleController.text,
                                  dateTime: reminderTime,
                                  repeat: days,
                                  medicineList: medicines,
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
                const Text(
                  "Medicines:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: medicines.isNotEmpty
                          ? Border.all(color: Colors.black)
                          : null),
                  margin: EdgeInsets.symmetric(
                      vertical: medicines.isNotEmpty ? 8.0 : 4.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: medicines.length,
                    itemBuilder: (BuildContext context, int index) {
                      MedicineDetails medicine = medicines[index];

                      return Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(medicine.name)),
                            const SizedBox(width: 10.0),
                            Text("${medicine.count}"),
                            const SizedBox(width: 20.0),
                            IconButton(
                                onPressed: () {
                                  setState(() => medicines.removeAt(index));
                                },
                                icon: const Icon(Icons.cancel))
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        thickness: 1.0,
                        height: 1,
                        color: Colors.black,
                      );
                    },
                  ),
                ),
                if (medicines.isNotEmpty) const SizedBox(height: 12.0),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: "Medicine name...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: countController,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false),
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: "Count",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isNotEmpty &&
                              countController.text.isNotEmpty) {
                            final MedicineDetails medicine = MedicineDetails(
                                name: nameController.text,
                                count: double.parse(countController.text));

                            setState(() {
                              medicines.add(medicine);
                              nameController.clear();
                              countController.clear();
                            });
                          }
                        },
                        child: const Text("Add"))
                  ],
                ),
                const SizedBox(height: 18.0),
                Row(
                  children: [
                    const Text(
                      "Repeat:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0),
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
                                color:
                                    days.contains(value) ? Colors.white : null,
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
      ),
    );
  }
}
