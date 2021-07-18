class MyFriendsModel {
  String sId;
  List<MyFriends> friends;

  MyFriendsModel({this.sId, this.friends});

  MyFriendsModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['friends'] != null) {
      friends = new List<MyFriends>();
      json['friends'].forEach((v) {
        friends.add(new MyFriends.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.friends != null) {
      data['friends'] = this.friends.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyFriends {
  String sId;
  Id id;
  bool isRequest;
  String chatId;
  bool chosen;
  String date;

  MyFriends(
      {this.sId,
      this.chosen = false,
      this.id,
      this.chatId,
      this.date,
      this.isRequest = false});

  MyFriends.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'] != null ? new Id.fromJson(json['id']) : null;
    chatId = json['chatId'];
    date = json['date'];
    chosen = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.id != null) {
      data['id'] = this.id.toJson();
    }
    data['chatId'] = this.chatId;
    data['date'] = this.date;
    return data;
  }
}

class Id {
  String image;
  String sId;
  String name;

  Id({this.image, this.sId, this.name});

  Id.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}
