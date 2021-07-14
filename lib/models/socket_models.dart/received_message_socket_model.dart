class ReceivedMessageSocketModel {
  bool seen;
  String sId;
  String chat;
  SenderId senderId;
  String date;
  String content;
  dynamic iV;
  String type;

  ReceivedMessageSocketModel(
      {this.seen,
      this.sId,
      this.chat,
      this.senderId,
      this.date,
      this.content,
      this.iV,
      this.type});

  ReceivedMessageSocketModel.fromJson(Map<String, dynamic> json) {
    seen = json['seen'];
    sId = json['_id'];
    chat = json['chat'];
    senderId = json['senderId'] != null
        ? new SenderId.fromJson(json['senderId'])
        : null;
    date = json['date'];
    content = json['content'];
    iV = json['__v'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seen'] = this.seen;
    data['_id'] = this.sId;
    data['chat'] = this.chat;
    if (this.senderId != null) {
      data['senderId'] = this.senderId.toJson();
    }
    data['date'] = this.date;
    data['content'] = this.content;
    data['__v'] = this.iV;
    data['type'] = this.type;
    return data;
  }
}

class SenderId {
  String image;
  String sId;
  String name;

  SenderId({this.image, this.sId, this.name});

  SenderId.fromJson(Map<String, dynamic> json) {
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
