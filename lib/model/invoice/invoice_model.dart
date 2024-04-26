class InvoiceModel {
  int? id;
  String? code;
  String? date;
  String? total;
  bool? paid;

  InvoiceModel({this.id, this.code, this.date, this.total, this.paid});

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    date = json['date'];
    total = json['total'];
    paid = json['paid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['date'] = this.date;
    data['total'] = this.total;
    data['paid'] = this.paid;
    return data;
  }
}