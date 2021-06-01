class UserInfoSocketModel {
  String image;
  String cover;
  String sId;
  String name;
  String email;
  String address;

  UserInfoSocketModel(
      {this.image, this.cover, this.sId, this.name, this.email, this.address});

  UserInfoSocketModel.fromJson(Map<String, dynamic> json) {
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
