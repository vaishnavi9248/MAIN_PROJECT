import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lifecare/bloc/reminder/reminder_hydrated_state.dart';
import 'package:lifecare/data/models/medicine_reminder_model.dart';
import 'package:lifecare/data/models/reminder_model.dart';

class ReminderHydratedCubit extends HydratedCubit<ReminderHydratedState> {
  ReminderHydratedCubit() : super(ReminderHydratedState.initial());

  Future<List<ReminderModel>> getReminders() async =>
      state.reminderList.toList();

  void addNewReminder({required ReminderModel newData}) {
    List<ReminderModel> data = state.reminderList.toList();
    List<MedicineReminderModel> medicineReminderList =
        state.medicineReminderList.toList();
    data.add(newData);

    emit(ReminderHydratedState(
      reminderList: data,
      medicineReminderList: medicineReminderList,
    ));
  }

  void updateReminder({required ReminderModel newData}) {
    List<ReminderModel> data = state.reminderList.toList();
    List<MedicineReminderModel> medicineReminderList =
        state.medicineReminderList.toList();
    data.removeWhere((element) => element.id == newData.id);
    data.add(newData);

    emit(ReminderHydratedState(
      reminderList: data,
      medicineReminderList: medicineReminderList,
    ));
  }

  void deleteReminder({required int id}) {
    List<ReminderModel> data = state.reminderList.toList();
    List<MedicineReminderModel> medicineReminderList =
        state.medicineReminderList.toList();
    data.removeWhere((element) => element.id == id);

    emit(ReminderHydratedState(
      reminderList: data,
      medicineReminderList: medicineReminderList,
    ));
  }

  Future<List<MedicineReminderModel>> getMedicineReminders() async =>
      state.medicineReminderList.toList();

  void addNewMedicineReminder({required MedicineReminderModel newData}) {
    List<ReminderModel> data = state.reminderList.toList();
    List<MedicineReminderModel> medicineReminderList =
        state.medicineReminderList.toList();
    medicineReminderList.add(newData);

    emit(ReminderHydratedState(
      reminderList: data,
      medicineReminderList: medicineReminderList,
    ));
  }

  void updateMedicineReminder({required MedicineReminderModel newData}) {
    List<ReminderModel> data = state.reminderList.toList();
    List<MedicineReminderModel> medicineReminderList =
        state.medicineReminderList.toList();
    medicineReminderList.removeWhere((element) => element.id == newData.id);
    medicineReminderList.add(newData);

    emit(ReminderHydratedState(
      reminderList: data,
      medicineReminderList: medicineReminderList,
    ));
  }

  void deleteMedicineReminder({required int id}) {
    List<ReminderModel> data = state.reminderList.toList();
    List<MedicineReminderModel> medicineReminderList =
        state.medicineReminderList.toList();
    medicineReminderList.removeWhere((element) => element.id == id);

    emit(ReminderHydratedState(
      reminderList: data,
      medicineReminderList: medicineReminderList,
    ));
  }

  @override
  ReminderHydratedState? fromJson(Map<String, dynamic> json) {
    return ReminderHydratedState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ReminderHydratedState state) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reminderList'] = state.reminderList;
    data['medicineReminderList'] = state.medicineReminderList;

    return data;
  }
}
