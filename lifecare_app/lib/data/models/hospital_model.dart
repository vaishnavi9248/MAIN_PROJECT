class HospitalModel {
  final String id, name, location, address;
  final num pinCode, phone;

  HospitalModel({
    this.id = "",
    required this.name,
    required this.phone,
    required this.location,
    required this.address,
    required this.pinCode,
  });

  factory HospitalModel.fromMap(Map<String, dynamic> json) => HospitalModel(
        id: json["_id"],
        name: json["name"],
        phone: json["phone"],
        location: json["location"],
        address: json["address"],
        pinCode: json["pinCode"],
      );

  factory HospitalModel.initial() => HospitalModel(
        id: "",
        name: "",
        address: "",
        location: "",
        phone: 0,
        pinCode: 0,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['location'] = location;
    data['phone'] = phone;
    data['pinCode'] = pinCode;
    return data;
  }
}
