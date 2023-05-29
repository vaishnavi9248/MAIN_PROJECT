import 'package:equatable/equatable.dart';
import 'package:lifecare/data/models/reminder_model.dart';

class ReminderHydratedState extends Equatable {
  final List<ReminderModel> reminderList;

  const ReminderHydratedState({
    required this.reminderList,
  });

  factory ReminderHydratedState.initial() {
    return const ReminderHydratedState(
      reminderList: [],
    );
  }

  factory ReminderHydratedState.fromJson(Map<String, dynamic> json) {
    var reminderList = <ReminderModel>[];
    if (json['reminderList'] != null) {
      json['reminderList'].forEach((v) {
        reminderList.add(ReminderModel.fromJson(v));
      });
    }

    return ReminderHydratedState(
      reminderList: reminderList,
    );
  }

  @override
  List<Object?> get props => [
        reminderList,
      ];
}
