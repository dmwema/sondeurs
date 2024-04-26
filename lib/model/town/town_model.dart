
class TownModel {
  int? id;
  String? name;
  bool? selected;

  TownModel({this.id, this.name, this.selected});

  TownModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['selected'] = selected;
    return data;
  }
}