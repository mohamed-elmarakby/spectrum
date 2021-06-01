import 'dart:convert';

FriendsResponse friendsResponseFromJson(String str) => FriendsResponse.fromJson(json.decode(str));

String friendsResponseToJson(FriendsResponse data) => json.encode(data.toJson());

class FriendsResponse {
    FriendsResponse({
        this.id,
        this.friends,
    });

    String id;
    List<Friend> friends;

    factory FriendsResponse.fromJson(Map<String, dynamic> json) => FriendsResponse(
        id: json["_id"],
        friends: List<Friend>.from(json["friends"].map((x) => Friend.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "friends": List<dynamic>.from(friends.map((x) => x.toJson())),
    };
}

class Friend {
    Friend({
        this.id,
        this.friendId,
        this.chatId,
        this.date,
    });

    String id;
    Id friendId;
    String chatId;
    DateTime date;

    factory Friend.fromJson(Map<String, dynamic> json) => Friend(
        id: json["_id"],
        friendId: Id.fromJson(json["id"]),
        chatId: json["chatId"],
        date: DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "id": friendId.toJson(),
        "chatId": chatId,
        "date": date.toIso8601String(),
    };
}

class Id {
    Id({
        this.image,
        this.id,
        this.name,
    });

    String image;
    String id;
    String name;

    factory Id.fromJson(Map<String, dynamic> json) => Id(
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
