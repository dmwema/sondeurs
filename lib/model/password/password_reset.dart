class PasswordReset {
  int? id;
  String? email;
  String? code;

  PasswordReset({this.id, this.email, this.code});

  PasswordReset.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['code'] = this.code;
    return data;
  }
}