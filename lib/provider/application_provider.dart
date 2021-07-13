import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/constant/constant.dart';
import 'package:graduation_project/models/allMyFriends_model.dart';
import 'package:graduation_project/models/allOfCurrentUser_model.dart';
import 'package:graduation_project/models/socket_models.dart/comment_added_socket_model.dart';
import 'package:graduation_project/models/socket_models.dart/dislike_socket_model.dart';
import 'package:graduation_project/models/socket_models.dart/like_added_socket_model.dart';
import 'package:graduation_project/models/socket_models.dart/user_info_socket_model.dart';
import 'package:graduation_project/services/home_services.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/sharedPreference.dart';

class ApplicationProvider with ChangeNotifier {
  AllOfCurrentUserModel allOfCurrentUserModel = AllOfCurrentUserModel();
  List<Posts> posts = [];
  List<Posts> someUserPosts = [];
  List<NotificationModel> notificationsList = [];
  List<UserInfoSocketModel> allOnline = [];
  List<UserInfoSocketModel> allUsers = [];
  List<MyFriends> allMyFriends = [];
  List<Posts> myPosts = [];
  int test = 0;
  bool isLoading = false;
  bool gotNotification;
  List<UserInfoSocketModel> getOnline() => allOnline;
  List<MyFriends> getFriends() => allMyFriends;
  getNotification() async {
    var tempNotificationState;
    tempNotificationState = await readData(key: 'hasNotification');
    if (tempNotificationState == null || tempNotificationState == "false") {
      gotNotification = false;
      await saveData(key: 'hasNotification', saved: "false");
    } else {
      gotNotification = true;
      await saveData(key: 'hasNotification', saved: "true");
    }
  }

  bool getLoading() => isLoading;
  List<Posts> getPosts() => posts;

  Future getAllMyFriends() async {
    allMyFriends = [];
    await HomeServices().getAllMyFriends(userId: user.id).then(
      (value) {
        allMyFriends = [];
        allMyFriends.addAll(
          value.friends,
        );
      },
    ).catchError((onError) {
      print(onError);
    }).whenComplete(() {
      final ids = allMyFriends.map((e) => e.sId).toSet();
      allMyFriends.retainWhere((x) => ids.remove(x.sId));
      log('all my friends users ' + allMyFriends.length.toString());
    });
  }

  Future getAllUsers() async {
    await HomeServices().getAllUsers().then((value) {
      allUsers = [];
      allUsers = value;
    }).catchError((onError) {
      print(onError);
    }).whenComplete(() {
      final ids = allUsers.map((e) => e.sId).toSet();
      allUsers.retainWhere((x) => ids.remove(x.sId));
      log('all system users ' + allUsers.length.toString());
    });
  }

  Future getAllPosts() async {
    isLoading = true;
    log('getting all posts...');
    await HomeServices().getAllOfCurrentUser(userId: user.id).then((value) {
      posts = [];
      allOfCurrentUserModel = value;
      for (var friend in allOfCurrentUserModel.friends) {
        for (var post in friend.id.posts) {
          posts.add(post);
        }
      }
      final ids = posts.map((e) => e.sId).toSet();
      posts.retainWhere((x) => ids.remove(x.sId));
      isLoading = false;
      notifyListeners();
    }).catchError((onError) {
      print(onError);
      isLoading = false;
    }).whenComplete(() {
      log('done getting posts.');
      log(posts.toString());
      isLoading = false;
      notifyListeners();
    });
    isLoading = false;
    notifyListeners();
  }

  Future getMyPosts() async {
    isLoading = true;
    log('getting my posts...');
    await HomeServices().getMyPost(userId: user.id).then((value) {
      myPosts = [];
      myPosts.addAll(value);
      final ids = myPosts.map((e) => e.sId).toSet();
      myPosts.retainWhere((x) => ids.remove(x.sId));
      isLoading = false;
      notifyListeners();
    }).catchError((onError) {
      print('in my posts error');
      print(onError);
      isLoading = false;
    }).whenComplete(() {
      log('done getting posts.');
      log(myPosts.toString());
      isLoading = false;
      notifyListeners();
    });
    isLoading = false;
    notifyListeners();
  }

  Future getSomeonePosts({String id}) async {
    isLoading = true;
    log('getting my posts...');
    await HomeServices().getExactUserPosts(userId: id).then((value) {
      someUserPosts = [];
      someUserPosts.addAll(value);
      final ids = someUserPosts.map((e) => e.sId).toSet();
      someUserPosts.retainWhere((x) => ids.remove(x.sId));
      isLoading = false;
      notifyListeners();
    }).catchError((onError) {
      print('in my posts error');
      print(onError);
      isLoading = false;
    }).whenComplete(() {
      log('done getting posts.');
      log(someUserPosts.toString());
      isLoading = false;
      notifyListeners();
    });
    isLoading = false;
    notifyListeners();
  }

  Future commentAdded({var data}) async {
    log(data.toString());
    log(data.runtimeType.toString());
    CommentAddedSocketModel commentAddedSocketModel =
        CommentAddedSocketModel.fromJson(data);
    Dio dio = Dio();
    await dio
        .get(
      Constants().apiUrl + 'info',
      options: Options(
        headers: {'id': commentAddedSocketModel.userId},
      ),
    )
        .then((value) {
      UserInfoSocketModel userInfoSocketModel = UserInfoSocketModel();
      notificationsList.add(commentAddedSocketModel.notification);
      userInfoSocketModel = UserInfoSocketModel.fromJson(value.data);
      myPosts[myPosts.indexWhere(
              (element) => element.sId == commentAddedSocketModel.postId)]
          .comments
          .add(Comments(
            commenterId: AuthorId(
              name: userInfoSocketModel.name,
              sId: userInfoSocketModel.sId,
              image: userInfoSocketModel.image,
            ),
            isEdited: commentAddedSocketModel.comment.isEdited,
            sId: commentAddedSocketModel.comment.sId,
            text: commentAddedSocketModel.comment.text,
          ));
      final ids = myPosts[myPosts.indexWhere(
              (element) => element.sId == commentAddedSocketModel.postId)]
          .comments
          .map((e) => e.sId)
          .toSet();
      myPosts[myPosts.indexWhere(
              (element) => element.sId == commentAddedSocketModel.postId)]
          .comments
          .retainWhere((x) => ids.remove(x.sId));
      log(myPosts[myPosts.indexWhere(
              (element) => element.sId == commentAddedSocketModel.postId)]
          .comments
          .first
          .text);
    });

    log(commentAddedSocketModel.comment.text);

    notifyListeners();
  }

  Future commentAddedS({var data}) async {
    log(data.toString());
    log(data.runtimeType.toString());
    CommentAddedSocketModel commentAddedSocketModel =
        CommentAddedSocketModel.fromJson(data);
    Dio dio = Dio();
    await dio
        .get(
      Constants().apiUrl + 'info',
      options: Options(
        headers: {'id': commentAddedSocketModel.userId},
      ),
    )
        .then((value) {
      UserInfoSocketModel userInfoSocketModel = UserInfoSocketModel();
      userInfoSocketModel = UserInfoSocketModel.fromJson(value.data);
      if (commentAddedSocketModel.comment.commenterId == user.id) {
        if (commentAddedSocketModel.postOwner == user.id) {
          myPosts[myPosts.indexWhere(
                  (element) => element.sId == commentAddedSocketModel.postId)]
              .comments
              .add(Comments(
                commenterId: AuthorId(
                  name: userInfoSocketModel.name,
                  sId: userInfoSocketModel.sId,
                  image: userInfoSocketModel.image,
                ),
                isEdited: commentAddedSocketModel.comment.isEdited,
                sId: commentAddedSocketModel.comment.sId,
                text: commentAddedSocketModel.comment.text,
              ));
          final ids = myPosts[myPosts.indexWhere(
                  (element) => element.sId == commentAddedSocketModel.postId)]
              .comments
              .map((e) => e.sId)
              .toSet();
          myPosts[myPosts.indexWhere(
                  (element) => element.sId == commentAddedSocketModel.postId)]
              .comments
              .retainWhere((x) => ids.remove(x.sId));
          log(myPosts[myPosts.indexWhere(
                  (element) => element.sId == commentAddedSocketModel.postId)]
              .comments
              .first
              .text);
        } else {
          posts[posts.indexWhere(
                  (element) => element.sId == commentAddedSocketModel.postId)]
              .comments
              .add(Comments(
                commenterId: AuthorId(
                  name: userInfoSocketModel.name,
                  sId: userInfoSocketModel.sId,
                  image: userInfoSocketModel.image,
                ),
                isEdited: commentAddedSocketModel.comment.isEdited,
                sId: commentAddedSocketModel.comment.sId,
                text: commentAddedSocketModel.comment.text,
              ));
          final ids = posts[posts.indexWhere(
                  (element) => element.sId == commentAddedSocketModel.postId)]
              .comments
              .map((e) => e.sId)
              .toSet();
          posts[posts.indexWhere(
                  (element) => element.sId == commentAddedSocketModel.postId)]
              .comments
              .retainWhere((x) => ids.remove(x.sId));
          log(posts[posts.indexWhere(
                  (element) => element.sId == commentAddedSocketModel.postId)]
              .comments
              .first
              .text);
        }
      }
    });

    log(commentAddedSocketModel.comment.text);

    notifyListeners();
  }

  Future addedLike({LikeAddedSocketModel likeAddedSocketModel}) async {
    log('like added');
    Dio dio = Dio();
    await dio
        .get(
      Constants().apiUrl + 'info',
      options: Options(
        headers: {'id': likeAddedSocketModel.adder},
      ),
    )
        .then((value) {
      UserInfoSocketModel userInfoSocketModel = UserInfoSocketModel();
      notificationsList.add(likeAddedSocketModel.notification);
      userInfoSocketModel = UserInfoSocketModel.fromJson(value.data);
      myPosts[myPosts.indexWhere(
              (element) => element.sId == likeAddedSocketModel.postId)]
          .likes
          .add(Likes(
            sId: likeAddedSocketModel.notification.likeId,
            date: likeAddedSocketModel.notification.date,
            id: AuthorId(
              name: userInfoSocketModel.name,
              sId: userInfoSocketModel.sId,
              image: userInfoSocketModel.image,
            ),
          ));
      final ids = myPosts[myPosts.indexWhere(
              (element) => element.sId == likeAddedSocketModel.postId)]
          .likes
          .map((e) => e.sId)
          .toSet();
      myPosts[myPosts.indexWhere(
              (element) => element.sId == likeAddedSocketModel.postId)]
          .likes
          .retainWhere((x) => ids.remove(x.sId));
    });
    notifyListeners();
  }

  Future addedLikeS({LikeAddedSocketModel likeAddedSocketModel}) async {
    log('like added');
    Dio dio = Dio();
    await dio
        .get(
      Constants().apiUrl + 'info',
      options: Options(
        headers: {'id': likeAddedSocketModel.adder},
      ),
    )
        .then((value) {
      UserInfoSocketModel userInfoSocketModel = UserInfoSocketModel();
      userInfoSocketModel = UserInfoSocketModel.fromJson(value.data);
      if (userInfoSocketModel.sId == user.id) {
        if (likeAddedSocketModel.postOwner == user.id &&
            likeAddedSocketModel.adder == user.id) {
          myPosts[myPosts.indexWhere(
                  (element) => element.sId == likeAddedSocketModel.postId)]
              .likes
              .add(Likes(
                sId: likeAddedSocketModel.notification.likeId,
                date: likeAddedSocketModel.notification.date,
                id: AuthorId(
                  name: userInfoSocketModel.name,
                  sId: userInfoSocketModel.sId,
                  image: userInfoSocketModel.image,
                ),
              ));
          final ids = myPosts[myPosts.indexWhere(
                  (element) => element.sId == likeAddedSocketModel.postId)]
              .likes
              .map((e) => e.sId)
              .toSet();
          myPosts[myPosts.indexWhere(
                  (element) => element.sId == likeAddedSocketModel.postId)]
              .likes
              .retainWhere((x) => ids.remove(x.sId));
        } else {
          posts[posts.indexWhere(
                  (element) => element.sId == likeAddedSocketModel.postId)]
              .likes
              .add(Likes(
                sId: likeAddedSocketModel.notification.likeId,
                date: likeAddedSocketModel.notification.date,
                id: AuthorId(
                  name: userInfoSocketModel.name,
                  sId: userInfoSocketModel.sId,
                  image: userInfoSocketModel.image,
                ),
              ));
          final ids = posts[posts.indexWhere(
                  (element) => element.sId == likeAddedSocketModel.postId)]
              .likes
              .map((e) => e.sId)
              .toSet();
          posts[posts.indexWhere(
                  (element) => element.sId == likeAddedSocketModel.postId)]
              .likes
              .retainWhere((x) => ids.remove(x.sId));
        }
      }
    });
    notifyListeners();
  }

  Future removedLike({DislikeSocketModel dislikeSocketModel}) async {
    if (dislikeSocketModel.adder == user.id) {
      if (dislikeSocketModel.postOwner == user.id) {
        myPosts[myPosts.indexWhere(
                (element) => element.sId == dislikeSocketModel.postId)]
            .likes
            .removeWhere(
                (element) => element.id.sId == dislikeSocketModel.adder);
      } else {
        posts[posts.indexWhere(
                (element) => element.sId == dislikeSocketModel.postId)]
            .likes
            .removeWhere(
                (element) => element.id.sId == dislikeSocketModel.adder);
      }
    } else {
      myPosts[myPosts.indexWhere(
              (element) => element.sId == dislikeSocketModel.postId)]
          .likes
          .removeWhere((element) => element.id.sId == dislikeSocketModel.adder);
      log(notificationsList.toString());
      notificationsList.removeWhere(
          (element) => element.likeId == dislikeSocketModel.likeId);
    }
    notifyListeners();
  }

  Future removedLikeS({DislikeSocketModel dislikeSocketModel}) async {
    if (dislikeSocketModel.adder == user.id) {
      if (dislikeSocketModel.postOwner == user.id) {
        myPosts[myPosts.indexWhere(
                (element) => element.sId == dislikeSocketModel.postId)]
            .likes
            .removeWhere(
                (element) => element.id.sId == dislikeSocketModel.adder);
      } else {
        posts[posts.indexWhere(
                (element) => element.sId == dislikeSocketModel.postId)]
            .likes
            .removeWhere(
                (element) => element.id.sId == dislikeSocketModel.adder);
      }
    } else {
      myPosts[myPosts.indexWhere(
              (element) => element.sId == dislikeSocketModel.postId)]
          .likes
          .removeWhere((element) => element.id.sId == dislikeSocketModel.adder);
    }
    log('like removed');

    notifyListeners();
  }

  Future commentRemoved({var postId, var comment, String id}) async {
    if (id == user.id) {
      posts[posts.indexWhere((element) => element.sId == postId)]
          .comments
          .removeWhere((element) => element.sId == comment);
    } else {
      myPosts[myPosts.indexWhere((element) => element.sId == postId)]
          .comments
          .removeWhere((element) => element.sId == comment);
      notificationsList.removeWhere((element) => element.commentId == comment);
    }

    notifyListeners();
  }

  Future commentRemovedS({var postId, var comment, String id}) async {
    if (id == user.id) {
      posts[posts.indexWhere((element) => element.sId == postId)]
          .comments
          .removeWhere((element) => element.sId == comment);
    } else {
      myPosts[myPosts.indexWhere((element) => element.sId == postId)]
          .comments
          .removeWhere((element) => element.sId == comment);
      notificationsList.removeWhere((element) => element.commentId == comment);
    }

    notifyListeners();
  }
}
