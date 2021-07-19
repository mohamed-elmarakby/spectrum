import 'dart:convert';

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));

String userInfoToJson(UserInfo data) => json.encode(data.toJson());

class UserInfo {
  UserInfo({
    this.id,
    this.name,
    this.email,
    this.mobileToken,
    this.image,
    this.cover,
    this.address,
    this.age,
    this.iat,
  });

  String id;
  String mobileToken;
  String name;
  String email;
  String image;
  String cover;
  String address;
  String age;
  int iat;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        image: json["image"],
        cover: json["cover"],
        address: json['address'],
        age: json['age'].toString(),
        iat: json["iat"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "image": image,
        "cover": cover,
        "iat": iat,
        "address": address,
        "age": age
      };
}
