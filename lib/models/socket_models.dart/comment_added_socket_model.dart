class CommentAddedSocketModel {
  String userId;
  String postOwner;
  Comment comment;
  String postId;
  NotificationModel notification;

  CommentAddedSocketModel(
      {this.userId,
      this.postOwner,
      this.comment,
      this.postId,
      this.notification});

  CommentAddedSocketModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    postOwner = json['postOwner'];
    comment =
        json['comment'] != null ? new Comment.fromJson(json['comment']) : null;
    postId = json['postId'];
    notification = json['notification'] != null
        ? new NotificationModel.fromJson(json['notification'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['postOwner'] = this.postOwner;
    if (this.comment != null) {
      data['comment'] = this.comment.toJson();
    }
    data['postId'] = this.postId;
    if (this.notification != null) {
      data['notification'] = this.notification.toJson();
    }
    return data;
  }
}

class Comment {
  bool isEdited;
  String sId;
  String commenterId;
  String text;

  Comment({this.isEdited, this.sId, this.commenterId, this.text});

  Comment.fromJson(Map<String, dynamic> json) {
    isEdited = json['isEdited'];
    sId = json['_id'];
    commenterId = json['commenterId'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isEdited'] = this.isEdited;
    data['_id'] = this.sId;
    data['commenterId'] = this.commenterId;
    data['text'] = this.text;
    return data;
  }
}

class NotificationModel {
  String sId;
  String notification;
  String postId;
  bool isViewed;
  bool isFriend;
  String commentId;
  String date;
  String likeId;

  NotificationModel(
      {this.sId,
      this.notification,
      this.postId,
      this.isViewed,
      this.isFriend = false,
      this.likeId,
      this.commentId,
      this.date});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    notification = json['notification'];
    postId = json['postId'];
    isViewed = json['isViewed'];
    likeId = json['likeId'];
    commentId = json['commentId'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['notification'] = this.notification;
    data['postId'] = this.postId;
    data['isViewed'] = this.isViewed;
    data['commentId'] = this.commentId;
    data['likeId'] = this.likeId;
    data['date'] = this.date;
    return data;
  }
}
