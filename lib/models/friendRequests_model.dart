import 'dart:convert';

List<FriendRequestsResponse> friendRequestsResponseFromJson(String str) => List<FriendRequestsResponse>.from(json.decode(str).map((x) => FriendRequestsResponse.fromJson(x)));

String friendRequestsResponseToJson(List<FriendRequestsResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FriendRequestsResponse {
    FriendRequestsResponse({
        this.image,
        this.id,
        this.name,
    });

    String image;
    String id;
    String name;

    factory FriendRequestsResponse.fromJson(Map<String, dynamic> json) => FriendRequestsResponse(
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
