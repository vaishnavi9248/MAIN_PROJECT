class ReportModel {
  final String id, title, description;

  ReportModel({
    this.id = "",
    required this.title,
    required this.description,
  });

  factory ReportModel.fromMap(Map<String, dynamic> json) => ReportModel(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
      );

  factory ReportModel.initial() => ReportModel(
        id: "",
        title: "",
        description: "",
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}
