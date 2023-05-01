class ContactsModel {
  final String id, name;
  final num number;

  ContactsModel({
    this.id = "",
    required this.name,
    required this.number,
  });

  factory ContactsModel.fromMap(Map<String, dynamic> json) => ContactsModel(
        id: json["_id"],
        name: json["name"],
        number: json["phone"],
      );

  factory ContactsModel.initial() => ContactsModel(
        id: "",
        name: "",
        number: 0,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['number'] = number;
    return data;
  }
}
