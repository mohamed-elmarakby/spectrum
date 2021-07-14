import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:graduation_project/constant/constant.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/allChats_model.dart';
import 'package:graduation_project/models/allGroups_model.dart';
import 'package:graduation_project/models/allMyFriends_model.dart';
import 'package:graduation_project/models/allnotifications_model.dart';
import 'package:graduation_project/models/recieved_friend_request.dart';
import 'package:graduation_project/models/socket_models.dart/my_post_model_socket.dart';
import 'package:graduation_project/models/socket_models.dart/user_info_socket_model.dart';
import '../models/allOfCurrentUser_model.dart';

class HomeServices {
  Future<AllOfCurrentUserModel> getAllOfCurrentUser({String userId}) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'allOfCurrent';
    log(url);
    AllOfCurrentUserModel tempAllOfCuurentUserModel = AllOfCurrentUserModel();
    await dio
        .get(
      url,
      options: Options(
        headers: {
          'id': userId,
        },
      ),
    )
        .then(
      (value) {
        print(value.statusCode);
        print(value.data);
        tempAllOfCuurentUserModel = AllOfCurrentUserModel.fromJson(value.data);
      },
    );
    return tempAllOfCuurentUserModel;
  }

  Future<Posts> goToPostApi({String postId}) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'posts';
    log(url);
    Posts post = Posts(likes: [], comments: []);
    await dio.get(url, options: Options(headers: {'id': postId})).then(
      (value) {
        print(value.statusCode);
        print(value.data);
        List likes = value.data['likes'];
        List comments = value.data['comments'];
        log('length of likes = ${likes.length}');
        for (var like in likes) {
          post.likes.add(Likes(
              sId: like['_id'],
              id: AuthorId(sId: like['id']),
              date: like['date']));
        }
        for (var comment in comments) {
          post.comments.add(Comments(
            commenterId: AuthorId(
              name: comment['commenterId']['name'],
              sId: comment['commenterId']['_id'],
              image: comment['commenterId']['image'],
            ),
            isEdited: comment['isEdited'],
            sId: comment['_id'],
            text: comment['text'],
          ));
        }
        post = Posts(
          sId: value.data['_id'],
          date: value.data['date'],
          text: value.data['text'],
          authorId: AuthorId(
              image: value.data['authorId']['image'],
              sId: value.data['authorId']['_id'],
              name: value.data['authorId']['name']),
          image: value.data['image'],
          isEdited: value.data['isEdited'],
        );
      },
    );
    return post;
  }

  Future<List<UserInfoSocketModel>> getAllUsers() async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'users';
    log(url);
    List<UserInfoSocketModel> tempAllUsers = [];
    await dio
        .get(
      url,
    )
        .then(
      (value) {
        print(value.statusCode);
        print(value.data);
        for (var user in value.data) {
          tempAllUsers.add(UserInfoSocketModel(
            name: user['name'],
            sId: user['_id'],
            image: user['image'],
          ));
        }
      },
    );
    return tempAllUsers;
  }

  Future<MyFriendsModel> getAllMyFriends({String userId}) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'friends';
    log(url);
    MyFriendsModel tempAllMyFriends = MyFriendsModel();
    await dio
        .get(
      url,
      options: Options(headers: {
        'userId': userId,
      }),
    )
        .then(
      (value) {
        print(value.statusCode);
        print(value.data);
        tempAllMyFriends = MyFriendsModel.fromJson(value.data);
        log(tempAllMyFriends.toString());
      },
    );
    return tempAllMyFriends;
  }

  Future<List<ReceivedFriendRequestModel>> getSendRequests(
      {String userId}) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'friends/sentRequests';
    log(url);
    List<ReceivedFriendRequestModel> tempSentRequests = [];
    await dio
        .get(
      url,
      options: Options(headers: {
        'userId': userId,
      }),
    )
        .then(
      (value) async {
        print(value.statusCode);
        print(value.data);
        List sentRequests = value.data;
        log('temp friend request list: ' + sentRequests.toString());
        for (var friend in sentRequests) {
          log('friend: ' + friend.toString());
          tempSentRequests.add(ReceivedFriendRequestModel.fromJson(friend));
        }
        final ids = tempSentRequests.map((e) => e.sId).toSet();
        tempSentRequests.retainWhere((x) => ids.remove(x.sId));
        log(tempSentRequests.toString());
      },
    );
    return tempSentRequests;
  }

  Future<List<ReceivedFriendRequestModel>> getFriendRequests(
      {String userId}) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'friends/requests';
    log(url);
    List<ReceivedFriendRequestModel> tempFriendRequests = [];
    await dio
        .get(
      url,
      options: Options(headers: {
        'userId': userId,
      }),
    )
        .then(
      (value) async {
        print(value.statusCode);
        print(value.data);
        List gottenRequests = value.data;
        log('temp friend request list: ' + gottenRequests.toString());
        for (var friend in gottenRequests) {
          log('friend: ' + friend.toString());
          tempFriendRequests.add(ReceivedFriendRequestModel.fromJson(friend));
        }
        final ids = tempFriendRequests.map((e) => e.sId).toSet();
        tempFriendRequests.retainWhere((x) => ids.remove(x.sId));
        log(tempFriendRequests.toString());
      },
    );
    return tempFriendRequests;
  }

  Future<List<AllNotificationsModel>> getMyNotifications(
      {String userId}) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'friends/notifications';
    log(url);
    List<AllNotificationsModel> tempNotifications = [];
    await dio
        .get(
      url,
      options: Options(headers: {
        'userId': userId,
      }),
    )
        .then(
      (value) {
        print(value.statusCode);
        print(value.data);
        List tempData = value.data;
        for (var notification in tempData) {
          log(notification.toString());
          tempNotifications.add(AllNotificationsModel.fromJson(notification));
        }
        final ids = tempNotifications.map((e) => e.sId).toSet();
        tempNotifications.retainWhere((x) => ids.remove(x.sId));
        log(tempNotifications.toString());
      },
    );
    return tempNotifications;
  }

  Future<List<AllChatsModel>> getAllMyChats({String userId}) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'allChats';
    log(url);
    List<AllChatsModel> tempAllChats = [];
    await dio
        .get(
      url,
      options: Options(headers: {
        'userId': userId,
      }),
    )
        .then(
      (value) {
        log('got all chats');
        log(value.statusCode.toString());
        log(value.data.toString());
        List tempData = value.data;
        for (var chat in tempData) {
          log(chat.toString());
          tempAllChats.add(AllChatsModel.fromJson(chat));
        }
        final ids = tempAllChats.map((e) => e.sId).toSet();
        tempAllChats.retainWhere((x) => ids.remove(x.sId));
        log(tempAllChats.toString());
      },
    );
    return tempAllChats;
  }

  Future<List<Posts>> getMyPost({String userId}) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'currentUserPosts';
    log(url);
    List tempPosts = [];
    List<Posts> returnedPostsList = [];
    await dio
        .get(
      url,
      options: Options(
        headers: {
          'id': userId,
        },
      ),
    )
        .then(
      (value) {
        print(value.statusCode);
        print(value.data);
        tempPosts = value.data;
        for (var post in tempPosts) {
          MyPostModel myLikes = MyPostModel.fromJson(post);
          List<Likes> likes = [];
          List<Comments> comments = [];
          for (var like in myLikes.likes) {
            likes.add(Likes(
              date: like.date,
              id: AuthorId(
                sId: like.id,
              ),
              sId: like.sId,
            ));
          }
          print('done adding likes');

          for (var comment in myLikes.comments) {
            comments.add(Comments(
                isEdited: comment.isEdited,
                sId: comment.sId,
                text: comment.text,
                commenterId: AuthorId(
                  image: comment.commenterId.image,
                  name: comment.commenterId.name,
                  sId: comment.commenterId.sId,
                )));
          }
          print('done adding Comments');
          returnedPostsList.add(
            Posts(
              comments: comments,
              date: myLikes.date,
              image: myLikes.image,
              isEdited: myLikes.isEdited,
              likes: likes,
              sId: myLikes.sId,
              text: myLikes.text,
              authorId: AuthorId(
                image: user.image,
                sId: user.id,
                name: user.name,
              ),
            ),
          );
        }
      },
    );
    return returnedPostsList;
  }

  Future<List<Posts>> getExactUserPosts({String userId}) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'currentUserPosts';
    log(url);
    List tempPosts = [];
    List<Posts> returnedPostsList = [];
    await dio
        .get(
      url,
      options: Options(
        headers: {
          'id': userId,
        },
      ),
    )
        .then(
      (value) {
        print(value.statusCode);
        print(value.data);
        tempPosts = value.data;
        for (var post in tempPosts) {
          MyPostModel myLikes = MyPostModel.fromJson(post);
          List<Likes> likes = [];
          List<Comments> comments = [];
          for (var like in myLikes.likes) {
            likes.add(Likes(
              date: like.date,
              id: AuthorId(
                sId: like.id,
              ),
              sId: like.sId,
            ));
          }
          print('done adding likes');

          for (var comment in myLikes.comments) {
            comments.add(Comments(
                isEdited: comment.isEdited,
                sId: comment.sId,
                text: comment.text,
                commenterId: AuthorId(
                  image: comment.commenterId.image,
                  name: comment.commenterId.name,
                  sId: comment.commenterId.sId,
                )));
          }
          print('done adding Comments');
          returnedPostsList.add(
            Posts(
              comments: comments,
              date: myLikes.date,
              image: myLikes.image,
              isEdited: myLikes.isEdited,
              likes: likes,
              sId: myLikes.sId,
              text: myLikes.text,
              authorId: AuthorId(
                image: user.image,
                sId: user.id,
                name: user.name,
              ),
            ),
          );
        }
      },
    );
    return returnedPostsList;
  }

  Future<AllGroupsModel> getAllGroupsApi({String userId}) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'groups';
    log(url);
    log(userId);
    AllGroupsModel allGroupsModel = AllGroupsModel();
    await dio
        .get(
      url,
      options: Options(
        headers: {
          'userId': userId,
        },
      ),
    )
        .then(
      (value) {
        print(value.statusCode);
        print(value.data);
        allGroupsModel = AllGroupsModel.fromJson(value.data);
      },
    );
    return allGroupsModel;
  }

  Future addPostApi({
    String text,
    String password,
  }) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'addNewPost';
    log(url);
    Map post = {
      "text": text,
      "id": user.id,
    };
    log(post.toString());
    await dio
        .post(
      url,
      data: post,
    )
        .then(
      (value) {
        print(value.statusCode);
        print(value.data);
      },
    );
  }

  Future editPostApi({
    String newText,
    String postId,
  }) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'editPost';
    log(url);
    Map post = {
      "newText": newText,
      "postId": postId,
    };
    log(post.toString());
    await dio
        .patch(
      url,
      data: post,
    )
        .then(
      (value) {
        print(value.statusCode);
        print(value.data);
      },
    );
  }
}
