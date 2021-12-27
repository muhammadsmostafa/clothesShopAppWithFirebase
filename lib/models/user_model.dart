class UserModel
{
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? image;
  bool? admin;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.uId,
    required this.image,
    required this.admin,
  });

  UserModel.fromJson(Map <String, dynamic>? json)
  {
    name = json!['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    image = json['image'];
    admin = json['admin'];
  }

  Map <String, dynamic> toMap()
  {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'image': image,
      'admin': admin,
    };
  }
}