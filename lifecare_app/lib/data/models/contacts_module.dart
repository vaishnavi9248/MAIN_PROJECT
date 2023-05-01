class ContactsModule {
  final String id, name;
  final num number;

  ContactsModule({this.id = "", required this.name, required this.number});

  factory ContactsModule.fromMap(Map<String, dynamic> json) => ContactsModule(
        id: json["_id"],
        name: json["name"],
        number: json["phone"],
      );

  factory ContactsModule.initial() => ContactsModule(
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
