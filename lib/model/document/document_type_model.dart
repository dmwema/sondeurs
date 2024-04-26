class DocumentTypeModel {
  int?    id;
  String? title;
  String? type;
  String? description;

  DocumentTypeModel({
    this.id,
    this.title,
    this.type,
    this.description
  });

  DocumentTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['description'] = description;
    return data;
  }
}