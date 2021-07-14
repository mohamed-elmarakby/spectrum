class ReceivedFriendRequestSocketModel {
  Sender sender;
  Reciever reciever;

  ReceivedFriendRequestSocketModel({this.sender, this.reciever});

  ReceivedFriendRequestSocketModel.fromJson(Map<String, dynamic> json) {
    sender =
        json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    reciever = json['reciever'] != null
        ? new Reciever.fromJson(json['reciever'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sender != null) {
      data['sender'] = this.sender.toJson();
    }
    if (this.reciever != null) {
      data['reciever'] = this.reciever.toJson();
    }
    return data;
  }
}

class Sender {
  String image;
  String cover;
  String name;
  String email;
  String address;

  Sender({this.image, this.cover, this.name, this.email, this.address});

  Sender.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    cover = json['cover'];
    name = json['name'];
    email = json['email'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['cover'] = this.cover;
    data['name'] = this.name;
    data['email'] = this.email;
    data['address'] = this.address;
    return data;
  }
}

class Reciever {
  String image;
  String cover;
  String sId;
  String name;
  String email;
  String address;

  Reciever(
      {this.image, this.cover, this.sId, this.name, this.email, this.address});

  Reciever.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    cover = json['cover'];
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['cover'] = this.cover;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['address'] = this.address;
    return data;
  }
}
