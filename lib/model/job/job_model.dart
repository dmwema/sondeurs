class JobModel {
  int? id;
  String? title;
  String? hourlyRate;
  String? margin;

  JobModel({this.id, this.title, this.hourlyRate, this.margin});

  JobModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    hourlyRate = json['hourlyRate'];
    margin = json['margin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['hourlyRate'] = hourlyRate;
    data['margin'] = margin;
    return data;
  }
}