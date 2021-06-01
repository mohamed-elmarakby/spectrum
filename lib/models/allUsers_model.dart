import 'dart:convert';

List<AllUsersResponse> allUsersResponseFromJson(String str) => List<AllUsersResponse>.from(json.decode(str).map((x) => AllUsersResponse.fromJson(x)));

String allUsersResponseToJson(List<AllUsersResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllUsersResponse {
    AllUsersResponse({
        this.image,
        this.id,
        this.name,
    });

    String image;
    String id;
    String name;

    factory AllUsersResponse.fromJson(Map<String, dynamic> json) => AllUsersResponse(
        image: json["image"],
        id: json["_id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "image": image,
        "_id": id,
        "name": name,
    };
}