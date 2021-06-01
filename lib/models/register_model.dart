import 'dart:convert';

RegisterResponse registerModelFromJson(String str) =>
    RegisterResponse.fromJson(json.decode(str));

String registerModelToJson(RegisterResponse data) => json.encode(data.toJson());

class RegisterResponse {
  RegisterResponse({
    this.user,
    this.created,
    this.text,
  });

  User user;
  bool created;
  String text;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
        user: User.fromJson(json["user"]),
        created: json["created"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "created": created,
        "text": text,
      };
}

class User {
  User({
    this.image,
    this.cover,
    this.friendRequests,
    this.sentRequests,
    this.verificationKey,
    this.posts,
    this.id,
    this.name,
    this.email,
    this.password,
    this.age,
    this.address,
    this.friends,
    this.notifications,
    this.groups,
    this.v,
  });

  String image;
  String cover;
  List<dynamic> friendRequests;
  List<dynamic> sentRequests;
  dynamic verificationKey;
  List<dynamic> posts;
  String id;
  String name;
  String email;
  String password;
  int age;
  String address;
  List<dynamic> friends;
  List<dynamic> notifications;
  List<dynamic> groups;
  int v;

  factory User.fromJson(Map<String, dynamic> json) => User(
        image: json["image"],
        cover: json["cover"],
        friendRequests:
            List<dynamic>.from(json["friendRequests"].map((x) => x)),
        sentRequests: List<dynamic>.from(json["sentRequests"].map((x) => x)),
        verificationKey: json["verificationKey"],
        posts: List<dynamic>.from(json["posts"].map((x) => x)),
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        age: json["age"],
        address: json["address"],
        friends: List<dynamic>.from(json["friends"].map((x) => x)),
        notifications: List<dynamic>.from(json["notifications"].map((x) => x)),
        groups: List<dynamic>.from(json["groups"].map((x) => x)),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "cover": cover,
        "friendRequests": List<dynamic>.from(friendRequests.map((x) => x)),
        "sentRequests": List<dynamic>.from(sentRequests.map((x) => x)),
        "verificationKey": verificationKey,
        "posts": List<dynamic>.from(posts.map((x) => x)),
        "_id": id,
        "name": name,
        "email": email,
        "password": password,
        "age": age,
        "address": address,
        "friends": List<dynamic>.from(friends.map((x) => x)),
        "notifications": List<dynamic>.from(notifications.map((x) => x)),
        "groups": List<dynamic>.from(groups.map((x) => x)),
        "__v": v,
      };
}



