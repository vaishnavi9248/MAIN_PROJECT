import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lifecare/bloc/reminder/reminder_hydrated_state.dart';
import 'package:lifecare/data/models/medicine_reminder_model.dart';
import 'package:lifecare/data/models/reminder_model.dart';
import 'package:lifecare/data/models/sensor_values_model.dart';
import 'package:lifecare/util/custom_print.dart';

class ReminderHydratedCubit extends HydratedCubit<ReminderHydratedState> {
  ReminderHydratedCubit() : super(ReminderHydratedState.initial());

  Future<List<ReminderModel>> getReminders() async =>
      state.reminderList.toList();

  void addNewReminder({required ReminderModel newData}) {
    List<ReminderModel> data = state.reminderList.toList();
    List<MedicineReminderModel> medicineReminderList =
        state.medicineReminderList.toList();
    SensorsValueModel temperatureAlertValue = state.temperatureAlertValue;
    SensorsValueModel heartBeatAlertValue = state.heartBeatAlertValue;
    data.add(newData);

    emit(ReminderHydratedState(
      reminderList: data,
      medicineReminderList: medicineReminderList,
      temperatureAlertValue: temperatureAlertValue,
      heartBeatAlertValue: heartBeatAlertValue,
    ));
  }

  void updateReminder({required ReminderModel newData}) {
    List<ReminderModel> data = state.reminderList.toList();
    List<MedicineReminderModel> medicineReminderList =
        state.medicineReminderList.toList();
    SensorsValueModel temperatureAlertValue = state.temperatureAlertValue;
    SensorsValueModel heartBeatAlertValue = state.heartBeatAlertValue;
    data.removeWhere((element) => element.id == newData.id);
    data.add(newData);

    emit(ReminderHydratedState(
      reminderList: data,
      medicineReminderList: medicineReminderList,
      temperatureAlertValue: temperatureAlertValue,
      heartBeatAlertValue: heartBeatAlertValue,
    ));
  }

  void deleteReminder({required int id}) {
    List<ReminderModel> data = state.reminderList.toList();
    List<MedicineReminderModel> medicineReminderList =
        state.medicineReminderList.toList();
    SensorsValueModel temperatureAlertValue = state.temperatureAlertValue;
    SensorsValueModel heartBeatAlertValue = state.heartBeatAlertValue;
    data.removeWhere((element) => element.id == id);

    emit(ReminderHydratedState(
      reminderList: data,
      medicineReminderList: medicineReminderList,
      temperatureAlertValue: temperatureAlertValue,
      heartBeatAlertValue: heartBeatAlertValue,
    ));
  }

  Future<List<MedicineReminderModel>> getMedicineReminders() async =>
      state.medicineReminderList.toList();

  void addNewMedicineReminder({required MedicineReminderModel newData}) {
    List<ReminderModel> data = state.reminderList.toList();
    List<MedicineReminderModel> medicineReminderList =
        state.medicineReminderList.toList();
    SensorsValueModel temperatureAlertValue = state.temperatureAlertValue;
    SensorsValueModel heartBeatAlertValue = state.heartBeatAlertValue;
    medicineReminderList.add(newData);

    emit(ReminderHydratedState(
      reminderList: data,
      medicineReminderList: medicineReminderList,
      temperatureAlertValue: temperatureAlertValue,
      heartBeatAlertValue: heartBeatAlertValue,
    ));
  }

  void updateMedicineReminder({required MedicineReminderModel newData}) {
    List<ReminderModel> data = state.reminderList.toList();
    List<MedicineReminderModel> medicineReminderList =
        state.medicineReminderList.toList();
    SensorsValueModel temperatureAlertValue = state.temperatureAlertValue;
    SensorsValueModel heartBeatAlertValue = state.heartBeatAlertValue;
    medicineReminderList.removeWhere((element) => element.id == newData.id);
    medicineReminderList.add(newData);

    emit(ReminderHydratedState(
      reminderList: data,
      medicineReminderList: medicineReminderList,
      temperatureAlertValue: temperatureAlertValue,
      heartBeatAlertValue: heartBeatAlertValue,
    ));
  }

  void deleteMedicineReminder({required int id}) {
    List<ReminderModel> data = state.reminderList.toList();
    List<MedicineReminderModel> medicineReminderList =
        state.medicineReminderList.toList();
    SensorsValueModel temperatureAlertValue = state.temperatureAlertValue;
    SensorsValueModel heartBeatAlertValue = state.heartBeatAlertValue;
    medicineReminderList.removeWhere((element) => element.id == id);

    emit(ReminderHydratedState(
      reminderList: data,
      medicineReminderList: medicineReminderList,
      temperatureAlertValue: temperatureAlertValue,
      heartBeatAlertValue: heartBeatAlertValue,
    ));
  }

  void addTemperatureAlertValue({required SensorsValueModel newData}) {
    List<ReminderModel> data = state.reminderList.toList();
    List<MedicineReminderModel> medicineReminderList =
        state.medicineReminderList.toList();

    SensorsValueModel heartBeatAlertValue = state.heartBeatAlertValue;

    emit(ReminderHydratedState(
      reminderList: data,
      medicineReminderList: medicineReminderList,
      temperatureAlertValue: newData,
      heartBeatAlertValue: heartBeatAlertValue,
    ));

    customDebugPrint("addTemperatureAlertValue ${newData.toJson()} "
        "${state.heartBeatAlertValue.toJson()}");
  }

  void addHeartBeatAlertValue({required SensorsValueModel newData}) {
    List<ReminderModel> data = state.reminderList.toList();
    List<MedicineReminderModel> medicineReminderList =
        state.medicineReminderList.toList();

    SensorsValueModel temperatureAlertValue = state.temperatureAlertValue;

    emit(ReminderHydratedState(
      reminderList: data,
      medicineReminderList: medicineReminderList,
      temperatureAlertValue: temperatureAlertValue,
      heartBeatAlertValue: newData,
    ));

    customDebugPrint("addHeartBeatAlertValue ${newData.toJson()} "
        "${state.heartBeatAlertValue.toJson()}");
  }

  SensorsValueModel getHeartBeatAlertValue() => state.heartBeatAlertValue;

  SensorsValueModel getTemperatureAlertValue() => state.temperatureAlertValue;

  @override
  ReminderHydratedState? fromJson(Map<String, dynamic> json) {
    return ReminderHydratedState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ReminderHydratedState state) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reminderList'] = state.reminderList;
    data['medicineReminderList'] = state.medicineReminderList;
    data['temperatureAlertValue'] = state.temperatureAlertValue.toJson();
    data['heartBeatAlertValue'] = state.heartBeatAlertValue.toJson();

    return data;
  }
}
