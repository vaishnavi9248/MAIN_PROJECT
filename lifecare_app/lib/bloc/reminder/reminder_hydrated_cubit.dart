import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lifecare/bloc/reminder/reminder_hydrated_state.dart';
import 'package:lifecare/data/models/reminder_model.dart';

class ReminderHydratedCubit extends HydratedCubit<ReminderHydratedState> {
  ReminderHydratedCubit() : super(ReminderHydratedState.initial());

  Future<List<ReminderModel>> getReminders() async =>
      state.reminderList.toList();

  void addNewReminder({required ReminderModel newData}) {
    List<ReminderModel> data = state.reminderList.toList();
    data.add(newData);

    emit(ReminderHydratedState(reminderList: data));
  }

  void updateReminder({required ReminderModel newData}) {
    List<ReminderModel> data = state.reminderList.toList();
    data.removeWhere((element) => element.id == newData.id);
    data.add(newData);

    emit(ReminderHydratedState(reminderList: data));
  }

  void deleteReminder({required int id}) {
    List<ReminderModel> data = state.reminderList.toList();
    data.removeWhere((element) => element.id == id);

    emit(ReminderHydratedState(reminderList: data));
  }

  @override
  ReminderHydratedState? fromJson(Map<String, dynamic> json) {
    return ReminderHydratedState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ReminderHydratedState state) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reminderList'] = state.reminderList;

    return data;
  }
}
