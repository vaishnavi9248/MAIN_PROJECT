import 'package:lifecare/data/enum/days_enum.dart';

class ReminderModel {
  final int id;
  final String title;
  final DateTime dateTime;
  final List<DaysEnum> repeat;

  ReminderModel({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.repeat,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    List<DaysEnum> repeat = [];

    if (json['repeat'] != null) {
      json['repeat'].forEach((v) => repeat.add(DaysEnum.values
          .where((element) => element.title == v)
          .toList()
          .first));
    }

    return ReminderModel(
      id: json["_id"],
      title: json["title"],
      repeat: repeat,
      dateTime: json["dateTime"] != null
          ? DateTime.parse(json["dateTime"].toString())
          : DateTime.now(),
    );
  }

  factory ReminderModel.initial() => ReminderModel(
        id: DateTime.now().microsecond,
        title: "",
        dateTime: DateTime.now(),
        repeat: [],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['title'] = title;
    data['dateTime'] = dateTime.toString();
    data['repeat'] = repeat.map((v) => v.title).toList();
    return data;
  }
}
