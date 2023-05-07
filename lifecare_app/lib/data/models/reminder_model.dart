class ReminderModel {
  final int id;
  final String message, title;
  final DateTime dateTime;

  ReminderModel({
    required this.id,
    required this.message,
    required this.title,
    required this.dateTime,
  });

  factory ReminderModel.fromMap(Map<String, dynamic> json) => ReminderModel(
        id: json["_id"],
        message: json["message"],
        title: json["title"],
        dateTime: json["phone"] != null
            ? DateTime.parse(json["phone"].toString())
            : DateTime.now(),
      );

  factory ReminderModel.initial() => ReminderModel(
        id: DateTime.now().microsecond,
        message: "",
        title: "",
        dateTime: DateTime.now(),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['message'] = message;
    data['title'] = title;
    data['dateTime'] = dateTime.toString();
    return data;
  }
}
