import 'package:graduation_project/models/socket_models.dart/comment_added_socket_model.dart';

class LikeAddedSocketModel {
  String adder;
  String postOwner;
  dynamic likeId;
  String postId;
  NotificationModel notification;

  LikeAddedSocketModel(
      {this.adder,
      this.postOwner,
      this.likeId,
      this.postId,
      this.notification});

  LikeAddedSocketModel.fromJson(Map<String, dynamic> json) {
    adder = json['adder'];
    postOwner = json['postOwner'];
    likeId = json['likeId'];
    postId = json['postId'];
    notification = json['notification'] != null
        ? new NotificationModel.fromJson(json['notification'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adder'] = this.adder;
    data['postOwner'] = this.postOwner;
    data['likeId'] = this.likeId;
    data['postId'] = this.postId;
    if (this.notification != null) {
      data['notification'] = this.notification.toJson();
    }
    return data;
  }
}
