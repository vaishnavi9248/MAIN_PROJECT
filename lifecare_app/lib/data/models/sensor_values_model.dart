class SensorsValueModel {
  final String id;
  final double value;
  final DateTime createdAt;

  SensorsValueModel({
    this.id = "",
    required this.value,
    required this.createdAt,
  });

  factory SensorsValueModel.fromJson(Map<String, dynamic> json) =>
      SensorsValueModel(
        id: json["_id"],
        value: double.parse(json["value"].toString()),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  factory SensorsValueModel.initial() => SensorsValueModel(
        id: "",
        value: 0,
        createdAt: DateTime.now(),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['value'] = value;
    data['createdAt'] = createdAt;
    return data;
  }
}
