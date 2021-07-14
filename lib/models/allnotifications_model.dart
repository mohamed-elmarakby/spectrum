class AllNotificationsModel {
  String sId;
  String notification;
  String postId;
  bool isFriendRequest;
  bool isViewed;
  String commentId;
  String likeId;
  String date;

  AllNotificationsModel(
      {this.sId,
      this.notification,
      this.postId,
      this.isFriendRequest = false,
      this.isViewed,
      this.commentId,
      this.likeId,
      this.date});

  AllNotificationsModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    notification = json['notification'];
    postId = json['postId'];
    likeId = json['likeId'];
    isViewed = json['isViewed'];
    commentId = json['commentId'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['notification'] = this.notification;
    data['postId'] = this.postId;
    data['likeId'] = this.likeId;
    data['isViewed'] = this.isViewed;
    data['commentId'] = this.commentId;
    data['date'] = this.date;
    return data;
  }
}
