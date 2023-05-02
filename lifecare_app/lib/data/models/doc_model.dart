class DocModel {
  final String id, noteId, name, url;

  DocModel({
    this.id = "",
    required this.noteId,
    required this.name,
    required this.url,
  });

  factory DocModel.fromMap(Map<String, dynamic> json) => DocModel(
        id: json["_id"],
        noteId: json["noteId"],
        name: json["name"],
        url: json["url"],
      );

  factory DocModel.initial() => DocModel(
        id: "",
        noteId: "",
        name: "",
        url: "",
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['noteId'] = noteId;
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}
