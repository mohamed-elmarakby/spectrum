class InsideChatResponseModel {
  ChatInfo chatInfo;
  List<Messages> messages;

  InsideChatResponseModel({this.chatInfo, this.messages});

  InsideChatResponseModel.fromJson(Map<String, dynamic> json) {
    chatInfo = json['chatInfo'] != null
        ? new ChatInfo.fromJson(json['chatInfo'])
        : null;
    if (json['messages'] != null) {
      messages = new List<Messages>();
      json['messages'].forEach((v) {
        messages.add(new Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.chatInfo != null) {
      data['chatInfo'] = this.chatInfo.toJson();
    }
    if (this.messages != null) {
      data['messages'] = this.messages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatInfo {
  List<Users> users;
  String sId;
  int iV;

  ChatInfo({this.users, this.sId, this.iV});

  ChatInfo.fromJson(Map<String, dynamic> json) {
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

class Messages {
  bool seen;
  String sId;
  Users senderId;
  String chat;
  String content;

  Messages({this.seen, this.sId, this.senderId, this.content});

  Messages.fromJson(Map<String, dynamic> json) {
    seen = json['seen'];
    sId = json['_id'];
    chat = json['chat'];
    senderId =
        json['senderId'] != null ? new Users.fromJson(json['senderId']) : null;
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seen'] = this.seen;
    data['chat'] = this.chat;
    data['_id'] = this.sId;
    if (this.senderId != null) {
      data['senderId'] = this.senderId.toJson();
    }
    data['content'] = this.content;
    return data;
  }
}
