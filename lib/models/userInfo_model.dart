import 'dart:convert';

UserInfoResponse userInfoResponseFromJson(String str) => UserInfoResponse.fromJson(json.decode(str));

String userInfoResponseToJson(UserInfoResponse data) => json.encode(data.toJson());

class UserInfoResponse {
    UserInfoResponse({
        this.image,
        this.cover,
        this.id,
        this.name,
        this.email,
        this.address,
    });

    String image;
    String cover;
    String id;
    String name;
    String email;
    String address;

    factory UserInfoResponse.fromJson(Map<String, dynamic> json) => UserInfoResponse(
        image: json["image"],
        cover: json["cover"],
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "image": image,
        "cover": cover,
        "_id": id,
        "name": name,
        "email": email,
        "address": address,
    };
}