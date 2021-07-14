class ReceivedFriendRequestModel {
  String image;
  String sId;
  String name;

  ReceivedFriendRequestModel({this.image, this.sId, this.name});

  ReceivedFriendRequestModel.fromJson(Map<String, dynamic> json) {
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
