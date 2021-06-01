class DislikeSocketModel {
  String adder;
  String postOwner;
  String likeId;
  String postId;

  DislikeSocketModel({this.adder, this.postOwner, this.likeId, this.postId});

  DislikeSocketModel.fromJson(Map<String, dynamic> json) {
    adder = json['adder'];
    postOwner = json['postOwner'];
    likeId = json['likeId'];
    postId = json['postId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adder'] = this.adder;
    data['postOwner'] = this.postOwner;
    data['likeId'] = this.likeId;
    data['postId'] = this.postId;
    return data;
  }
}
