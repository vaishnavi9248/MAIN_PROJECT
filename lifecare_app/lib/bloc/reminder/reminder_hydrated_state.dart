import 'package:equatable/equatable.dart';
import 'package:lifecare/data/models/medicine_reminder_model.dart';
import 'package:lifecare/data/models/reminder_model.dart';

class ReminderHydratedState extends Equatable {
  final List<ReminderModel> reminderList;
  final List<MedicineReminderModel> medicineReminderList;

  const ReminderHydratedState({
    required this.reminderList,
    required this.medicineReminderList,
  });

  factory ReminderHydratedState.initial() {
    return const ReminderHydratedState(
      reminderList: [],
      medicineReminderList: [],
    );
  }

  factory ReminderHydratedState.fromJson(Map<String, dynamic> json) {
    var reminderList = <ReminderModel>[];
    if (json['reminderList'] != null) {
      json['reminderList'].forEach((v) {
        reminderList.add(ReminderModel.fromJson(v));
      });
    }

    var medicineReminderList = <MedicineReminderModel>[];
    if (json['medicineReminderList'] != null) {
      json['medicineReminderList'].forEach((v) {
        medicineReminderList.add(MedicineReminderModel.fromJson(v));
      });
    }

    return ReminderHydratedState(
      reminderList: reminderList,
      medicineReminderList: medicineReminderList,
    );
  }

  @override
  List<Object?> get props => [
        reminderList,
        medicineReminderList,
      ];
}
