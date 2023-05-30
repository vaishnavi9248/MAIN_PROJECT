import 'package:equatable/equatable.dart';
import 'package:lifecare/data/models/medicine_reminder_model.dart';
import 'package:lifecare/data/models/reminder_model.dart';
import 'package:lifecare/data/models/sensor_values_model.dart';

class ReminderHydratedState extends Equatable {
  final List<ReminderModel> reminderList;
  final List<MedicineReminderModel> medicineReminderList;
  final SensorsValueModel temperatureAlertValue;
  final SensorsValueModel heartBeatAlertValue;

  const ReminderHydratedState({
    required this.reminderList,
    required this.medicineReminderList,
    required this.temperatureAlertValue,
    required this.heartBeatAlertValue,
  });

  factory ReminderHydratedState.initial() {
    return ReminderHydratedState(
      reminderList: const [],
      medicineReminderList: const [],
      temperatureAlertValue: SensorsValueModel.initial(),
      heartBeatAlertValue: SensorsValueModel.initial(),
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
      temperatureAlertValue: json['temperatureAlertValue'] != null
          ? SensorsValueModel.fromJson(json['temperatureAlertValue'])
          : SensorsValueModel.initial(),
      heartBeatAlertValue: json['heartBeatAlertValue'] != null
          ? SensorsValueModel.fromJson(json['heartBeatAlertValue'])
          : SensorsValueModel.initial(),
    );
  }

  @override
  List<Object?> get props => [
        reminderList,
        medicineReminderList,
        temperatureAlertValue,
        heartBeatAlertValue,
      ];
}
