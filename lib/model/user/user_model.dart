class UserModel {
  int? id;
  String? email;
  String? token;
  String? phoneNumber;
  String? imagePath;
  String? firstname;
  String? lastname;
  String? role;
  UserModel({
    this.id,
    this.email,
    this.phoneNumber,
    this.firstname,
    this.lastname,
    this.imagePath,
    this.token,
    this.role,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    role = json['role'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phoneNumber = json['phoneNumber'];
    imagePath = json['imagePath'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['phoneNumber'] = phoneNumber;
    data['imagePath'] = imagePath;
    data['role'] = role;
    data['token'] = token;
    return data;
  }
}