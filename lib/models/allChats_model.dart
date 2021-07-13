class AllChatsModel {
  bool seen;
  String sId;
  Chat chat;
  Users senderId;
  String date;
  String content;
  int iV;

  AllChatsModel(
      {this.seen,
      this.sId,
      this.chat,
      this.senderId,
      this.date,
      this.content,
      this.iV});

  AllChatsModel.fromJson(Map<String, dynamic> json) {
    seen = json['seen'];
    sId = json['_id'];
    chat = json['chat'] != null ? new Chat.fromJson(json['chat']) : null;
    senderId =
        json['senderId'] != null ? new Users.fromJson(json['senderId']) : null;
    date = json['date'];
    content = json['content'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seen'] = this.seen;
    data['_id'] = this.sId;
    if (this.chat != null) {
      data['chat'] = this.chat.toJson();
    }
    if (this.senderId != null) {
      data['senderId'] = this.senderId.toJson();
    }
    data['date'] = this.date;
    data['content'] = this.content;
    data['__v'] = this.iV;
    return data;
  }
}

class Chat {
  List<Users> users;
  String sId;
  int iV;

  Chat({this.users, this.sId, this.iV});

  Chat.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = new List<Users>();
      json['users'].forEach((v) {
        users.add(new Users.fromJson(v));
      });
    }
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}

class Users {
  String image;
  String sId;
  String name;

  Users({this.image, this.sId, this.name});

  Users.fromJson(Map<String, dynamic> json) {
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
