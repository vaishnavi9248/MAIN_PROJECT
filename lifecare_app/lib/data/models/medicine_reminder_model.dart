import 'package:lifecare/data/enum/days_enum.dart';

class MedicineReminderModel {
  final int id;
  final String title;
  final DateTime dateTime;
  final List<DaysEnum> repeat;
  final List<MedicineDetails> medicineList;

  MedicineReminderModel({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.repeat,
    required this.medicineList,
  });

  factory MedicineReminderModel.fromJson(Map<String, dynamic> json) {
    List<DaysEnum> repeat = [];
    if (json['repeat'] != null) {
      json['repeat'].forEach((v) => repeat.add(DaysEnum.values
          .where((element) => element.title == v)
          .toList()
          .first));
    }

    List<MedicineDetails> medicineList = [];
    if (json['medicineList'] != null) {
      json['medicineList']
          .forEach((v) => medicineList.add(MedicineDetails.fromJson(v)));
    }

    return MedicineReminderModel(
      id: json["_id"],
      title: json["title"],
      repeat: repeat,
      medicineList: medicineList,
      dateTime: json["dateTime"] != null
          ? DateTime.parse(json["dateTime"].toString())
          : DateTime.now(),
    );
  }

  factory MedicineReminderModel.initial() => MedicineReminderModel(
        id: DateTime.now().microsecond,
        title: "",
        dateTime: DateTime.now(),
        repeat: [],
        medicineList: [],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['title'] = title;
    data['dateTime'] = dateTime.toString();
    data['repeat'] = repeat.map((v) => v.title).toList();
    data['medicineList'] = medicineList.map((v) => v.toJson()).toList();
    return data;
  }
}

class MedicineDetails {
  final String name;
  final double count;

  MedicineDetails({required this.name, required this.count});

  factory MedicineDetails.fromJson(Map<String, dynamic> json) {
    return MedicineDetails(
      name: json["name"],
      count: json["count"],
    );
  }

  factory MedicineDetails.initial() => MedicineDetails(
        name: "",
        count: 0,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['count'] = count;

    return data;
  }
}
